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
	# Armazenamos a resolução como um dicionário de strings para segurança.
	"resolution": {"x": 1920, "y": 1080},
}

var settings: Dictionary = {}
var display_options: Dictionary = {"monitors": []}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	GlobalEvents.load_settings_requested.connect(load_settings)
	GlobalEvents.save_settings_requested.connect(save_settings)
	GlobalEvents.audio_setting_changed.connect(_on_audio_setting_changed)
	GlobalEvents.locale_setting_changed.connect(_on_locale_setting_changed)
	GlobalEvents.monitor_changed.connect(_on_monitor_changed)
	GlobalEvents.window_mode_changed.connect(_on_window_mode_changed)
	GlobalEvents.resolution_changed.connect(_on_resolution_changed)
	
	_detect_display_options()
	load_settings()

func get_display_options() -> Dictionary:
	return display_options

# --- Handlers de Sinais ---

func _on_audio_setting_changed(bus_name: String, linear_volume: float) -> void:
	var key = "%s_volume" % bus_name.to_lower()
	if settings.has(key):
		settings[key] = linear_volume
		var bus_index = AudioServer.get_bus_index(bus_name)
		if bus_index != -1:
			var db_volume = linear_to_db(linear_volume) if linear_volume > 0 else -80.0
			AudioServer.set_bus_volume_db(bus_index, db_volume)

func _on_locale_setting_changed(locale_code: String) -> void:
	settings["locale"] = locale_code
	TranslationServer.set_locale(locale_code)

func _on_monitor_changed(monitor_index: int) -> void:
	settings["monitor_index"] = monitor_index
	# A aplicação real da tela cheia em um monitor específico é mais complexa
	# e geralmente feita ao mudar o modo de janela.
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_current_screen(monitor_index)

func _on_window_mode_changed(mode: int) -> void:
	settings["window_mode"] = mode
	DisplayServer.window_set_mode(mode)
	# Se for para tela cheia, aplica no monitor correto.
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_current_screen(settings.get("monitor_index", 0))

func _on_resolution_changed(resolution: Vector2i) -> void:
	settings["resolution"] = {"x": resolution.x, "y": resolution.y}
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(resolution)

# --- Lógica de Save/Load ---

func save_settings() -> void:
	_save_settings_to_file(settings)
	print("Configurações salvas com sucesso em: %s" % SETTINGS_PATH)

func load_settings() -> void:
	settings = _load_settings_from_file()
	_apply_all_settings()

# --- Funções Internas ---

func _detect_display_options() -> void:
	display_options.monitors.clear()
	var screen_count = DisplayServer.get_screen_count()
	print("SettingsManager: Detectados %d monitores." % screen_count)

	# WORKAROUND: Usando uma lista de resoluções comuns porque a detecção automática está falhando.
	var common_resolutions = [
		Vector2i(1280, 720),
		Vector2i(1366, 768),
		Vector2i(1600, 900),
		Vector2i(1920, 1080),
		Vector2i(2560, 1440),
		Vector2i(3840, 2160)
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
	_on_audio_setting_changed("Master", settings.get("master_volume", 1.0))
	_on_audio_setting_changed("Music", settings.get("music_volume", 1.0))
	_on_audio_setting_changed("SFX", settings.get("sfx_volume", 1.0))
	_on_locale_setting_changed(settings.get("locale", "pt_BR"))
	
	# Aplica as configurações de vídeo
	var window_mode = settings.get("window_mode", DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_mode(window_mode)
	
	var monitor_idx = settings.get("monitor_index", 0)
	if window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_current_screen(monitor_idx)

	var res_dict = settings.get("resolution", {"x": 1920, "y": 1080})
	var resolution = Vector2i(res_dict.x, res_dict.y)
	if window_mode != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(resolution)
	
	GlobalEvents.settings_loaded.emit(settings)
	print("Configurações aplicadas.")

func _load_settings_from_file() -> Dictionary:
	if not FileAccess.file_exists(SETTINGS_PATH):
		print("Nenhum arquivo de configurações encontrado. Usando padrões.")
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
	else:
		printerr("Falha ao salvar as configurações em: %s" % SETTINGS_PATH)
