extends PanelContainer

@onready var yes_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/YesButton
@onready var no_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/NoButton

func _ready() -> void:
	# Conecta os botões a funções de callback nomeadas para maior robustez.
	yes_button.pressed.connect(_on_yes_button_pressed)
	no_button.pressed.connect(_on_no_button_pressed)
	
	# Esconde o diálogo por padrão
	hide()
	
	# Garante que o diálogo processa input mesmo com o jogo pausado
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Conecta-se aos sinais globais para mostrar/esconder a UI
	GlobalEvents.show_quit_confirmation_requested.connect(show)
	GlobalEvents.hide_quit_confirmation_requested.connect(hide)

func _exit_tree():
	# Desconecta os sinais para evitar vazamento de memória.
	GlobalEvents.show_quit_confirmation_requested.disconnect(show)
	GlobalEvents.hide_quit_confirmation_requested.disconnect(hide)


func _on_yes_button_pressed() -> void:
	GlobalEvents.quit_confirmed.emit()


func _on_no_button_pressed() -> void:
	GlobalEvents.quit_cancelled.emit()
