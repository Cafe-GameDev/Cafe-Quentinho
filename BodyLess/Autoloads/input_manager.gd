extends Node

# O InputManager é responsável por capturar eventos de input brutos (teclado, controle)
# e traduzi-los em sinais de "intenção" no GlobalEvents.
# Ele não sabe o que a ação "pause" faz, apenas anuncia que ela foi solicitada.



func _ready() -> void:
	GlobalEvents.input_map_changed.connect(_on_input_map_changed)
	
	GlobalEvents.request_saving_input_map_changed.connect(_on_request_saving_input_map_changed)
	GlobalEvents.input_map_data_for_save_received.connect(_on_input_map_data_for_save_received)

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

	if event.is_action_pressed("inventory"):
		GlobalEvents.emit_signal("input_inventory_pressed")
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("reload"):
		GlobalEvents.emit_signal("input_reload_pressed")
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("special"):
		GlobalEvents.emit_signal("input_special_pressed")
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("sprint"):
		GlobalEvents.emit_signal("input_sprint_toggled", true)
		get_viewport().set_input_as_handled()

	if event.is_action_released("sprint"):
		GlobalEvents.emit_signal("input_sprint_toggled", false)
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("crouch"):
		GlobalEvents.emit_signal("input_crouch_toggled", true)
		get_viewport().set_input_as_handled()

	if event.is_action_released("crouch"):
		GlobalEvents.emit_signal("input_crouch_toggled", false)
		get_viewport().set_input_as_handled()

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			GlobalEvents.emit_signal("play_sfx_by_key_requested", "ui_click")
			get_viewport().set_input_as_handled()


func _on_input_map_changed(action_list: Array) -> void:
	# Este sinal é emitido pela UI quando um mapeamento é alterado.
	# O InputManager não precisa fazer muito aqui, pois o InputMap do Godot
	# já gerencia os mapeamentos globalmente. No entanto, registramos a lista
	# de ações alteradas para fins de depuração ou futura lógica específica.
	print("InputManager: Mapeamento de input alterado para as ações: ", action_list)
	# Podemos usar isso para, por exemplo, forçar um salvamento
	# das configurações de input se quisermos salvar automaticamente.
	GlobalEvents.request_saving_input_map_changed.emit()





func _on_input_map_data_for_save_received(input_map_data: Dictionary) -> void:
	# O SettingsManager enviou os dados do InputMap carregados.
	# Aplica esses mapeamentos ao InputMap do Godot.
	for action_name in input_map_data:
		var events_data: Array = input_map_data[action_name]
		
		# Limpa todos os eventos existentes para esta ação antes de aplicar os novos
		for event in InputMap.action_get_events(action_name):
			InputMap.action_erase_event(action_name, event)
		
		for event_data in events_data:
			var event_type: String = event_data.get("type", "")
			var new_event: InputEvent
			
			match event_type:
				"InputEventKey":
					new_event = InputEventKey.new()
					new_event.keycode = event_data.get("keycode", 0)
					new_event.physical_keycode = event_data.get("physical_keycode", 0)
					new_event.unicode = event_data.get("unicode", 0)
					new_event.pressed = event_data.get("pressed", false)
				"InputEventJoypadButton":
					new_event = InputEventJoypadButton.new()
					new_event.button_index = event_data.get("button_index", 0)
					new_event.pressed = event_data.get("pressed", false)
				"InputEventJoypadMotion":
					new_event = InputEventJoypadMotion.new()
					new_event.axis = event_data.get("axis", 0)
					new_event.axis_value = event_data.get("axis_value", 0.0)
				"InputEventMouseButton":
					new_event = InputEventMouseButton.new()
					new_event.button_index = event_data.get("button_index", 0)
					new_event.pressed = event_data.get("pressed", false)
				_:
					printerr("InputManager: Tipo de evento desconhecido ao carregar: %s" % event_type)
					continue
			InputMap.action_add_event(action_name, new_event)
	
	# Opcional: Notificar a UI de InputMap para atualizar seus botões
	GlobalEvents.loading_input_map_changed.emit(input_map_data)


func _on_request_saving_input_map_changed() -> void:
	# O SettingsManager está pedindo os dados do InputMap para salvar.
	# Coleta os mapeamentos atuais do InputMap e os envia.
	var input_map_data: Dictionary = {}
	for action_name in InputMap.get_actions():
		var events_data: Array = []
		for event in InputMap.action_get_events(action_name):
			var event_dict: Dictionary = {}
			if event is InputEventKey:
				event_dict = {
					"type": "InputEventKey",
					"keycode": event.keycode,
					"physical_keycode": event.physical_keycode,
					"unicode": event.unicode,
					"pressed": event.pressed
				}
			elif event is InputEventJoypadButton:
				event_dict = {
					"type": "InputEventJoypadButton",
					"button_index": event.button_index,
					"pressed": event.pressed
				}
			elif event is InputEventJoypadMotion:
				event_dict = {
					"type": "InputEventJoypadMotion",
					"axis": event.axis,
					"axis_value": event.axis_value
				}
			elif event is InputEventMouseButton:
				event_dict = {
					"type": "InputEventMouseButton",
					"button_index": event.button_index,
					"pressed": event.pressed
				}
			events_data.append(event_dict)
		input_map_data[action_name] = events_data
	
	GlobalEvents.input_map_data_for_save_received.emit(input_map_data)
