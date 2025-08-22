extends Node

# Este script, GlobalEvents, atua como um "quadro de avisos" central para todo o jogo.
# Ele não contém lógica, apenas uma lista de todos os sinais que os diferentes sistemas
# podem emitir e ouvir. Isso garante que os sistemas (Managers, UI, etc.) possam se
# comunicar sem se conhecerem diretamente, um princípio chave chamado "desacoplamento".

# --- Padrão de Comunicação para Dados Persistentes ---
# Qualquer sistema que gerencia dados que precisam ser salvos (Configurações, Idioma, etc.)
# segue um padrão de 5 sinais. Isso cria um fluxo de dados previsível e robusto.
#
# 1. [escopo]_changed: Notifica uma mudança em tempo real (live) feita na UI.
# 2. request_loading_[escopo]_changed: Pede para carregar os dados do disco.
# 3. loading_[escopo]_changed: Envia os dados carregados do disco para todos os sistemas.
# 4. request_saving_[escopo]_changed: Pede para salvar o estado atual no disco.
# 5. request_reset_[escopo]_changed: Pede para restaurar as configurações padrão de fábrica.
#-------------------------------------------------------------------------------

# --- Sinais de Configurações (Áudio/Vídeo) ---
@warning_ignore("unused_signal")
signal setting_changed(change_data: Dictionary)
@warning_ignore("unused_signal")
signal request_loading_settings_changed()
@warning_ignore("unused_signal")
signal loading_settings_changed(settings_data: Dictionary)
@warning_ignore("unused_signal")
signal request_saving_settings_changed()
@warning_ignore("unused_signal")
signal request_reset_settings_changed()

# --- Sinais de Idioma ---
@warning_ignore("unused_signal")
signal language_changed(change_data: Dictionary)
@warning_ignore("unused_signal")
signal request_loading_language_changed()
@warning_ignore("unused_signal")
signal loading_language_changed(language_data: Dictionary)
@warning_ignore("unused_signal")
signal request_saving_language_changed()
@warning_ignore("unused_signal")
signal request_reset_language_changed()

# --- Sinais de Áudio ---
@warning_ignore("unused_signal")
signal play_sfx_by_key_requested(sfx_key: String)
@warning_ignore("unused_signal")
signal music_change_requested(music_key: String) # Mantido conforme discussão
@warning_ignore("unused_signal")
signal music_track_changed(track_name: String) # Mantido conforme discussão

# --- Sinais de Estado do Jogo (Game State) ---
@warning_ignore("unused_signal")
signal game_state_updated(state_data: Dictionary) # Ex: {"new_state": "PLAYING", "previous_state": "PAUSED", "is_paused": false}
@warning_ignore("unused_signal")
signal request_game_state_change(state_request_data: Dictionary) # Ex: {"new_state": "PAUSED", "reason": "user_input"}
@warning_ignore("unused_signal")
signal return_to_previous_state_requested() # Mantido, pois é uma ação simples de retorno

# --- Sinais de Gerenciamento de Cena ---
@warning_ignore("unused_signal")
signal scene_updated(scene_data: Dictionary) # Ex: {"path": "res://Scenes/Game/world.tscn", "type": "game_world"}
@warning_ignore("unused_signal")
signal scene_push_requested(scene_request_data: Dictionary) # Ex: {"path": "res://Scenes/UI/options_menu.tscn", "transition": "fade"}
@warning_ignore("unused_signal")
signal scene_pop_requested() # Mantido, pois é uma ação simples de pop
@warning_ignore("unused_signal")
signal request_game_selection_scene() # Mantido, pois é uma ação específica

# --- Sinais de Requisições de UI (Unificados) ---
@warning_ignore("unused_signal")
signal show_ui_requested(ui_data: Dictionary) # Ex: {"ui_key": "pause_menu", "context": "game_paused"}
@warning_ignore("unused_signal")
signal hide_ui_requested(ui_data: Dictionary) # Ex: {"ui_key": "pause_menu"}
@warning_ignore("unused_signal")
signal show_quit_confirmation_requested() # Mantido, pois é uma ação específica
@warning_ignore("unused_signal")
signal hide_quit_confirmation_requested() # Mantido, pois é uma ação específica
@warning_ignore("unused_signal")
signal quit_confirmed() # Mantido, pois é uma ação específica
@warning_ignore("unused_signal")
signal quit_cancelled() # Mantido, pois é uma ação específica
@warning_ignore("unused_signal")
signal save_settings_requested() # Mantido, pois é uma ação específica
@warning_ignore("unused_signal")
signal show_tooltip_requested(tooltip_data: Dictionary) # Ex: {"text": "Item de cura", "position": Vector2(100, 50), "duration": 2.0}
@warning_ignore("unused_signal")
signal hide_tooltip_requested() # Mantido, pois é uma ação específica

# --- Sinais de Popover ---
@warning_ignore("unused_signal")
signal show_popover_requested(content_data: Dictionary, parent_node: Node)
@warning_ignore("unused_signal")
signal hide_popover_requested()
@warning_ignore("unused_signal")
signal popover_button_pressed(action: String)

# --- Sinais de Toast ---
@warning_ignore("unused_signal")
signal show_toast_requested(toast_data: Dictionary) # Ex: {"message": "Item coletado!", "type": "success", "duration": 3.0}

# --- Sinais de Tutorial/Coach Mark ---
@warning_ignore("unused_signal")
signal start_tutorial_requested(tutorial_data: Dictionary) # Ex: {"name": "intro_tutorial", "step": 1}
@warning_ignore("unused_signal")
signal coach_mark_next_requested() # Mantido, pois é uma ação específica
@warning_ignore("unused_signal")
signal coach_mark_skip_requested() # Mantido, pois é uma ação específica
@warning_ignore("unused_signal")
signal tutorial_finished() # Mantido, pois é uma ação específica

# --- Sinais de Depuração ---
@warning_ignore("unused_signal")
signal debug_log_requested(log_data: Dictionary)
@warning_ignore("unused_signal")
signal debug_console_toggled(is_visible: bool)

# --- Sinais de SaveSystem ---
@warning_ignore("unused_signal")
signal request_save_game(session_id: int, game_mode: String)
@warning_ignore("unused_signal")
signal game_saved(session_id: int)
@warning_ignore("unused_signal")
signal request_load_game(session_id: int, game_mode: String)
@warning_ignore("unused_signal")
signal game_loaded(session_id: int, game_data: Dictionary)

# --- Sinais de Requisição/Resposta de Dados para SaveSystem ---
@warning_ignore("unused_signal")
signal request_player_data_for_save()
@warning_ignore("unused_signal")
signal player_data_for_save_received(player_data: Dictionary)
@warning_ignore("unused_signal")
signal request_inventory_data_for_save()
@warning_ignore("unused_signal")
signal inventory_data_for_save_received(inventory_data: Dictionary)
@warning_ignore("unused_signal")
signal request_global_machine_data_for_save()
@warning_ignore("unused_signal")
signal global_machine_data_for_save_received(global_machine_data: Dictionary)
@warning_ignore("unused_signal")
signal request_world_data_for_save()
@warning_ignore("unused_signal")
signal world_data_for_save_received(world_data: Dictionary)
@warning_ignore("unused_signal")
signal request_settings_data_for_save()
@warning_ignore("unused_signal")
signal settings_data_for_save_received(settings_data: Dictionary)
@warning_ignore("unused_signal")
signal request_language_data_for_save()
@warning_ignore("unused_signal")
signal language_data_for_save_received(language_data: Dictionary)

# --- Sinais de InputMap (Novos) ---
@warning_ignore("unused_signal")
signal input_map_changed(input_map_data: Dictionary)
@warning_ignore("unused_signal")
signal loading_input_map_changed(input_map_data: Dictionary)
@warning_ignore("unused_signal")
signal request_reset_input_map()
@warning_ignore("unused_signal")
signal request_input_map_data_for_save()
@warning_ignore("unused_signal")
signal input_map_data_for_save_received(input_map_data: Dictionary)

# --- Sinais de InventoryManager ---
@warning_ignore("unused_signal")
signal item_added(item_data: Dictionary)
@warning_ignore("unused_signal")
signal item_removed(item_data: Dictionary) # Modificado para Dictionary
@warning_ignore("unused_signal")
signal item_used(item_data: Dictionary) # Modificado para Dictionary

# --- Sinais de LootSystem ---
@warning_ignore("unused_signal")
signal character_defeated(character_data: Dictionary) # Modificado para Dictionary
@warning_ignore("unused_signal")
signal item_spawned(item_data: Dictionary, position: Vector3) # Mantido conforme discussão

# --- Sinais de FloatingTextManager ---
@warning_ignore("unused_signal")
signal show_floating_text_requested(text_data: Dictionary) # Modificado para Dictionary

# --- Sinais de QuestSystem ---
@warning_ignore("unused_signal")
signal quest_updated(quest_data: Dictionary) # Modificado para Dictionary

# --- Sinais de Intenção de Input (Unificados) ---
@warning_ignore("unused_signal")
signal input_action_triggered(action_data: Dictionary) # Ex: {"action": "pause", "state": "pressed"}, {"action": "sprint", "state": "toggled", "is_active": true}
