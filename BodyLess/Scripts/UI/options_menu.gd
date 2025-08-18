extends Control

# O script do OptionsMenu gerencia a navegação interna e as ações de "Voltar" e "Aplicar".

const UiSoundPlayer = preload("res://Scripts/UI/Common/ui_sound_player.gd")

func _ready() -> void:
	# Conecta os sinais de mouse_entered dos botões de categoria.
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/VideoButton.mouse_entered.connect(_on_button_mouse_entered)
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/AudioButton.mouse_entered.connect(_on_button_mouse_entered)
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/LanguageButton.mouse_entered.connect(_on_button_mouse_entered)
	$PanelContainer/Margin/Box/BottomButtonsContainer/BackButton.mouse_entered.connect(_on_button_mouse_entered)
	$PanelContainer/Margin/Box/BottomButtonsContainer/ApplyButton.mouse_entered.connect(_on_button_mouse_entered)


func _on_video_button_pressed() -> void:
	UiSoundPlayer.play_click_sound()
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = true
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = false


func _on_audio_button_pressed() -> void:
	UiSoundPlayer.play_click_sound()
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = true
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = false


func _on_language_button_pressed() -> void:
	UiSoundPlayer.play_click_sound()
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = true


func _on_back_button_pressed() -> void:
	UiSoundPlayer.play_click_sound()
	# Solicita o retorno ao estado anterior (seja MENU ou PAUSED).
	GlobalEvents.emit_signal("return_to_previous_state_requested")


func _on_apply_button_pressed() -> void:
	UiSoundPlayer.play_click_sound()
	# Solicita que as configurações sejam salvas.
	GlobalEvents.emit_signal("save_settings_requested")


func _on_button_mouse_entered() -> void:
	UiSoundPlayer.play_hover_sound()
