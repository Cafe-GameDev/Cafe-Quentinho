extends Node

const SETTINGS_PATH = "user://settings.json"

# Usamos valores simples e literais para evitar problemas de parse.
const DEFAULT_SETTINGS = {
	"audio": {
		"master_volume": 1.0,
		"sfx_volume": 1.0,
		"music_volume": 1.0,
	},
	"locale": "pt_BR",
	"video": {
		"monitor_index": 0,
		"window_mode": DisplayServer.WINDOW_MODE_WINDOWED,
		"resolution": {"x": 1280, "y": 720},
		"field_of_view": 70.0, # Valor padrão para FOV
		"aspect_ratio": 0, # 0 para 16:9, 1 para 4:3, etc.
		"dynamic_render_scale_mode": 0, # 0: Off, 1: Custom
		"upscaling_mode": 0, # 0: Off, 1: FSR, 2: NIS
		"upscaling_quality": 2, # 0: Low, 1: Medium, 2: High
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
	},
	"ui_scale_preset": "medium", # Novo: "small", "medium", "large"
	
}

var settings: Dictionary = {}
var display_options: Dictionary = {"monitors": []}

@onready var scene_manager: SceneManager = get_node("/root/SceneManager") # Referência ao SceneManager

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Inicializa settings com a estrutura padrão aninhada
	settings = DEFAULT_SETTINGS.duplicate(true)
	
	# Conexões para o padrão de 5 sinais de Settings
	print("SettingsManager: Conectando request_loading_settings_changed...")
	GlobalEvents.request_loading_settings_changed.connect(load_settings)
	print("SettingsManager: Conectando request_saving_settings_changed...")
	GlobalEvents.request_saving_settings_changed.connect(save_settings)
	print("SettingsManager: Conectando request_reset_settings_changed...")
	GlobalEvents.request_reset_settings_changed.connect(reset_settings)
	print("SettingsManager: Conectando setting_changed...")
	GlobalEvents.setting_changed.connect(_on_setting_changed_live)
	print("SettingsManager: Conectando language_changed...")
	GlobalEvents.language_changed.connect(_on_language_changed_live) # Para mudanças de idioma

	_detect_display_options()
	load_settings()
	

func get_display_options() -> Dictionary:
	return display_options

# --- Handlers de Sinais ---

func _on_setting_changed_live(change_data: Dictionary) -> void:
	# Atualiza as configurações em tempo real com base no dicionário recebido.
	# Este método agora espera um dicionário aninhado (ex: {"audio": {"master_volume": value}})
	for category_key in change_data:
		if settings.has(category_key) and typeof(settings[category_key]) == TYPE_DICTIONARY and typeof(change_data[category_key]) == TYPE_DICTIONARY:
			# Se for um dicionário aninhado (ex: "audio", "video"), mescla as mudanças
			for setting_key in change_data[category_key]:
				if settings[category_key].has(setting_key):
					settings[category_key][setting_key] = change_data[category_key][setting_key]
				else:
					push_warning("SettingsManager: Tentativa de alterar configuração desconhecida dentro da categoria '" + category_key + "': " + setting_key)
		elif settings.has(category_key):
			# Se for uma configuração de nível superior (ex: "locale", "ui_scale_preset")
			settings[category_key] = change_data[category_key]
		else:
			push_warning("SettingsManager: Tentativa de alterar categoria de configuração desconhecida: " + category_key)
	_apply_all_settings() # Aplica as configurações imediatamente

func _on_language_changed_live(change_data: Dictionary) -> void:
	var locale_code = change_data.get("language", {}).get("locale", "pt_BR") 
	settings["locale"] = locale_code
	TranslationServer.set_locale(locale_code)
	_apply_all_settings() # Reaplicar para garantir que a UI seja atualizada

func _on_request_live_settings_data() -> void:
	GlobalEvents.live_settings_data_provided.emit(settings)

func _on_request_live_language_data() -> void:
	GlobalEvents.live_language_data_provided.emit({"locale": settings.get("locale", "pt_BR")})

# --- Lógica de Save/Load ---

func save_settings() -> void:
	_save_settings_to_file(settings)
	_apply_all_settings()
	print("Configurações salvas com sucesso em: %s" % SETTINGS_PATH)
	GlobalEvents.settings_data_save_requested.emit(settings) # Emitir sinal de que as configurações foram salvas

func load_settings() -> void:
	settings = _load_settings_from_file()
	_apply_all_settings()
	GlobalEvents.loading_settings_changed.emit(settings) # Emitir sinal de que as configurações foram carregadas

func reset_settings() -> void:
	settings = DEFAULT_SETTINGS.duplicate(true)
	save_settings() # Salva as configurações padrão
	print("Configurações resetadas para o padrão.")




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
	var master_volume = settings.get("audio", {}).get("master_volume", DEFAULT_SETTINGS["audio"]["master_volume"])
	var music_volume = settings.get("audio", {}).get("music_volume", DEFAULT_SETTINGS["audio"]["music_volume"])
	var sfx_volume = settings.get("audio", {}).get("sfx_volume", DEFAULT_SETTINGS["audio"]["sfx_volume"])
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))

	# Aplica as configurações de idioma
	TranslationServer.set_locale(settings.get("locale", DEFAULT_SETTINGS["locale"]))
	
	# Aplica as configurações de vídeo
	var video_settings = settings.get("video", {})
	var window_mode = video_settings.get("window_mode", DEFAULT_SETTINGS["video"]["window_mode"])
	DisplayServer.window_set_mode(window_mode)
	print("Window Mode: ",DisplayServer.window_get_mode())
	
	
	var monitor_idx = video_settings.get("monitor_index", DEFAULT_SETTINGS["video"]["monitor_index"])
	if window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_current_screen(monitor_idx)
	elif window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		_center_window_on_monitor(monitor_idx)

	var res_dict = video_settings.get("resolution", DEFAULT_SETTINGS["video"]["resolution"])
	var resolution = Vector2i(res_dict.x, res_dict.y)
	if window_mode != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(resolution)
	
	# Aplica as configurações de vídeo restantes
	_apply_field_of_view(video_settings.get("field_of_view", DEFAULT_SETTINGS["video"]["field_of_view"]))
	_apply_aspect_ratio(video_settings.get("aspect_ratio", DEFAULT_SETTINGS["video"]["aspect_ratio"]))
	_apply_dynamic_render_scale_mode(video_settings.get("dynamic_render_scale_mode", DEFAULT_SETTINGS["video"]["dynamic_render_scale_mode"]))
	_apply_render_scale_to_viewport(video_settings.get("render_scale", DEFAULT_SETTINGS["video"]["render_scale"]))
	_apply_frame_rate_limit_mode(video_settings.get("frame_rate_limit_mode", DEFAULT_SETTINGS["video"]["frame_rate_limit_mode"]))
	_apply_max_frame_rate(video_settings.get("max_frame_rate", DEFAULT_SETTINGS["video"]["max_frame_rate"]))
	_apply_vsync_mode(video_settings.get("vsync_mode", DEFAULT_SETTINGS["video"]["vsync_mode"]))
	_apply_triple_buffering(video_settings.get("triple_buffering", DEFAULT_SETTINGS["video"]["triple_buffering"]))
	_apply_reduce_buffering(video_settings.get("reduce_buffering", DEFAULT_SETTINGS["video"]["reduce_buffering"]))
	_apply_low_latency_mode(video_settings.get("low_latency_mode", DEFAULT_SETTINGS["video"]["low_latency_mode"]))
	_apply_gamma_correction(video_settings.get("gamma_correction", DEFAULT_SETTINGS["video"]["gamma_correction"]))
	_apply_contrast(video_settings.get("contrast", DEFAULT_SETTINGS["video"]["contrast"]))
	_apply_brightness(video_settings.get("brightness", DEFAULT_SETTINGS["video"]["brightness"]))
	_apply_hdr_mode(video_settings.get("hdr_mode", DEFAULT_SETTINGS["video"]["hdr_mode"]))
	_apply_shaders_quality(video_settings.get("shaders_quality", DEFAULT_SETTINGS["video"]["shaders_quality"]))
	_apply_effects_quality(video_settings.get("effects_quality", DEFAULT_SETTINGS["video"]["effects_quality"]))
	_apply_colorblind_mode(video_settings.get("colorblind_mode", DEFAULT_SETTINGS["video"]["colorblind_mode"]))
	_apply_reduce_screen_shake(video_settings.get("reduce_screen_shake", DEFAULT_SETTINGS["video"]["reduce_screen_shake"]))
	_apply_ui_scale_preset(settings.get("ui_scale_preset", DEFAULT_SETTINGS["ui_scale_preset"]))
	
	print("Configurações aplicadas.")
	print("DEBUG: _apply_all_settings - settings: ", settings)



func _apply_field_of_view(_fov_value: float) -> void:
	# Lógica para aplicar FOV (pode envolver a câmera do jogador)
	# Ex: get_viewport().get_camera_3d().fov = fov_value
	pass

func _apply_aspect_ratio(_aspect_ratio_index: int) -> void:
	# Lógica para aplicar Aspect Ratio (pode envolver o viewport ou câmera)
	# Ex: get_viewport().set_aspect_ratio_mode(...)
	pass

func _apply_dynamic_render_scale_mode(_mode: int) -> void:
	# Lógica para ativar/desativar escala de renderização dinâmica
	# Ex: ProjectSettings.set_setting("rendering/scaling_3d/mode", mode)
	pass

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

func _apply_frame_rate_limit_mode(_mode: int) -> void:
	# Lógica para definir o modo de limite de FPS
	# Ex: Engine.set_max_fps(settings["max_frame_rate"]) ou 0 para ilimitado
	pass

func _apply_max_frame_rate(fps_value: int) -> void:
	if settings.has("frame_rate_limit_mode") and settings["frame_rate_limit_mode"] == 0: # Se for "Custom"
		Engine.set_max_fps(fps_value)

func _apply_vsync_mode(mode: int) -> void:
	DisplayServer.window_set_vsync_mode(mode)

func _apply_triple_buffering(_enabled: bool) -> void:
	# Godot gerencia isso internamente com VSync, mas pode haver opções de projeto.
	# Ex: ProjectSettings.set_setting("rendering/v_sync/use_adaptive_vsync", enabled)
	pass

func _apply_reduce_buffering(_enabled: bool) -> void:
	# Lógica para reduzir o buffer (pode ser complexo, talvez via ProjectSettings ou custom)
	pass

func _apply_low_latency_mode(_mode: int) -> void:
	# Lógica para ativar/desativar modo de baixa latência (similar ao Nvidia Reflex)
	# Pode ser uma combinação de VSync, buffer, etc.
	pass

func _apply_gamma_correction(_gamma_value: float) -> void:
	# Lógica para aplicar correção gama (geralmente via Environment ou Shader)
	# Ex: get_viewport().world_3d.environment.adjustment_gamma = gamma_value
	pass

func _apply_contrast(_contrast_value: float) -> void:
	# Lógica para aplicar contraste (geralmente via Environment ou Shader)
	# Ex: get_viewport().world_3d.environment.adjustment_contrast = contrast_value
	pass

func _apply_brightness(_brightness_value: float) -> void:
	# Lógica para aplicar brilho (geralmente via Environment ou Shader)
	# Ex: get_viewport().world_3d.environment.adjustment_brightness = brightness_value
	pass

func _apply_hdr_mode(_mode: int) -> void:
	# Lógica para ativar/desativar HDR (DisplayServer ou ProjectSettings)
	# Ex: DisplayServer.window_set_use_vsync(mode == 1)
	pass

func _apply_shaders_quality(_quality_level: int) -> void:
	# Lógica para ajustar qualidade de shaders (ProjectSettings ou via Material/Shader)
	# Ex: ProjectSettings.set_setting("rendering/quality/shader_quality", quality_level)
	pass

func _apply_effects_quality(_quality_level: int) -> void:
	# Lógica para ajustar qualidade de efeitos (ProjectSettings ou via nós de partículas/post-processamento)
	pass

func _apply_colorblind_mode(_mode: int) -> void:
	# Lógica para aplicar modo daltônico (geralmente via ColorCorrection ou Shader global)
	pass

func _apply_reduce_screen_shake(_enabled: bool) -> void:
	# Lógica para reduzir/desativar vibração da tela (pode ser um multiplicador em um script de câmera)
	pass

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

func _center_window_on_monitor(monitor_idx: int) -> void:
	var monitor_position = DisplayServer.screen_get_position(monitor_idx)
	var monitor_size = DisplayServer.screen_get_size(monitor_idx)
	var window_size = DisplayServer.window_get_size()
	var new_position = monitor_position + (monitor_size / 2) - (window_size / 2)
	DisplayServer.window_set_position(new_position)

func _load_settings_from_file() -> Dictionary:
	var loaded_settings: Dictionary = DEFAULT_SETTINGS.duplicate(true) # Começa com os padrões

	if not FileAccess.file_exists(SETTINGS_PATH):
		print("SettingsManager: Nenhum arquivo de configurações encontrado em %s. Usando padrões e salvando." % SETTINGS_PATH)
		_save_settings_to_file(loaded_settings) # Salva os padrões imediatamente
		return loaded_settings

	print("SettingsManager: Tentando carregar configurações de: %s" % SETTINGS_PATH)
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		print("SettingsManager: Conteúdo lido: ", json_string)
		var parse_result = JSON.parse_string(json_string)
		if parse_result is Dictionary:
			# Itera sobre DEFAULT_SETTINGS para garantir a estrutura correta
			for key in loaded_settings:
				if parse_result.has(key):
					if typeof(loaded_settings[key]) == TYPE_DICTIONARY and typeof(parse_result[key]) == TYPE_DICTIONARY:
						# Mescla dicionários aninhados (ex: "audio", "video")
						for sub_key in loaded_settings[key]:
							if parse_result[key].has(sub_key):
								loaded_settings[key][sub_key] = parse_result[key][sub_key]
						# Specific handling for 'resolution' within 'video'
						if key == "video" and loaded_settings[key].has("resolution"):
							var loaded_res = loaded_settings[key]["resolution"]
							if typeof(loaded_res) == TYPE_STRING:
								# Attempt to parse string like "(1920, 1080)"
								var clean_res = loaded_res.replace("(", "").replace(")", "").replace(" ", "")
								var parts = clean_res.split(",")
								if parts.size() == 2 and parts[0].is_valid_int() and parts[1].is_valid_int():
									loaded_settings[key]["resolution"] = {"x": int(parts[0]), "y": int(parts[1])}
								else:
									push_warning("SettingsManager: Resolução inválida carregada como string: " + loaded_res + ". Usando padrão.")
									loaded_settings[key]["resolution"] = DEFAULT_SETTINGS["video"]["resolution"]
							elif typeof(loaded_res) != TYPE_DICTIONARY or not loaded_res.has("x") or not loaded_res.has("y"):
								push_warning("SettingsManager: Resolução carregada com formato inválido. Usando padrão.")
								loaded_settings[key]["resolution"] = DEFAULT_SETTINGS["video"]["resolution"]
					else:
						# Atualiza configurações de nível superior (ex: "locale", "ui_scale_preset")
						loaded_settings[key] = parse_result[key]
			print("SettingsManager: Configurações finais após mesclagem: ", loaded_settings)
			return loaded_settings

	printerr("SettingsManager: Arquivo de configurações corrompido em %s. Usando padrões e salvando." % SETTINGS_PATH)
	_save_settings_to_file(loaded_settings) # Salva os padrões se o arquivo estiver corrompido
	print("DEBUG: _load_settings_from_file - loaded_settings: ", loaded_settings)
	return loaded_settings

func _save_settings_to_file(data_to_save: Dictionary) -> void:
	print("SettingsManager: Tentando salvar configurações em: %s" % SETTINGS_PATH)
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(data_to_save, "  ")
		file.store_string(json_string)
		print("SettingsManager: Conteúdo salvo: ", json_string)
	else:
		printerr("SettingsManager: Falha ao salvar as configurações em: %s" % SETTINGS_PATH)
	print("DEBUG: _save_settings_to_file - data_to_save: ", data_to_save)
