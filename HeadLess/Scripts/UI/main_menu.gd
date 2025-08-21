extends Control

# --- Constantes de Som ---
const CLICK_SOUND = "click1"
const HOVER_SOUND = "high_down"

# --- Nós da UI (Assumindo estes nomes na sua cena pause_menu.tscn) ---
@onready var new_game_button: Button = $MainButtons/NewGameButton
@onready var options_button: Button = $MainButtons/OptionsButton
@onready var exit_button: Button = $MainButtons/ExitButton

func _ready() -> void:
	
	# NOTA: Os sinais 'pressed' dos botões devem ser conectados através do editor
	# para evitar erros de "sinal já conectado" se a cena for recarregada.

	# Conecta os sinais de hover.
	new_game_button.mouse_entered.connect(_on_button_mouse_entered)
	options_button.mouse_entered.connect(_on_button_mouse_entered)
	exit_button.mouse_entered.connect(_on_button_mouse_entered)

	# Conecta-se ao sinal de mudança de estado do GameManager.
	GlobalEvents.game_state_changed.connect(_on_game_state_changed)

func _exit_tree():
	# Desconecta os sinais para evitar vazamento de memória.
	GlobalEvents.game_state_changed.disconnect(_on_game_state_changed)


# --- Handlers de Botões ---

func _on_new_game_button_pressed() -> void:
	GlobalEvents.play_sfx_by_key_requested.emit("ui_click")
	GlobalEvents.request_game_state_change.emit(GameManager.GameState.PLAYING)
	GlobalEvents.scene_push_requested.emit("res://Scenes/world.tscn") # Ou a cena do primeiro nível

func _on_options_button_pressed() -> void:
	GlobalEvents.play_sfx_by_key_requested.emit("ui_click")
	GlobalEvents.request_game_state_change.emit(GameManager.GameState.SETTINGS)

func _on_exit_button_pressed() -> void:
	GlobalEvents.play_sfx_by_key_requested.emit("ui_click")
	GlobalEvents.request_game_state_change.emit(GameManager.GameState.QUIT_CONFIRMATION)

func _on_button_mouse_entered() -> void:
	GlobalEvents.play_sfx_by_key_requested.emit("ui_rollover")


# --- Handlers de Sinais do GameManager ---

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	# O menu principal só deve ser visível quando o jogo está no estado MENU.
	visible = (new_state == GameManager.GameState.MENU)
