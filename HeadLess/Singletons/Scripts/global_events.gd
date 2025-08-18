extends Node

# --- Sinais de Intenção de Input ---
@warning_ignore("unused_signal")
signal pause_toggled # Emitido quando a ação 'pause' é pressionada.
@warning_ignore("unused_signal")
signal debug_console_toggled # Emitido quando a ação 'toggle_console' é pressionada.
@warning_ignore("unused_signal")
signal music_change_requested # Emitido quando a ação 'music_change' é pressionada.

# --- Sinais de Áudio ---
@warning_ignore("unused_signal")
signal play_sfx_by_key_requested(sfx_key: String)
@warning_ignore("unused_signal")
signal music_track_changed(track_name: String)

# --- Sinais de Vídeo ---
@warning_ignore("unused_signal")
signal video_resolution_changed(new_resolution: Vector2i)
@warning_ignore("unused_signal")
signal video_window_mode_changed(new_mode: int) # new_mode pode ser DisplayServer.WINDOW_MODE_FULLSCREEN, WINDOW_MODE_WINDOWED, etc.
@warning_ignore("unused_signal")
signal fullscreen_mode_changed(is_fullscreen)
@warning_ignore("unused_signal")
signal field_of_view_changed(fov_value: float)
@warning_ignore("unused_signal")
signal aspect_ratio_changed(aspect_ratio_index: int)
@warning_ignore("unused_signal")
signal dynamic_render_scale_changed(mode: int)
@warning_ignore("unused_signal")
signal render_scale_changed(scale_value: float)
@warning_ignore("unused_signal")
signal frame_rate_limit_changed(mode: int)
@warning_ignore("unused_signal")
signal max_frame_rate_changed(fps_value: int)
@warning_ignore("unused_signal")
signal vsync_mode_changed(mode: int)
@warning_ignore("unused_signal")
signal triple_buffering_changed(enabled: bool)
@warning_ignore("unused_signal")
signal reduce_buffering_changed(enabled: bool)
@warning_ignore("unused_signal")
signal low_latency_mode_changed(mode: int)
@warning_ignore("unused_signal")
signal gamma_correction_changed(gamma_value: float)
@warning_ignore("unused_signal")
signal contrast_changed(contrast_value: float)
@warning_ignore("unused_signal")
signal brightness_changed(brightness_value: float)
@warning_ignore("unused_signal")
signal hdr_mode_changed(mode: int)
@warning_ignore("unused_signal")
signal shaders_quality_changed(quality_level: int)
@warning_ignore("unused_signal")
signal effects_quality_changed(quality_level: int)
@warning_ignore("unused_signal")
signal colorblind_mode_changed(mode: int)
@warning_ignore("unused_signal")
signal reduce_screen_shake_changed(enabled: bool)

# --- Sinais de Configurações (Settings) ---
@warning_ignore("unused_signal")
signal audio_setting_changed(bus_name, linear_volume)

@warning_ignore("unused_signal")
signal monitor_changed(monitor_index: int)
@warning_ignore("unused_signal")
signal locale_setting_changed(locale_code: String)
@warning_ignore("unused_signal")
signal save_settings_requested
@warning_ignore("unused_signal")
signal load_settings_requested
@warning_ignore("unused_signal")
signal settings_loaded(settings_data)
@warning_ignore("unused_signal")
signal open_settings_requested
@warning_ignore("unused_signal")
signal close_settings_requested

# --- Sinais de Save/Load do Jogo ---
@warning_ignore("unused_signal")
signal request_save_data
@warning_ignore("unused_signal")
signal save_data_ready(system_name, data)
@warning_ignore("unused_signal")
signal game_data_loaded(full_save_data)
@warning_ignore("unused_signal")
signal save_game_requested
@warning_ignore("unused_signal")
signal load_game_requested(slot_name_or_id)

# --- Sinais de Estado do Jogo (Game State) ---
@warning_ignore("unused_signal")
signal request_game_state_change(new_state: GameManager.GameState)
@warning_ignore("unused_signal")
signal return_to_previous_state_requested
@warning_ignore("unused_signal")
signal game_state_changed(new_state: GameManager.GameState)
@warning_ignore("unused_signal")
signal game_paused
@warning_ignore("unused_signal")
signal game_unpaused

# --- Sinais de Gerenciamento de Cena ---
@warning_ignore("unused_signal")
signal scene_changed(scene_path: String)
@warning_ignore("unused_signal")
signal scene_push_requested(scene_path: String)
@warning_ignore("unused_signal")
signal scene_pop_requested

# --- Sinais de Requisições de UI ---
@warning_ignore("unused_signal")
signal show_pause_menu_requested
@warning_ignore("unused_signal")
signal hide_pause_menu_requested
@warning_ignore("unused_signal")
signal show_settings_menu_requested
@warning_ignore("unused_signal")
signal hide_settings_menu_requested
@warning_ignore("unused_signal")
signal show_quit_confirmation_requested
@warning_ignore("unused_signal")
signal hide_quit_confirmation_requested
@warning_ignore("unused_signal")
signal quit_confirmed
@warning_ignore("unused_signal")
signal quit_cancelled

# Sinais de Configuração de UI
signal ui_scale_preset_changed(preset_name: String) # Novo sinal para presets de escala da UI
