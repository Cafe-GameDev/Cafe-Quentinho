extends Control

# O script do MainMenu é um exemplo de UI "burra".
# Ele não contém lógica de jogo, apenas emite sinais de "intenção"
# quando seus botões são pressionados.

const UiSoundPlayer = preload("res://Scripts/UI/Common/ui_sound_player.gd")

func _on_new_game_button_pressed() -> void:
	UiSoundPlayer.play_click_sound()
	# Solicita a troca para a cena do jogo.
	# A GlobalMachine e o SceneControl vão reagir a essa mudança.
	GlobalEvents.emit_signal("scene_changed", "res://Scenes/Game/world.tscn")


func _on_options_button_pressed() -> void:
	UiSoundPlayer.play_click_sound()
	# Solicita que o menu de configurações seja mostrado.
	# A GlobalMachine vai mudar o estado para SETTINGS.
	GlobalEvents.emit_signal("show_settings_menu_requested")


func _on_exit_button_pressed() -> void:
	UiSoundPlayer.play_click_sound()
	# Solicita que a confirmação de saída seja mostrada.
	# A GlobalMachine vai mudar o estado para QUIT_CONFIRMATION.
	GlobalEvents.emit_signal("show_quit_confirmation_requested")

func _on_button_mouse_entered() -> void:
	UiSoundPlayer.play_hover_sound()