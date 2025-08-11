extends Node

const SETTINGS_PATH = "user://settings.cfg"

var settings: Dictionary = {
	"audio": {
		"master_volume": 1.0,
		"music_volume": 1.0,
		"sfx_volume": 1.0
	},
	"video": {
		"resolution": "1920x1080",
		"fullscreen": false,
		"vsync": true,
		"fps_limit": 0 # 0 means unlimited
	}
}

func _ready() -> void:
	load_settings()
	apply_settings()

func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	if err != OK:
		save_settings() # Salva as configurações padrão se não houver arquivo
		return

	for section in ["audio", "video"]:
		for key in settings[section]:
			var value = config.get_value(section, key, settings[section][key])
			settings[section][key] = value

func save_settings() -> void:
	var config = ConfigFile.new()
	for section in settings:
		for key in settings[section]:
			config.set_value(section, key, settings[section][key])
	config.save(SETTINGS_PATH)
	print("Settings saved.")

func apply_settings() -> void:
	# Aplicar configurações de áudio
	AudioManager.set_bus_volume_db("Master", linear_to_db(settings.audio.master_volume))
	AudioManager.set_bus_volume_db("Music", linear_to_db(settings.audio.music_volume))
	AudioManager.set_bus_volume_db("SFX", linear_to_db(settings.audio.sfx_volume))

	# Aplicar configurações de vídeo
	apply_resolution(settings.video.resolution)
	apply_fullscreen(settings.video.fullscreen)
	apply_vsync(settings.video.vsync)
	apply_fps_limit(settings.video.fps_limit)
	print("All settings applied.")

# --- Funções de Vídeo ---
func apply_resolution(resolution_str: String) -> void:
	var res_array = resolution_str.split("x")
	if res_array.size() == 2:
		var width = res_array[0].to_int()
		var height = res_array[1].to_int()
		DisplayServer.window_set_size(Vector2i(width, height))
		settings.video.resolution = resolution_str

func apply_fullscreen(is_fullscreen: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	settings.video.fullscreen = is_fullscreen

func apply_vsync(use_vsync: bool) -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if use_vsync else DisplayServer.VSYNC_DISABLED)
	settings.video.vsync = use_vsync

func apply_fps_limit(limit: int) -> void:
	Engine.max_fps = limit
	settings.video.fps_limit = limit

# --- Funções de Áudio ---
func set_master_volume(value: float) -> void:
	settings.audio.master_volume = value

func set_music_volume(value: float) -> void:
	settings.audio.music_volume = value

func set_sfx_volume(value: float) -> void:
	settings.audio.sfx_volume = value
