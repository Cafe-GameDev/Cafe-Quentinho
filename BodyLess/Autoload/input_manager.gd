extends Node

# O InputManager captura os eventos de input globais e emite sinais de "intenção".
# Ele não sabe o que vai acontecer, apenas informa que uma ação foi pressionada.

func _ready() -> void:
	# Garante que este nó receba input mesmo quando a árvore de cenas está pausada.
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	# Usamos _unhandled_input para que a UI possa consumir os eventos primeiro.

	if event.is_action_pressed("pause"):
		GlobalEvents.pause_toggled.emit()
		# Marca o evento como manipulado para que outros nós não o processem.
		get_tree().get_root().set_input_as_handled()

	if event.is_action_pressed("music_change"):
		GlobalEvents.music_change_requested.emit()
		get_tree().get_root().set_input_as_handled()

	if event.is_action_pressed("toggle_console"):
		GlobalEvents.debug_console_toggled.emit()
		get_tree().get_root().set_input_as_handled()
