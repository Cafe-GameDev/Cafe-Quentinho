extends Control

# O script do MainMenu é um exemplo de UI "burra".
# Ele não contém lógica de jogo, apenas emite sinais de "intenção"
# quando seus botões são pressionados.

const UiSoundPlayer = preload("res://Scripts/UI/Common/ui_sound_player.gd")

var _main_buttons: VBoxContainer
var _game_mode_buttons: VBoxContainer
@onready var new_game_button: Button = $MainButtons/NewGameButton
@onready var options_button: Button = $MainButtons/OptionsButton
@onready var exit_button: Button = $MainButtons/ExitButton

var _tooltip_texts: Dictionary = {
	"NewGameButton": "TOOLTIP_NEW_GAME_DESC",
	"OptionsButton": "TOOLTIP_OPTIONS_DESC",
	"ExitButton": "TOOLTIP_EXIT_DESC",
	"TopDownButton": "TOOLTIP_TOPDOWN_DESC",
	"PlatformerButton": "TOOLTIP_PLATFORMER_DESC",
	"3DButton": "TOOLTIP_3D_DESC",
	"BackButton": "TOOLTIP_BACK_DESC",
}

func _ready() -> void:
	_main_buttons = get_node("MainButtons")
	_game_mode_buttons = get_node("GameModeButtons")

	# Inicializa o idioma padrão baseado no SO.
	# DEFAULT_LANGUAGE_SETTINGS.language.locale = OS.get_locale()
	
	# Conecta os sinais de hover
	new_game_button.mouse_entered.connect(_on_any_button_mouse_entered.bind(new_game_button))
	options_button.mouse_entered.connect(_on_any_button_mouse_entered.bind(options_button))
	exit_button.mouse_entered.connect(_on_any_button_mouse_entered.bind(exit_button))

	# Conecta os sinais de hover para os botões de modo de jogo
	if _game_mode_buttons:
		var top_down_button = _game_mode_buttons.get_node_or_null("TopDownButton")
		if top_down_button: top_down_button.mouse_entered.connect(_on_any_button_mouse_entered.bind(top_down_button))

		var platformer_button = _game_mode_buttons.get_node_or_null("PlatformerButton")
		if platformer_button: platformer_button.mouse_entered.connect(_on_any_button_mouse_entered.bind(platformer_button))

		var three_d_button = _game_mode_buttons.get_node_or_null("3DButton")
		if three_d_button: three_d_button.mouse_entered.connect(_on_any_button_mouse_entered.bind(three_d_button))

		var back_button = _game_mode_buttons.get_node_or_null("BackButton")
		if back_button: back_button.mouse_entered.connect(_on_any_button_mouse_entered.bind(back_button))

	# Conecta os sinais de mouse_exited para todos os botões
	new_game_button.mouse_exited.connect(_on_button_mouse_exited)
	options_button.mouse_exited.connect(_on_button_mouse_exited)
	exit_button.mouse_exited.connect(_on_button_mouse_exited)

	if _game_mode_buttons:
		var top_down_button = _game_mode_buttons.get_node_or_null("TopDownButton")
		if top_down_button: top_down_button.mouse_exited.connect(_on_button_mouse_exited)

		var platformer_button = _game_mode_buttons.get_node_or_null("PlatformerButton")
		if platformer_button: platformer_button.mouse_exited.connect(_on_button_mouse_exited)

		var three_d_button = _game_mode_buttons.get_node_or_null("3DButton")
		if three_d_button: three_d_button.mouse_exited.connect(_on_button_mouse_exited)

		var back_button = _game_mode_buttons.get_node_or_null("BackButton")
		if back_button: back_button.mouse_exited.connect(_on_button_mouse_exited)

	# Conecta-se ao sinal de mudança de estado do GameManager.
	if not GlobalEvents.game_state_updated.is_connected(_on_game_state_updated):
		GlobalEvents.game_state_updated.connect(_on_game_state_updated)

	# O SaveSystem agora é responsável por iniciar o carregamento das configurações
	# GlobalEvents.request_loading_settings_changed.emit() # Isso será emitido pelo SaveSystem
	# GlobalEvents.request_loading_language_changed.emit() # Isso será emitido pelo SaveSystem

func _on_new_game_button_pressed() -> void:
	_main_buttons.hide()
	_game_mode_buttons.show()

func _on_top_down_button_pressed() -> void:
	GlobalEvents.scene_push_requested.emit({"path": "res://Scenes/Game/topdown_world.tscn", "transition": "fade"})

func _on_platformer_button_pressed() -> void:
	GlobalEvents.scene_push_requested.emit({"path": "res://Scenes/Game/platformer_world.tscn", "transition": "fade"})

func _on_3d_button_pressed() -> void:
	GlobalEvents.scene_push_requested.emit({"path": "res://Scenes/Game/3d_world.tscn", "transition": "fade"})

func _on_back_button_pressed() -> void:
	_game_mode_buttons.hide()
	_main_buttons.show()


func _on_options_button_pressed() -> void:
	# Solicita que o menu de configurações seja mostrado.
	# A GlobalMachine vai mudar o estado para SETTINGS.
	GlobalEvents.show_ui_requested.emit({"ui_key": "options_menu"})


func _on_exit_button_pressed() -> void:
	# Solicita que a confirmação de saída seja mostrada.
	# A GlobalMachine vai mudar o estado para QUIT_CONFIRMATION.
	GlobalEvents.show_ui_requested.emit({"ui_key": "quit_confirmation"})

func _on_any_button_mouse_entered(button_node: Node) -> void:
	UiSoundPlayer.play_hover_sound()
	if button_node and _tooltip_texts.has(button_node.name):
		GlobalEvents.show_tooltip_requested.emit({"text": tr(_tooltip_texts[button_node.name]), "position": get_global_mouse_position() + Vector2(10, 10)})

func _on_button_mouse_exited() -> void:
	GlobalEvents.hide_tooltip_requested.emit()

func _on_game_state_updated(state_data: Dictionary) -> void:
	var new_state: String = state_data.get("new_state", "")
	var previous_state: String = state_data.get("previous_state", "")
	# O menu principal só deve ser visível quando o jogo está no estado MENU.
	visible = (new_state == "MENU")
