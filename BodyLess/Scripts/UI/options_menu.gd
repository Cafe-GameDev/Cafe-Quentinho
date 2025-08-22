extends Control

# O script do OptionsMenu gerencia a navegação interna e as ações de "Voltar" e "Aplicar".

const UiSoundPlayer = preload("res://Scripts/UI/Common/ui_sound_player.gd")
const TOOLTIP_SCENE = preload("res://Scenes/UI/Tooltip/Tooltip.tscn")

var _current_tooltip: Control = null
var _tooltip_texts: Dictionary = {
	"VideoButton": "Configurações de vídeo.",
	"AudioButton": "Configurações de áudio.",
	"LanguageButton": "Configurações de idioma.",
	"InputMapButton": "Configurações de mapeamento de teclas.",
	"BackButton": "Volta para o menu anterior.",
	"ApplyButton": "Salva as configurações e volta para o menu anterior.",
}

@onready var language_label: Label = $PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel
@onready var input_map_label: Label = $PanelContainer/Margin/Box/UPButtons/LabelContainer/InputMapLabel

func _ready() -> void:
	# Conecta os sinais de mouse_entered dos botões de categoria.
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/VideoButton.mouse_entered.connect(_on_button_mouse_entered.bind($PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/VideoButton))
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/AudioButton.mouse_entered.connect(_on_button_mouse_entered.bind($PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/AudioButton))
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/LanguageButton.mouse_entered.connect(_on_button_mouse_entered.bind($PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/LanguageButton))
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/InputMapButton.mouse_entered.connect(_on_button_mouse_entered.bind($PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/InputMapButton)) # Add this line
	$PanelContainer/Margin/Box/BottomButtonsContainer/BackButton.mouse_entered.connect(_on_button_mouse_entered.bind($PanelContainer/Margin/Box/BottomButtonsContainer/BackButton))
	$PanelContainer/Margin/Box/BottomButtonsContainer/ApplyButton.mouse_entered.connect(_on_button_mouse_entered.bind($PanelContainer/Margin/Box/BottomButtonsContainer/ApplyButton))

	# Conecta os sinais de mouse_exited para todos os botões
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/VideoButton.mouse_exited.connect(_on_button_mouse_exited)
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/AudioButton.mouse_exited.connect(_on_button_mouse_exited)
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/LanguageButton.mouse_exited.connect(_on_button_mouse_exited)
	$PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/InputMapButton.mouse_exited.connect(_on_button_mouse_exited) # Add this line
	$PanelContainer/Margin/Box/BottomButtonsContainer/BackButton.mouse_exited.connect(_on_button_mouse_exited)
	$PanelContainer/Margin/Box/BottomButtonsContainer/ApplyButton.mouse_exited.connect(_on_button_mouse_exited)


func _on_video_button_pressed() -> void:
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = true
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/InputMapSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/InputMapLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = false


func _on_audio_button_pressed() -> void:
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = true
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/InputMapSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/InputMapLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = false


func _on_language_button_pressed() -> void:
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/InputMapSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/InputMapLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = true
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings/LanguageOptionsContainer._populate_language_options()


func _on_back_button_pressed() -> void:
	print("[OptionsMenu] Botão 'Voltar' pressionado. Revertendo configurações e voltando ao estado anterior.")
	# Emite um sinal para o SettingsManager reverter as configs para o último estado salvo.
	GlobalEvents.request_loading_settings_changed.emit() # Requisita o carregamento das últimas configurações salvas
	GlobalEvents.request_loading_language_changed.emit() # Requisita o carregamento do último idioma salvo
	# Emite um sinal para o GameManager/SceneManager para fechar a UI de opções.
	GlobalEvents.return_to_previous_state_requested.emit()


func _on_apply_button_pressed() -> void:
	print("[OptionsMenu] Botão 'Aplicar' pressionado. Solicitando salvamento de configurações.")
	# Solicita que as configurações sejam salvas.
	GlobalEvents.request_saving_settings_changed.emit()
	GlobalEvents.request_saving_language_changed.emit()
	# Emite um sinal para o GameManager/SceneManager para fechar a UI de opções.
	GlobalEvents.return_to_previous_state_requested.emit()


func _on_button_mouse_entered(button: Button) -> void:
	UiSoundPlayer.play_hover_sound()
	var button_name = button.name
	if _tooltip_texts.has(button_name):
		if _current_tooltip:
			_current_tooltip.queue_free()
		_current_tooltip = TOOLTIP_SCENE.instantiate()
		add_child(_current_tooltip)
		# Acessa o Label dentro do Tooltip para definir o texto
		var tooltip_label = _current_tooltip.find_child("Label")
		if tooltip_label:
			tooltip_label.set_text(_tooltip_texts[button_name])
		_current_tooltip.position = get_global_mouse_position() + Vector2(10, 10) # Offset para não cobrir o mouse

func _on_button_mouse_exited() -> void:
	if _current_tooltip:
		_current_tooltip.queue_free()
		_current_tooltip = null


func _on_input_map_button_pressed() -> void:
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/InputMapSettings.visible = true
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/InputMapLabel.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = false
