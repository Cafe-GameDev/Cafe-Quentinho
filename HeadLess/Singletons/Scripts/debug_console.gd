extends CanvasLayer

@onready var log_text: RichTextLabel = $Panel/MarginContainer/MainLayout/RightColumn/LogText
@onready var debug_info_text: RichTextLabel = $Panel/MarginContainer/MainLayout/LeftColumn/DebugInfoText
@onready var log_label: Label = $Panel/MarginContainer/MainLayout/RightColumn/Label


# --- Godot Lifecycle ---

func _ready() -> void:
	log_text.clear()
	_log_message(tr("DEBUG_CONSOLE_READY"), "INFO")
	_connect_to_global_events()
	GlobalEvents.debug_console_toggled.connect(_on_debug_console_toggled)

func _process(_delta: float) -> void:
	# Atualiza as informacoes de depuracao da coluna esquerda a cada frame
	if visible:
		_update_debug_info()

func _on_debug_console_toggled() -> void:
	visible = not visible


# --- Private Methods ---

func _update_debug_info() -> void:
	log_label.text = tr("DEBUG_LOG_TITLE")
	var godot_version_info = Engine.get_version_info()
	var godot_version = "{major}.{minor}.{patch}".format(godot_version_info)
	
	var os_name = OS.get_name()
	
	var monitor_str = "N/A"
	if SettingsManager and not SettingsManager.display_options.monitors.is_empty():
		var m = SettingsManager.display_options.monitors[0]
		monitor_str = tr("DEBUG_MONITOR_INFO").format({"id": m.id, "size": str(m.size), "hz": m.refresh_rate})

	var current_scene_str = "N/A"

	var game_state_str = "N/A"
	if GameManager:
		game_state_str = GameManager.GameState.keys()[GameManager.current_game_state]

	var info_string = ""
	info_string += tr("DEBUG_GAME_SECTION") + "\n"
	info_string += tr("DEBUG_GAME_VERSION") + "\n"
	info_string += tr("DEBUG_GAME_STATE").format({"state": game_state_str}) + "\n"
	info_string += tr("DEBUG_CURRENT_SCENE").format({"scene": current_scene_str}) + "\n"
	info_string += tr("DEBUG_LAST_SAVE") + "\n\n"
	
	info_string += tr("DEBUG_SYSTEM_SECTION") + "\n"
	info_string += "  FPS: {fps}\n".format({"fps": Engine.get_frames_per_second()})
	info_string += "  Godot: v{version}\n".format({"version": godot_version}) + "\n"
	info_string += tr("DEBUG_OS").format({"os": os_name}) + "\n"
	info_string += tr("DEBUG_PROCESSOR").format({"processor": OS.get_processor_name()}) + "\n"
	info_string += tr("DEBUG_CORES").format({"cores": OS.get_processor_count()}) + "\n"
	info_string += tr("DEBUG_RAM").format({"ram": str(round(OS.get_static_memory_usage() / (1024.0 * 1024.0))) + " MB"}) + "\n"
	info_string += tr("DEBUG_VIDEO_RENDERER").format({"renderer": ProjectSettings.get_setting("rendering/renderer/rendering_method")}) + "\n\n"
	
	info_string += tr("DEBUG_DISPLAY_SECTION") + "\n"
	info_string += tr("DEBUG_MONITOR").format({"monitor": monitor_str}) + "\n"
	
	debug_info_text.text = info_string

func _connect_to_global_events() -> void:
	GlobalEvents.play_sfx_by_key_requested.connect(_on_play_sfx_by_key_requested)
	GlobalEvents.audio_setting_changed.connect(_on_audio_setting_changed)
	GlobalEvents.fullscreen_mode_changed.connect(_on_fullscreen_mode_changed)
	GlobalEvents.save_settings_requested.connect(_on_save_settings_requested)
	GlobalEvents.load_settings_requested.connect(_on_load_settings_requested)
	GlobalEvents.settings_loaded.connect(_on_settings_loaded)
	GlobalEvents.request_save_data.connect(_on_request_save_data)
	GlobalEvents.save_data_ready.connect(_on_save_data_ready)
	GlobalEvents.game_data_loaded.connect(_on_game_data_loaded)
	GlobalEvents.game_state_changed.connect(_on_game_state_changed)
	GlobalEvents.game_paused.connect(_on_game_paused)
	GlobalEvents.game_unpaused.connect(_on_game_unpaused)
	GlobalEvents.music_track_changed.connect(_on_music_track_changed)

func _log_signal(signal_name: String, args: Dictionary = {}) -> void:
	var message = tr("DEBUG_SIGNAL_RECEIVED").format({"signal": signal_name})
	if not args.is_empty():
		var args_list = []
		for key in args:
			args_list.append("'{key}': {value}".format({"key": key, "value": str(args[key])}))
		message += tr("DEBUG_WITH_ARGS").format({"args": ", ".join(args_list)})
	_log_message(message, "SIGNAL")

func _log_message(text: String, level: String = "DEBUG") -> void:
	var timestamp = Time.get_time_string_from_system()
	var color = "white"
	match level:
		"INFO": color = "lightgreen"
		"SIGNAL": color = "lightblue"
		"ERROR": color = "red"

	var formatted_log = "[%s] [color=%s]%s[/color]: %s\n" % [timestamp, color, level, text]
	log_text.append_text(formatted_log)


# --- Signal Handlers ---

func _on_play_sfx_by_key_requested(sfx_key: String) -> void:
	_log_signal("play_sfx_by_key_requested", {"key": sfx_key})

func _on_audio_setting_changed(bus_name: String, linear_volume: float) -> void:
	_log_signal("audio_setting_changed", {"bus": bus_name, "volume": linear_volume})

func _on_fullscreen_mode_changed(is_fullscreen: bool) -> void:
	_log_signal("fullscreen_mode_changed", {"enabled": is_fullscreen})

func _on_save_settings_requested() -> void:
	_log_signal("save_settings_requested")

func _on_load_settings_requested() -> void:
	_log_signal("load_settings_requested")

func _on_settings_loaded(settings_data: Dictionary) -> void:
	_log_signal("settings_loaded", {"data": settings_data})

func _on_request_save_data() -> void:
	_log_signal("request_save_data")

func _on_save_data_ready(system_name: String, data: Dictionary) -> void:
	_log_signal("save_data_ready", {"system": system_name, "data": data})

func _on_game_data_loaded(full_save_data: Dictionary) -> void:
	_log_signal("game_data_loaded", {"save_data": full_save_data})

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	var state_name = GameManager.GameState.keys()[new_state]
	_log_signal("game_state_changed", {"new_state": state_name})

func _on_game_paused() -> void:
	_log_signal("game_paused")

func _on_game_unpaused() -> void:
	_log_signal("game_unpaused")

func _on_music_track_changed(track_name: String) -> void:
	_log_signal("music_track_changed", {"track": track_name})
