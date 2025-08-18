extends PanelContainer

# Este script apenas emite a decisão do jogador (Sim ou Não).

const UiSoundPlayer = preload("res://Scripts/UI/Common/ui_sound_player.gd")

func _on_yes_button_pressed() -> void:
	UiSoundPlayer.play_click_sound()
	GlobalEvents.emit_signal("quit_confirmed")


func _on_no_button_pressed() -> void:
	UiSoundPlayer.play_click_sound()
	GlobalEvents.emit_signal("quit_cancelled")

func _on_button_mouse_entered() -> void:
	UiSoundPlayer.play_hover_sound()
