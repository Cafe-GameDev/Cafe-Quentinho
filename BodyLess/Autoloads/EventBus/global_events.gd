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
signal setting_changed(change_data: Dictionary)
signal request_loading_settings_changed()
signal loading_settings_changed(settings_data: Dictionary)
signal request_saving_settings_changed()
signal request_reset_settings_changed()

# --- Sinais de Idioma ---
signal language_changed(change_data: Dictionary)
signal request_loading_language_changed()
signal loading_language_changed(language_data: Dictionary)
signal request_saving_language_changed()
signal request_reset_language_changed()

# --- Sinais de Intenção de Input ---
signal pause_toggled()
signal debug_console_toggled()
signal music_change_requested()

# --- Sinais de Áudio ---
signal play_sfx_by_key_requested(sfx_key: String)
signal music_track_changed(track_name: String)

# --- Sinais de Estado do Jogo (Game State) ---
signal request_game_state_change(new_state: String)
signal return_to_previous_state_requested()
signal game_state_changed(new_state: String, previous_state: String)
signal game_paused()
signal game_unpaused()

# --- Sinais de Gerenciamento de Cena ---
signal scene_changed(scene_path: String)
signal scene_push_requested(scene_path: String)
signal scene_pop_requested()
signal request_game_selection_scene()

# --- Sinais de Requisições de UI ---
signal show_pause_menu_requested()
signal hide_pause_menu_requested()
signal show_settings_menu_requested()
signal hide_settings_menu_requested()
signal show_quit_confirmation_requested()
signal hide_quit_confirmation_requested()
signal quit_confirmed()
signal quit_cancelled()
signal close_settings_requested() # Adicionado
signal save_settings_requested() # Adicionado
signal show_tooltip_requested(text: String, position: Vector2)
signal hide_tooltip_requested()



# --- Sinais de Popover ---
signal show_popover_requested(content_data: Dictionary, parent_node: Node)
signal hide_popover_requested()
signal popover_button_pressed(action: String)

# --- Sinais de Toast ---
signal show_toast_requested(message: String, type: String)

# --- Sinais de Tutorial/Coach Mark ---
signal start_tutorial_requested(tutorial_name: String)
signal coach_mark_next_requested()
signal coach_mark_skip_requested()
signal tutorial_finished()

# --- Sinais de Depuração ---
signal debug_log_requested(log_data: Dictionary)

# --- Sinais de SaveSystem ---
signal request_save_game(session_id: int, game_mode: String)
signal game_saved(session_id: int)
signal request_load_game(session_id: int, game_mode: String)
signal game_loaded(session_id: int, game_data: Dictionary)

# --- Sinais de Requisição/Resposta de Dados para SaveSystem ---
signal request_player_data_for_save()
signal player_data_for_save_received(player_data: Dictionary)
signal request_inventory_data_for_save()
signal inventory_data_for_save_received(inventory_data: Dictionary)
signal request_global_machine_data_for_save()
signal global_machine_data_for_save_received(global_machine_data: Dictionary)
signal request_world_data_for_save()
signal world_data_for_save_received(world_data: Dictionary)
signal request_settings_data_for_save()
signal settings_data_for_save_received(settings_data: Dictionary)
signal request_language_data_for_save()
signal language_data_for_save_received(language_data: Dictionary)
signal request_input_map_data_for_save()
signal input_map_data_for_save_received(input_map_data: Dictionary) # Adicionado


signal input_map_changed(input_map_data: Dictionary)
signal request_loading_input_map_changed()
signal loading_input_map_changed(input_map_data: Dictionary)
signal request_saving_input_map_changed()
signal request_reset_input_map_changed()

# --- Sinais de InventoryManager ---
signal item_added(item_data: Dictionary)
signal item_removed(item_id: String)
signal item_used(item_id: String)



# --- Sinais de InputManager (Novas Ações) ---
signal input_inventory_pressed()
signal input_reload_pressed()
signal input_special_pressed()
signal input_sprint_toggled(is_sprinting: bool)
signal input_crouch_toggled(is_crouching: bool)

# --- Sinais de LootSystem ---
signal character_defeated(character_node: Node) # Reutilizado do GDD, mas agora com propósito de loot
signal item_spawned(item_data: Dictionary, position: Vector3) # Usar Vector2 para 2D, Vector3 para 3D

# --- Sinais de FloatingTextManager ---
signal show_floating_text_requested(text: String, position: Vector3, color: Color) # Usar Vector2 para 2D, Vector3 para 3D

# --- Sinais de QuestSystem ---
signal quest_updated(quest_id: String, new_status: String)
