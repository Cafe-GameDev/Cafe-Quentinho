extends Panel

# --- Constantes de Som ---
const CLICK_SOUND = "click1"
const HOVER_SOUND = "high_down"

# --- Nós da UI (Assumindo estes nomes na sua cena pause_menu.tscn) ---
@onready var new_game_button: Button = $MainButtons/NewGameButton
@onready var options_button: Button = $MainButtons/OptionsButton
@onready var exit_button: Button = $MainButtons/ExitButton

func _ready() -> void:
	# Garante que o menu de pausa pode processar input mesmo com o jogo pausado.
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Esconde o menu inicialmente (GameManager vai mostrar quando necessário).
	hide()
	
	# NOTA: Os sinais 'pressed' dos botões devem ser conectados através do editor
	# para evitar erros de "sinal já conectado" se a cena for recarregada.

	# Conecta os sinais de hover.
	new_game_button.mouse_entered.connect(_on_button_mouse_entered)
	options_button.mouse_entered.connect(_on_button_mouse_entered)
	exit_button.mouse_entered.connect(_on_button_mouse_entered)

	# Conecta-se ao sinal de mudança de estado do GameManager.
	GlobalEvents.game_state_updated.connect(_on_game_state_updated)

func _exit_tree():
	# Desconecta os sinais para evitar vazamento de memória.
	GlobalEvents.game_state_updated.disconnect(_on_game_state_updated)


# --- Handlers de Botões ---

func _on_resume_button_pressed() -> void:
	CafeAudioManager.play_sfx_requested.emit("ui_click")
	# Volta ao jogo
	GlobalEvents.request_game_state_change.emit({"new_state": GameManager.GameState.keys()[GameManager.GameState.PLAYING], "reason": "resume_game"})

func _on_options_button_pressed() -> void:
	CafeAudioManager.play_sfx_requested.emit("ui_click")
	# Abre o menu de configurações.
	GlobalEvents.request_game_state_change.emit({"new_state": GameManager.GameState.keys()[GameManager.GameState.SETTINGS], "reason": "open_options_from_pause"})

func _on_exit_button_pressed() -> void:
	CafeAudioManager.play_sfx_requested.emit("ui_click")
	GlobalEvents.request_game_state_change.emit({"new_state": GameManager.GameState.keys()[GameManager.GameState.QUIT_CONFIRMATION], "reason": "exit_game_from_pause"})

func _on_button_mouse_entered():
	CafeAudioManager.play_sfx_requested.emit("ui_rollover", "SFX")


# --- Handlers de Sinais do GameManager ---

func _on_game_state_updated(state_data: Dictionary) -> void:
	# O menu de pausa só deve ser visível quando o jogo está no estado PAUSED.
	var new_state_key = state_data.get("new_state", "")
	visible = (new_state_key == GameManager.GameState.keys()[GameManager.GameState.PAUSED])
