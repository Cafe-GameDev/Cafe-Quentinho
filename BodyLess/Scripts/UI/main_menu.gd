extends Control

# O script do MainMenu é um exemplo de UI "burra".
# Ele não contém lógica de jogo, apenas emite sinais de "intenção"
# quando seus botões são pressionados.

const UiSoundPlayer = preload("res://Scripts/UI/Common/ui_sound_player.gd")
const TOOLTIP_SCENE = preload("res://Scenes/UI/Tooltip/Tooltip.tscn")

var _main_buttons: VBoxContainer
var _game_mode_buttons: VBoxContainer
@onready var new_game_button: Button = $MainButtons/NewGameButton
@onready var options_button: Button = $MainButtons/OptionsButton
@onready var exit_button: Button = $MainButtons/ExitButton

var _current_tooltip: Control = null
var _tooltip_texts: Dictionary = {
	"NewGameButton": "Inicia um novo jogo.",
	"OptionsButton": "Abre as configurações do jogo.",
	"ExitButton": "Sai do jogo.",
	"TopDownButton": "Inicia um jogo Top-Down.",
	"PlatformerButton": "Inicia um jogo de Plataforma.",
	"3DButton": "Inicia um jogo 3D.",
	"BackButton": "Volta para o menu principal.",
}

func _ready() -> void:
	_main_buttons = get_node("MainButtons")
	_game_mode_buttons = get_node("GameModeButtons")

	# Inicializa o idioma padrão baseado no SO.
	# DEFAULT_LANGUAGE_SETTINGS.language.locale = OS.get_locale()
	
	# Conecta os sinais de hover.
	new_game_button.mouse_entered.connect(_on_button_mouse_entered.bind(new_game_button))
	options_button.mouse_entered.connect(_on_button_mouse_entered.bind(options_button))
	exit_button.mouse_entered.connect(_on_button_mouse_entered.bind(exit_button))

	# Conecta os sinais de hover para os botões de modo de jogo
	if _game_mode_buttons:
		var top_down_button = _game_mode_buttons.get_node_or_null("TopDownButton")
		if top_down_button:
			top_down_button.mouse_entered.connect(_on_button_mouse_entered.bind(top_down_button))

		var platformer_button = _game_mode_buttons.get_node_or_null("PlatformerButton")
		if platformer_button:
			platformer_button.mouse_entered.connect(_on_button_mouse_entered.bind(platformer_button))

		var three_d_button = _game_mode_buttons.get_node_or_null("3DButton")
		if three_d_button:
			three_d_button.mouse_entered.connect(_on_button_mouse_entered.bind(three_d_button))

		var back_button = _game_mode_buttons.get_node_or_null("BackButton")
		if back_button:
			back_button.mouse_entered.connect(_on_button_mouse_entered.bind(back_button))

	# Conecta os sinais de mouse_exited para todos os botões
	new_game_button.mouse_exited.connect(_on_button_mouse_exited)
	options_button.mouse_exited.connect(_on_button_mouse_exited)
	exit_button.mouse_exited.connect(_on_button_mouse_exited)

	if _game_mode_buttons:
		var top_down_button = _game_mode_buttons.get_node_or_null("TopDownButton")
		if top_down_button:
			top_down_button.mouse_exited.connect(_on_button_mouse_exited)

		var platformer_button = _game_mode_buttons.get_node_or_null("PlatformerButton")
		if platformer_button:
			platformer_button.mouse_exited.connect(_on_button_mouse_exited)

		var three_d_button = _game_mode_buttons.get_node_or_null("3DButton")
		if three_d_button:
			three_d_button.mouse_exited.connect(_on_button_mouse_exited)

		var back_button = _game_mode_buttons.get_node_or_null("BackButton")
		if back_button:
			back_button.mouse_exited.connect(_on_button_mouse_exited)

	# Conecta-se ao sinal de mudança de estado do GameManager.
	GlobalEvents.game_state_changed.connect(_on_game_state_changed)

	# O SaveSystem agora é responsável por iniciar o carregamento das configurações
	# GlobalEvents.request_loading_settings_changed.emit() # Isso será emitido pelo SaveSystem
	# GlobalEvents.request_loading_language_changed.emit() # Isso será emitido pelo SaveSystem

func _on_new_game_button_pressed() -> void:
	_main_buttons.hide()
	_game_mode_buttons.show()

func _on_top_down_button_pressed() -> void:
	GlobalEvents.emit_signal("scene_changed", "res://Scenes/Game/topdown_world.tscn")

func _on_platformer_button_pressed() -> void:
	GlobalEvents.emit_signal("scene_changed", "res://Scenes/Game/platformer_world.tscn")

func _on_3d_button_pressed() -> void:
	GlobalEvents.emit_signal("scene_changed", "res://Scenes/Game/3d_world.tscn")

func _on_back_button_pressed() -> void:
	_game_mode_buttons.hide()
	_main_buttons.show()


func _on_options_button_pressed() -> void:
	# Solicita que o menu de configurações seja mostrado.
	# A GlobalMachine vai mudar o estado para SETTINGS.
	GlobalEvents.emit_signal("show_settings_menu_requested")


func _on_exit_button_pressed() -> void:
	# Solicita que a confirmação de saída seja mostrada.
	# A GlobalMachine vai mudar o estado para QUIT_CONFIRMATION.
	GlobalEvents.emit_signal("show_quit_confirmation_requested")

func _on_button_mouse_entered(button: Button) -> void:
	UiSoundPlayer.play_hover_sound()
	var button_name = button.name
	if _tooltip_texts.has(button_name):
		if _current_tooltip:
			_current_tooltip.queue_free()
		_current_tooltip = TOOLTIP_SCENE.instantiate()
		add_child(_current_tooltip)
		_current_tooltip.set_text(_tooltip_texts[button_name])
		_current_tooltip.position = get_global_mouse_position() + Vector2(10, 10) # Offset para não cobrir o mouse

func _on_button_mouse_exited() -> void:
	if _current_tooltip:
		_current_tooltip.queue_free()
		_current_tooltip = null

func _on_game_state_changed(new_state: String, previous_state: String) -> void:
	# O menu principal só deve ser visível quando o jogo está no estado MENU.
	visible = (new_state == "MENU")
