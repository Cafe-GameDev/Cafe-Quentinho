extends CanvasLayer

@onready var log_text_label: RichTextLabel = $Panel/MarginContainer/MainLayout/RightColumn/LogText
@onready var debug_info_label: RichTextLabel = $Panel/MarginContainer/MainLayout/LeftColumn/DebugInfoText

const MAX_LOG_ENTRIES = 100
var _log_entries: Array = []

func _ready() -> void:
	# O console começa invisível por padrão, conforme definido na cena.
	# Conecta-se aos sinais de controle do próprio console.
	GlobalEvents.debug_log_requested.connect(_on_debug_log_requested)
	GlobalEvents.debug_console_toggled.connect(_on_debug_console_toggled)

	# Conecta-se a todos os outros sinais do GlobalEvents de forma dinâmica
	_connect_all_signals()
	
	_add_log_entry("[color=yellow]Debug Console[/color]: Ready.")


func _on_debug_console_toggled() -> void:
	visible = not visible
	get_tree().paused = visible


func _add_log_entry(message: String) -> void:
	if _log_entries.size() > MAX_LOG_ENTRIES:
		_log_entries.pop_front()
	_log_entries.push_back(message)
	
	log_text_label.text = "\n".join(_log_entries)
	
	# Força a rolagem para o final.
	await get_tree().create_timer(0.01).timeout
	log_text_label.scroll_to_line(log_text_label.get_line_count() - 1)


func _on_debug_log_requested(log_data: Dictionary) -> void:
	var source: String = log_data.get("source", "Unknown")
	var event: String = log_data.get("event", "Log")
	var details: String = log_data.get("details", "")
	var data: Dictionary = log_data.get("data", {})

	var message: String = "[color=yellow]%s[/color]: [color=aqua]%s[/color]" % [source, event]
	if not details.is_empty():
		message += " - [color=gray]%s[/color]" % details
	
	if not data.is_empty():
		var data_string: String = JSON.stringify(data, "  ", false)
		message += "\n[color=white]%s[/color]" % data_string
		
	_add_log_entry(message)


func _log_generic_signal(signal_name: String, args: Array) -> void:
	var message: String = "[color=lightblue]Signal[/color]: [color=orange]%s[/color]" % signal_name
	
	if not args.is_empty():
		var args_string_parts: Array[String] = []
		for arg: Variant in args:
			args_string_parts.push_back(str(arg))
		message += " - Args: [color=lightgreen]%s[/color]" % ", ".join(args_string_parts)

	_add_log_entry(message)


func _connect_all_signals() -> void:
	var log_func: Callable = _log_generic_signal

	# --- Sinais de Configurações (Áudio/Vídeo) ---
	GlobalEvents.setting_changed.connect(func(change_data: Dictionary): log_func.call("setting_changed", [change_data]))
	GlobalEvents.request_loading_settings_changed.connect(func(): log_func.call("request_loading_settings_changed", []))
	GlobalEvents.loading_settings_changed.connect(func(settings_data: Dictionary): log_func.call("loading_settings_changed", [settings_data]))
	GlobalEvents.request_saving_settings_changed.connect(func(): log_func.call("request_saving_settings_changed", []))
	GlobalEvents.request_reset_settings_changed.connect(func(): log_func.call("request_reset_settings_changed", []))

	# --- Sinais de Idioma ---
	GlobalEvents.language_changed.connect(func(change_data: Dictionary): log_func.call("language_changed", [change_data]))
	GlobalEvents.request_loading_language_changed.connect(func(): log_func.call("request_loading_language_changed", []))
	GlobalEvents.loading_language_changed.connect(func(language_data: Dictionary): log_func.call("loading_language_changed", [language_data]))
	GlobalEvents.request_saving_language_changed.connect(func(): log_func.call("request_saving_language_changed", []))
	GlobalEvents.request_reset_language_changed.connect(func(): log_func.call("request_reset_language_changed", []))

	# --- Sinais de Intenção de Input ---
	GlobalEvents.pause_toggled.connect(func(): log_func.call("pause_toggled", []))
	GlobalEvents.debug_console_toggled.connect(func(): log_func.call("debug_console_toggled", []))
	GlobalEvents.music_change_requested.connect(func(): log_func.call("music_change_requested", []))

	# --- Sinais de Áudio ---
	GlobalEvents.play_sfx_by_key_requested.connect(func(sfx_key: String): log_func.call("play_sfx_by_key_requested", [sfx_key]))
	GlobalEvents.music_track_changed.connect(func(track_name: String): log_func.call("music_track_changed", [track_name]))

	# --- Sinais de Estado do Jogo (Game State) ---
	GlobalEvents.request_game_state_change.connect(func(new_state: String): log_func.call("request_game_state_change", [new_state]))
	GlobalEvents.return_to_previous_state_requested.connect(func(): log_func.call("return_to_previous_state_requested", []))
	GlobalEvents.game_state_changed.connect(func(new_state: String, previous_state: String): log_func.call("game_state_changed", [new_state, previous_state]))
	GlobalEvents.game_paused.connect(func(): log_func.call("game_paused", []))
	GlobalEvents.game_unpaused.connect(func(): log_func.call("game_unpaused", []))

	# --- Sinais de Gerenciamento de Cena ---
	GlobalEvents.scene_changed.connect(func(scene_path: String): log_func.call("scene_changed", [scene_path]))
	GlobalEvents.scene_push_requested.connect(func(scene_path: String): log_func.call("scene_push_requested", [scene_path]))
	GlobalEvents.scene_pop_requested.connect(func(): log_func.call("scene_pop_requested", []))
	GlobalEvents.request_game_selection_scene.connect(func(): log_func.call("request_game_selection_scene", []))

	# --- Sinais de Requisições de UI ---
	GlobalEvents.show_pause_menu_requested.connect(func(): log_func.call("show_pause_menu_requested", []))
	GlobalEvents.hide_pause_menu_requested.connect(func(): log_func.call("hide_pause_menu_requested", []))
	GlobalEvents.show_settings_menu_requested.connect(func(): log_func.call("show_settings_menu_requested", []))
	GlobalEvents.hide_settings_menu_requested.connect(func(): log_func.call("hide_settings_menu_requested", []))
	GlobalEvents.show_quit_confirmation_requested.connect(func(): log_func.call("show_quit_confirmation_requested", []))
	GlobalEvents.hide_quit_confirmation_requested.connect(func(): log_func.call("hide_quit_confirmation_requested", []))
	GlobalEvents.quit_confirmed.connect(func(): log_func.call("quit_confirmed", []))
	GlobalEvents.quit_cancelled.connect(func(): log_func.call("quit_cancelled", []))
