extends Control

const SETTINGS_PATH = "user://settings.json"

# Usamos valores simples e literais para evitar problemas de parse.
const DEFAULT_SETTINGS = {
	# Audio
	"master_volume": 1.0,
	"sfx_volume": 1.0,
	"music_volume": 1.0,
	"locale": "pt_BR",
	# Video
	"monitor_index": 0,
	"window_mode": DisplayServer.WINDOW_MODE_WINDOWED,
	"resolution": {"x": 1920, "y": 1080},
	"field_of_view": 70.0, # Valor padrão para FOV
	"aspect_ratio": 0, # 0 para 16:9, 1 para 4:3, etc.
	"dynamic_render_scale_mode": 0, # 0: Off, 1: Custom
	"render_scale": 1.0, # 0.5 a 2.0
	"frame_rate_limit_mode": 0, # 0: Custom, 1: 30, 2: 60, etc.
	"max_frame_rate": 60, # FPS máximo
	"vsync_mode": DisplayServer.VSYNC_ENABLED, # 0: Disabled, 1: Enabled, 2: Adaptive
	"triple_buffering": false,
	"reduce_buffering": false,
	"low_latency_mode": 0, # 0: Off, 1: Enabled, 2: Enabled + Boost
	"gamma_correction": 2.2,
	"contrast": 1.0,
	"brightness": 1.0,
	"hdr_mode": 0, # 0: Off, 1: On
	"shaders_quality": 2, # 0: Low, 1: Medium, 2: High
	"effects_quality": 2, # 0: Low, 1: Medium, 2: High
	"colorblind_mode": 0, # 0: Off, 1: Protanopia, 2: Deuteranopia, 3: Tritanopia
	"reduce_screen_shake": false,
	# UI
	"ui_scale_preset": "medium", # Novo: "small", "medium", "large"
}

var _current_settings: Dictionary = {} # Configurações aplicadas em tempo real
var _saved_settings: Dictionary = {} # Últimas configurações salvas no arquivo
var display_options: Dictionary = {"monitors": []}

@onready var scene_manager: SceneManager = get_node("/root/SceneManager") # Referência ao SceneManager

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	GlobalEvents.load_settings_requested.connect(load_settings)
	GlobalEvents.save_settings_requested.connect(save_settings)
	GlobalEvents.audio_setting_changed.connect(_on_audio_setting_changed)
	GlobalEvents.locale_setting_changed.connect(_on_locale_setting_changed)
	GlobalEvents.monitor_changed.connect(_on_monitor_changed)
	GlobalEvents.video_window_mode_changed.connect(_on_window_mode_changed)
	GlobalEvents.video_resolution_changed.connect(_on_resolution_changed)
	
	GlobalEvents.field_of_view_changed.connect(_on_field_of_view_changed)
	GlobalEvents.aspect_ratio_changed.connect(_on_aspect_ratio_changed)
	GlobalEvents.dynamic_render_scale_changed.connect(_on_dynamic_render_scale_changed)
	GlobalEvents.render_scale_changed.connect(_on_render_scale_changed)
	GlobalEvents.ui_scale_preset_changed.connect(_on_ui_scale_preset_changed)
	GlobalEvents.frame_rate_limit_changed.connect(_on_frame_rate_limit_changed)
	GlobalEvents.max_frame_rate_changed.connect(_on_max_frame_rate_changed)
	GlobalEvents.vsync_mode_changed.connect(_on_vsync_mode_changed)
	GlobalEvents.triple_buffering_changed.connect(_on_triple_buffering_changed)
	GlobalEvents.reduce_buffering_changed.connect(_on_reduce_buffering_changed)
	GlobalEvents.low_latency_mode_changed.connect(_on_low_latency_mode_changed)
	GlobalEvents.gamma_correction_changed.connect(_on_gamma_correction_changed)
	GlobalEvents.contrast_changed.connect(_on_contrast_changed)
	GlobalEvents.brightness_changed.connect(_on_brightness_changed)
	GlobalEvents.hdr_mode_changed.connect(_on_hdr_mode_changed)
	GlobalEvents.shaders_quality_changed.connect(_on_shaders_quality_changed)
	GlobalEvents.effects_quality_changed.connect(_on_effects_quality_changed)
	GlobalEvents.colorblind_mode_changed.connect(_on_colorblind_mode_changed)
	GlobalEvents.reduce_screen_shake_changed.connect(_on_reduce_screen_shake_changed)
	
	_detect_display_options()
	load_settings() # Carrega as configurações salvas e as aplica

func get_display_options() -> Dictionary:
	return display_options

# --- Handlers de Sinais (Atualizam _current_settings e aplicam em tempo real) ---

func _on_audio_setting_changed(bus_name: String, linear_volume: float) -> void:
	var key = "%s_volume" % bus_name.to_lower()
	if _current_settings.has(key):
		_current_settings[key] = linear_volume
		var bus_index = AudioServer.get_bus_index(bus_name)
		if bus_index != -1:
			var db_volume = linear_to_db(linear_volume) if linear_volume > 0 else -80.0
			AudioServer.set_bus_volume_db(bus_index, db_volume)

func _on_locale_setting_changed(locale_code: String) -> void:
	_current_settings["locale"] = locale_code
	TranslationServer.set_locale(locale_code)

func _on_monitor_changed(monitor_index: int) -> void:
	_current_settings["monitor_index"] = monitor_index
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_current_screen(monitor_index)

func _on_window_mode_changed(mode: int) -> void:
	_current_settings["window_mode"] = mode
	DisplayServer.window_set_mode(mode)
	var monitor_idx = _current_settings.get("monitor_index", 0)
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_current_screen(monitor_idx)
	elif mode == DisplayServer.WINDOW_MODE_WINDOWED:
		_center_window_on_monitor(monitor_idx)

func _on_resolution_changed(resolution: Vector2i) -> void:
	_current_settings["resolution"] = {"x": resolution.x, "y": resolution.y}
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(resolution)

func _on_field_of_view_changed(fov_value: float) -> void:
	_current_settings["field_of_view"] = fov_value
	# Lógica para aplicar FOV (pode envolver a câmera do jogador)
	# Ex: get_viewport().get_camera_3d().fov = fov_value

func _on_aspect_ratio_changed(aspect_ratio_index: int) -> void:
	_current_settings["aspect_ratio"] = aspect_ratio_index
	# Lógica para aplicar Aspect Ratio (pode envolver o viewport ou câmera)
	# Ex: get_viewport().set_aspect_ratio_mode(...)

func _on_dynamic_render_scale_changed(mode: int) -> void:
	_current_settings["dynamic_render_scale_mode"] = mode
	# Lógica para ativar/desativar escala de renderização dinâmica
	# Ex: ProjectSettings.set_setting("rendering/scaling_3d/mode", mode)

func _on_render_scale_changed(scale_value: float) -> void:
	_current_settings["render_scale"] = scale_value
	_apply_render_scale_to_viewport(scale_value)

func _apply_render_scale_to_viewport(scale_value: float) -> void:
	if not scene_manager or not scene_manager.game_viewport:
		# Defer application if SceneManager or its viewport is not yet ready
		return

	var base_width = DisplayServer.window_get_size().x
	var base_height = DisplayServer.window_get_size().y

	var new_viewport_width = int(base_width * scale_value)
	var new_viewport_height = int(base_height * scale_value)

	new_viewport_width = max(1, new_viewport_width)
	new_viewport_height = max(1, new_viewport_height)

	scene_manager.game_viewport.size = Vector2i(new_viewport_width, new_viewport_height)
	print("Resolução de renderização do GameViewport ajustada para: ", scene_manager.game_viewport.size)

func _on_frame_rate_limit_changed(mode: int) -> void:
	_current_settings["frame_rate_limit_mode"] = mode
	# Lógica para definir o modo de limite de FPS
	# Ex: Engine.set_max_fps(settings["max_frame_rate"]) ou 0 para ilimitado

func _on_max_frame_rate_changed(fps_value: int) -> void:
	_current_settings["max_frame_rate"] = fps_value
	if _current_settings["frame_rate_limit_mode"] == 0: # Se for "Custom"
		Engine.set_max_fps(fps_value)

func _on_vsync_mode_changed(mode: int) -> void:
	_current_settings["vsync_mode"] = mode
	DisplayServer.window_set_vsync_mode(mode)

func _on_triple_buffering_changed(enabled: bool) -> void:
	_current_settings["triple_buffering"] = enabled
	# Godot gerencia isso internamente com VSync, mas pode haver opções de projeto.
	# Ex: ProjectSettings.set_setting("rendering/v_sync/use_adaptive_vsync", enabled)

func _on_reduce_buffering_changed(enabled: bool) -> void:
	_current_settings["reduce_buffering"] = enabled
	# Lógica para reduzir o buffer (pode ser complexo, talvez via ProjectSettings ou custom)

func _on_low_latency_mode_changed(mode: int) -> void:
	_current_settings["low_latency_mode"] = mode
	# Lógica para ativar/desativar modo de baixa latência (similar ao Nvidia Reflex)
	# Pode ser uma combinação de VSync, buffer, etc.

func _on_gamma_correction_changed(gamma_value: float) -> void:
	_current_settings["gamma_correction"] = gamma_value
	# Lógica para aplicar correção gama (geralmente via Environment ou Shader)
	# Ex: get_viewport().world_3d.environment.adjustment_gamma = gamma_value

func _on_contrast_changed(contrast_value: float) -> void:
	_current_settings["contrast"] = contrast_value
	# Lógica para aplicar contraste (geralmente via Environment ou Shader)
	# Ex: get_viewport().world_3d.environment.adjustment_contrast = contrast_value

func _on_brightness_changed(brightness_value: float) -> void:
	_current_settings["brightness"] = brightness_value
	# Lógica para aplicar brilho (geralmente via Environment ou Shader)
	# Ex: get_viewport().world_3d.environment.adjustment_brightness = brightness_value

func _on_hdr_mode_changed(mode: int) -> void:
	_current_settings["hdr_mode"] = mode
	# Lógica para ativar/desativar HDR (DisplayServer ou ProjectSettings)
	# Ex: DisplayServer.window_set_use_vsync(mode == 1)

func _on_shaders_quality_changed(quality_level: int) -> void:
	_current_settings["shaders_quality"] = quality_level
	# Lógica para ajustar qualidade de shaders (ProjectSettings ou via Material/Shader)
	# Ex: ProjectSettings.set_setting("rendering/quality/shader_quality", quality_level)

func _on_effects_quality_changed(quality_level: int) -> void:
	_current_settings["effects_quality"] = quality_level
	# Lógica para ajustar qualidade de efeitos (ProjectSettings ou via nós de partículas/post-processamento)

func _on_colorblind_mode_changed(mode: int) -> void:
	_current_settings["colorblind_mode"] = mode
	# Lógica para aplicar modo daltônico (geralmente via ColorCorrection ou Shader global)

func _on_reduce_screen_shake_changed(enabled: bool) -> void:
	_current_settings["reduce_screen_shake"] = enabled
	# Lógica para reduzir/desativar vibração da tela (pode ser um multiplicador em um script de câmera)

func _on_ui_scale_preset_changed(preset_name: String) -> void:
	_current_settings["ui_scale_preset"] = preset_name
	_apply_ui_scale_preset(preset_name)

func _apply_ui_scale_preset(preset_name: String) -> void:
	var scale_factor: float = 1.0
	match preset_name:
		"small":
			scale_factor = 0.75
		"medium":
			scale_factor = 1.0
		"large":
			scale_factor = 1.25
		_:
			push_warning("Preset de UI desconhecido: " + preset_name)
			return

	get_window().content_scale_factor = scale_factor
	print("Escala da UI ajustada para: ", preset_name, " (", scale_factor, ")")

# --- Lógica de Save/Load ---

func save_settings() -> void:
	_saved_settings = _current_settings.duplicate(true) # Copia as configurações atuais para as salvas
	_save_settings_to_file(_saved_settings)
	print("Configurações salvas com sucesso em: %s" % SETTINGS_PATH)

func load_settings() -> void:
	_saved_settings = _load_settings_from_file()
	_current_settings = _saved_settings.duplicate(true) # Carrega as salvas para as atuais
	_apply_all_settings()
	GlobalEvents.settings_loaded.emit(_current_settings) # Emite para os controles de UI
	print("Configurações carregadas e aplicadas.")

# --- Funções Internas ---

func _detect_display_options() -> void:
	display_options.monitors.clear()
	var screen_count = DisplayServer.get_screen_count()
	print("SettingsManager: Detectados %d monitores." % screen_count)

	# WORKAROUND: Usando uma lista de resoluções comuns porque a detecção automática está falhando.
	var common_resolutions = [
		Vector2i(568, 320),
		Vector2i(640, 480),
		Vector2i(960, 540),
		Vector2i(1280, 720),
		Vector2i(1366, 768),
		Vector2i(1600, 900),
		Vector2i(1920, 1080),
		Vector2i(2560, 1440),
		Vector2i(3840, 2160),
		Vector2i(7680, 4320) # 8K
	]

	for i in range(screen_count):
		var monitor_info = {
			"id": i,
			"size": DisplayServer.screen_get_size(i),
			"refresh_rate": DisplayServer.screen_get_refresh_rate(i),
			"resolutions": common_resolutions # Usando a lista fixa
		}
		display_options.monitors.append(monitor_info)
		print("  - Monitor %d: %s, %f Hz" % [i, str(monitor_info.size), monitor_info.refresh_rate])

func _apply_all_settings() -> void:
	# Aplica as configurações de áudio
	_on_audio_setting_changed("Master", _current_settings.get("master_volume", 1.0))
	_on_audio_setting_changed("Music", _current_settings.get("music_volume", 1.0))
	_on_audio_setting_changed("SFX", _current_settings.get("sfx_volume", 1.0))
	_on_locale_setting_changed(_current_settings.get("locale", "pt_BR"))
	
	# Aplica as configurações de vídeo
	var window_mode = _current_settings.get("window_mode", DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_mode(window_mode)
	
	var monitor_idx = _current_settings.get("monitor_index", 0)
	if window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_current_screen(monitor_idx)
	elif window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		_center_window_on_monitor(monitor_idx)

	var res_dict = _current_settings.get("resolution", {"x": 1920, "y": 1080})
	var resolution = Vector2i(res_dict.x, res_dict.y)
	if window_mode != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(resolution)
	
	# NOVAS APLICAÇÕES DE CONFIGURAÇÕES DE VÍDEO
	_on_field_of_view_changed(_current_settings.get("field_of_view", DEFAULT_SETTINGS.field_of_view))
	_on_aspect_ratio_changed(_current_settings.get("aspect_ratio", DEFAULT_SETTINGS.aspect_ratio))
	_on_dynamic_render_scale_changed(_current_settings.get("dynamic_render_scale_mode", DEFAULT_SETTINGS.dynamic_render_scale_mode))
	_apply_render_scale_to_viewport(_current_settings.get("render_scale", DEFAULT_SETTINGS.render_scale))
	_on_frame_rate_limit_changed(_current_settings.get("frame_rate_limit_mode", DEFAULT_SETTINGS.frame_rate_limit_mode))
	_on_max_frame_rate_changed(_current_settings.get("max_frame_rate", DEFAULT_SETTINGS.max_frame_rate))
	_on_vsync_mode_changed(_current_settings.get("vsync_mode", DEFAULT_SETTINGS.vsync_mode))
	_on_triple_buffering_changed(_current_settings.get("triple_buffering", DEFAULT_SETTINGS.triple_buffering))
	_on_reduce_buffering_changed(_current_settings.get("reduce_buffering", DEFAULT_SETTINGS.reduce_buffering))
	_on_low_latency_mode_changed(_current_settings.get("low_latency_mode", DEFAULT_SETTINGS.low_latency_mode))
	_on_gamma_correction_changed(_current_settings.get("gamma_correction", DEFAULT_SETTINGS.gamma_correction))
	_on_contrast_changed(_current_settings.get("contrast", DEFAULT_SETTINGS.contrast))
	_on_brightness_changed(_current_settings.get("brightness", DEFAULT_SETTINGS.brightness))
	_on_hdr_mode_changed(_current_settings.get("hdr_mode", DEFAULT_SETTINGS.hdr_mode))
	_on_shaders_quality_changed(_current_settings.get("shaders_quality", DEFAULT_SETTINGS.shaders_quality))
	_on_effects_quality_changed(_current_settings.get("effects_quality", DEFAULT_SETTINGS.effects_quality))
	_on_colorblind_mode_changed(_current_settings.get("colorblind_mode", DEFAULT_SETTINGS.colorblind_mode))
	_on_reduce_screen_shake_changed(_current_settings.get("reduce_screen_shake", DEFAULT_SETTINGS.reduce_screen_shake))
	_apply_ui_scale_preset(_current_settings.get("ui_scale_preset", DEFAULT_SETTINGS.ui_scale_preset))
	
	print("Configurações aplicadas.")

func _center_window_on_monitor(monitor_idx: int) -> void:
	var monitor_position = DisplayServer.screen_get_position(monitor_idx)
	var monitor_size = DisplayServer.screen_get_size(monitor_idx)
	var window_size = DisplayServer.window_get_size()
	var new_position = monitor_position + (monitor_size / 2) - (window_size / 2)
	DisplayServer.window_set_position(new_position)

func _load_settings_from_file() -> Dictionary:
	if not FileAccess.file_exists(SETTINGS_PATH):
		print("Nenhum arquivo de configurações encontrado. Usando padrões.")
		_save_settings_to_file(DEFAULT_SETTINGS.duplicate(true))
		return DEFAULT_SETTINGS.duplicate(true)
		
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var parse_result = JSON.parse_string(json_string)
		if parse_result is Dictionary:
			return parse_result
	
	printerr("Arquivo de configurações corrompido. Usando padrões.")
	return DEFAULT_SETTINGS.duplicate(true)

func _save_settings_to_file(data_to_save: Dictionary) -> void:
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(data_to_save, "  ")
		file.store_string(json_string)
	elif file == null:
		printerr("Falha ao salvar as configurações em: %s" % SETTINGS_PATH)