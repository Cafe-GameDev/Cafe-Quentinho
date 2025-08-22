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

	# --- Sinais de Áudio ---
	GlobalEvents.play_sfx_by_key_requested.connect(func(sfx_key: String): log_func.call("play_sfx_by_key_requested", [sfx_key]))
	GlobalEvents.music_change_requested.connect(func(music_key: String): log_func.call("music_change_requested", [music_key]))
	GlobalEvents.music_track_changed.connect(func(track_name: String): log_func.call("music_track_changed", [track_name]))

	# --- Sinais de Estado do Jogo (Game State) ---
	GlobalEvents.request_game_state_change.connect(func(state_request_data: Dictionary): log_func.call("request_game_state_change", [state_request_data]))
	GlobalEvents.return_to_previous_state_requested.connect(func(): log_func.call("return_to_previous_state_requested", []))
	GlobalEvents.game_state_updated.connect(func(state_data: Dictionary): log_func.call("game_state_updated", [state_data]))

	# --- Sinais de Gerenciamento de Cena ---
	GlobalEvents.scene_updated.connect(func(scene_data: Dictionary): log_func.call("scene_updated", [scene_data]))
	GlobalEvents.scene_push_requested.connect(func(scene_request_data: Dictionary): log_func.call("scene_push_requested", [scene_request_data]))
	GlobalEvents.scene_pop_requested.connect(func(): log_func.call("scene_pop_requested", []))
	GlobalEvents.request_game_selection_scene.connect(func(): log_func.call("request_game_selection_scene", []))

	# --- Sinais de Requisições de UI (Unificados) ---
	GlobalEvents.show_ui_requested.connect(func(ui_data: Dictionary): log_func.call("show_ui_requested", [ui_data]))
	GlobalEvents.hide_ui_requested.connect(func(ui_data: Dictionary): log_func.call("hide_ui_requested", [ui_data]))
	GlobalEvents.show_quit_confirmation_requested.connect(func(): log_func.call("show_quit_confirmation_requested", []))
	GlobalEvents.hide_quit_confirmation_requested.connect(func(): log_func.call("hide_quit_confirmation_requested", []))
	GlobalEvents.quit_confirmed.connect(func(): log_func.call("quit_confirmed", []))
	GlobalEvents.quit_cancelled.connect(func(): log_func.call("quit_cancelled", []))
	GlobalEvents.save_settings_requested.connect(func(): log_func.call("save_settings_requested", []))
	GlobalEvents.show_tooltip_requested.connect(func(tooltip_data: Dictionary): log_func.call("show_tooltip_requested", [tooltip_data]))
	GlobalEvents.hide_tooltip_requested.connect(func(): log_func.call("hide_tooltip_requested", []))

	# --- Sinais de Popover ---
	GlobalEvents.show_popover_requested.connect(func(content_data: Dictionary, parent_node: Node): log_func.call("show_popover_requested", [content_data, parent_node]))
	GlobalEvents.hide_popover_requested.connect(func(): log_func.call("hide_popover_requested", []))
	GlobalEvents.popover_button_pressed.connect(func(action: String): log_func.call("popover_button_pressed", [action]))

	# --- Sinais de Toast ---
	GlobalEvents.show_toast_requested.connect(func(toast_data: Dictionary): log_func.call("show_toast_requested", [toast_data]))

	# --- Sinais de Tutorial/Coach Mark ---
	GlobalEvents.start_tutorial_requested.connect(func(tutorial_data: Dictionary): log_func.call("start_tutorial_requested", [tutorial_data]))
	GlobalEvents.coach_mark_next_requested.connect(func(): log_func.call("coach_mark_next_requested", []))
	GlobalEvents.coach_mark_skip_requested.connect(func(): log_func.call("coach_mark_skip_requested", []))
	GlobalEvents.tutorial_finished.connect(func(): log_func.call("tutorial_finished", []))

	# --- Sinais de Depuração ---
	GlobalEvents.debug_log_requested.connect(func(log_data: Dictionary): log_func.call("debug_log_requested", [log_data]))

	# --- Sinais de SaveSystem ---
	GlobalEvents.request_save_game.connect(func(session_id: int, game_mode: String): log_func.call("request_save_game", [session_id, game_mode]))
	GlobalEvents.game_saved.connect(func(session_id: int): log_func.call("game_saved", [session_id]))
	GlobalEvents.request_load_game.connect(func(session_id: int, game_mode: String): log_func.call("request_load_game", [session_id, game_mode]))
	GlobalEvents.game_loaded.connect(func(session_id: int, game_data: Dictionary): log_func.call("game_loaded", [session_id, game_data]))

	# --- Sinais de Requisição/Resposta de Dados para SaveSystem ---
	GlobalEvents.request_player_data_for_save.connect(func(): log_func.call("request_player_data_for_save", []))
	GlobalEvents.player_data_for_save_received.connect(func(player_data: Dictionary): log_func.call("player_data_for_save_received", [player_data]))
	GlobalEvents.request_inventory_data_for_save.connect(func(): log_func.call("request_inventory_data_for_save", []))
	GlobalEvents.inventory_data_for_save_received.connect(func(inventory_data: Dictionary): log_func.call("inventory_data_for_save_received", [inventory_data]))
	GlobalEvents.request_global_machine_data_for_save.connect(func(): log_func.call("request_global_machine_data_for_save", []))
	GlobalEvents.global_machine_data_for_save_received.connect(func(global_machine_data: Dictionary): log_func.call("global_machine_data_for_save_received", [global_machine_data]))
	GlobalEvents.request_world_data_for_save.connect(func(): log_func.call("request_world_data_for_save", []))
	GlobalEvents.world_data_for_save_received.connect(func(world_data: Dictionary): log_func.call("world_data_for_save_received", [world_data]))
	GlobalEvents.request_settings_data_for_save.connect(func(): log_func.call("request_settings_data_for_save", []))
	GlobalEvents.settings_data_for_save_received.connect(func(settings_data: Dictionary): log_func.call("settings_data_for_save_received", [settings_data]))
	GlobalEvents.request_language_data_for_save.connect(func(): log_func.call("request_language_data_for_save", []))
	GlobalEvents.language_data_for_save_received.connect(func(language_data: Dictionary): log_func.call("language_data_for_save_received", [language_data]))

	# --- Sinais de InputMap (Novos) ---
	GlobalEvents.input_map_changed.connect(func(input_map_data: Dictionary): log_func.call("input_map_changed", [input_map_data]))
	GlobalEvents.loading_input_map_changed.connect(func(input_map_data: Dictionary): log_func.call("loading_input_map_changed", [input_map_data]))
	GlobalEvents.request_reset_input_map.connect(func(): log_func.call("request_reset_input_map", []))

	# --- Sinais de InventoryManager ---
	GlobalEvents.item_added.connect(func(item_data: Dictionary): log_func.call("item_added", [item_data]))
	GlobalEvents.item_removed.connect(func(item_data: Dictionary): log_func.call("item_removed", [item_data]))
	GlobalEvents.item_used.connect(func(item_data: Dictionary): log_func.call("item_used", [item_data]))

	# --- Sinais de LootSystem ---
	GlobalEvents.character_defeated.connect(func(character_data: Dictionary): log_func.call("character_defeated", [character_data]))
	GlobalEvents.item_spawned.connect(func(item_data: Dictionary, position: Vector3): log_func.call("item_spawned", [item_data, position]))

	# --- Sinais de FloatingTextManager ---
	GlobalEvents.show_floating_text_requested.connect(func(text_data: Dictionary): log_func.call("show_floating_text_requested", [text_data]))

	# --- Sinais de QuestSystem ---
	GlobalEvents.quest_updated.connect(func(quest_data: Dictionary): log_func.call("quest_updated", [quest_data]))

	# --- Sinais de Intenção de Input (Unificados) ---
	GlobalEvents.input_action_triggered.connect(func(action_data: Dictionary): log_func.call("input_action_triggered", [action_data]))
