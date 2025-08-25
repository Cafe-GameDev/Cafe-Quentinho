extends PanelContainer

@onready var yes_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/YesButton
@onready var no_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/NoButton

func _ready() -> void:
	# Conecta-se ao sinal de mudança de estado do GameManager.
	GlobalEvents.game_state_updated.connect(_on_game_state_updated)
	
	# Conecta os botões a funções de callback nomeadas para maior robustez.
	yes_button.pressed.connect(_on_yes_button_pressed)
	no_button.pressed.connect(_on_no_button_pressed)
	
	# Esconde o diálogo por padrão
	hide()
	
	# Garante que o diálogo processa input mesmo com o jogo pausado
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Conecta-se aos sinais globais para mostrar/esconder a UI
	GlobalEvents.show_quit_confirmation_requested.connect(_on_show_quit_confirmation_requested)
	GlobalEvents.hide_quit_confirmation_requested.connect(_on_hide_quit_confirmation_requested)

func _exit_tree():
	# Desconecta os sinais para evitar vazamento de memória.
	GlobalEvents.show_quit_confirmation_requested.disconnect(_on_show_quit_confirmation_requested)
	GlobalEvents.hide_quit_confirmation_requested.disconnect(_on_hide_quit_confirmation_requested)


func _on_yes_button_pressed() -> void:
	GlobalEvents.quit_confirmed.emit()


func _on_no_button_pressed() -> void:
	GlobalEvents.quit_cancelled.emit()
	hide()

func _on_show_quit_confirmation_requested() -> void:
	show()

func _on_hide_quit_confirmation_requested() -> void:
	hide()

func _on_game_state_updated(state_data: Dictionary) -> void:
	# O menu de pausa só deve ser visível quando o jogo está no estado PAUSED.
	var new_state_key = state_data.get("new_state", "")
	visible = (new_state_key == GameManager.GameState.keys()[GameManager.GameState.QUIT_CONFIRMATION])
