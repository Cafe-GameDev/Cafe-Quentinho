extends Node

# O InputManager é responsável por capturar eventos de input brutos (teclado, controle)
# e traduzi-los em sinais de "intenção" no GlobalEvents.
# Ele não sabe o que a ação "pause" faz, apenas anuncia que ela foi solicitada.

func _unhandled_input(event: InputEvent) -> void:
	# Usamos _unhandled_input para que a UI possa consumir os eventos primeiro.
	# Se o evento chegar aqui, significa que nenhuma UI o utilizou.
	if event.is_action_pressed("pause"):
		# Anuncia a intenção de pausar/despausar.
		# A GlobalMachine decidirá o que fazer com base no estado atual.
		GlobalEvents.emit_signal("pause_toggled")
		# Marca o evento como consumido para evitar que outros nós o processem.
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("toggle_console"):
		GlobalEvents.emit_signal("debug_console_toggled")
		get_viewport().set_input_as_handled()
		
	if event.is_action_pressed("music_change"):
		GlobalEvents.emit_signal("music_change_requested")
		get_viewport().set_input_as_handled()