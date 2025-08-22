extends Control

# O script do PauseMenu, assim como o MainMenu, apenas emite sinais de intenção.

const UiSoundPlayer = preload("res://Scripts/UI/Common/ui_sound_player.gd")

func _on_new_game_button_pressed() -> void: # Renomeado no inspetor para _on_resume_button_pressed
	# Solicita the toggle da pausa. A GlobalMachine vai de PAUSED para PLAYING.
	GlobalEvents.emit_signal("pause_toggled")


func _on_options_button_pressed() -> void:
	# Solicita a exibição do menu de configurações.
	GlobalEvents.show_ui_requested.emit({"ui_key": "options_menu", "context": "paused_game"})


func _on_exit_button_pressed() -> void:
	# Solicita a exibição da confirmação de saída.
	GlobalEvents.show_ui_requested.emit({"ui_key": "quit_confirmation", "context": "paused_game"})


func _on_change_game_button_pressed() -> void:
	# Solicita a transição para a cena de seleção de jogo.
	GlobalEvents.emit_signal("request_game_selection_scene")

func _on_button_mouse_entered() -> void:
	UiSoundPlayer.play_hover_sound()

func _on_game_state_updated(state_data: Dictionary) -> void:
	var new_state: String = state_data.get("new_state", "")
	visible = (new_state == "PAUSED")
