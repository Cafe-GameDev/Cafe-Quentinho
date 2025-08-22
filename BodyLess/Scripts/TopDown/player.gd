extends CharacterBody2D

const SPEED = 100.0

# Dicionário para armazenar a "mini-tabela" de inputs relevantes para o Player
var _player_input_map: Dictionary = {}

func _ready() -> void:
	print("TopDown Player Loaded!")
	var camera = Camera2D.new()
	add_child(camera)
	camera.make_current()

	# Conexão para receber o mapeamento de inputs do SettingsManager
	GlobalEvents.loading_input_map_changed.connect(_on_loading_input_map_changed)

func _physics_process(delta: float) -> void:
	# A lógica de movimento será baseada nos sinais de intenção emitidos por _unhandled_input
	# Por enquanto, manteremos a lógica de Input.get_vector para demonstração,
	# mas em um projeto real, isso seria substituído por variáveis de estado
	# atualizadas pelos sinais de input.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	# Processa inputs brutos e emite sinais de intenção
	if event.is_pressed():
		if _player_input_map.has("pause") and InputMap.event_is_action(event, "pause"):
			GlobalEvents.input_action_triggered.emit({"action": "pause", "state": "pressed"})
			get_viewport().set_input_as_handled()
		elif _player_input_map.has("inventory") and InputMap.event_is_action(event, "inventory"):
			GlobalEvents.input_action_triggered.emit({"action": "inventory", "state": "pressed"})
			get_viewport().set_input_as_handled()
		elif _player_input_map.has("reload") and InputMap.event_is_action(event, "reload"):
			GlobalEvents.input_action_triggered.emit({"action": "reload", "state": "pressed"})
			get_viewport().set_input_as_handled()
		elif _player_input_map.has("special") and InputMap.event_is_action(event, "special"):
			GlobalEvents.input_action_triggered.emit({"action": "special", "state": "pressed"})
			get_viewport().set_input_as_handled()
		elif _player_input_map.has("sprint") and InputMap.event_is_action(event, "sprint"):
			GlobalEvents.input_action_triggered.emit({"action": "sprint", "state": "toggled", "is_active": true})
			get_viewport().set_input_as_handled()
		elif _player_input_map.has("crouch") and InputMap.event_is_action(event, "crouch"):
			GlobalEvents.input_action_triggered.emit({"action": "crouch", "state": "toggled", "is_active": true})
			get_viewport().set_input_as_handled()
		elif _player_input_map.has("toggle_console") and InputMap.event_is_action(event, "toggle_console"):
			GlobalEvents.input_action_triggered.emit({"action": "debug_console", "state": "pressed"})
			get_viewport().set_input_as_handled()
		elif _player_input_map.has("music_change") and InputMap.event_is_action(event, "music_change"):
			GlobalEvents.music_change_requested.emit()
			get_viewport().set_input_as_handled()
		# Add other input actions here as needed

	elif event.is_released():
		if _player_input_map.has("sprint") and InputMap.event_is_action(event, "sprint"):
			GlobalEvents.input_action_triggered.emit({"action": "sprint", "state": "toggled", "is_active": false})
			get_viewport().set_input_as_handled()
		elif _player_input_map.has("crouch") and InputMap.event_is_action(event, "crouch"):
			GlobalEvents.input_action_triggered.emit({"action": "crouch", "state": "toggled", "is_active": false})
			get_viewport().set_input_as_handled()

func _on_loading_input_map_changed(input_map_data: Dictionary) -> void:
	print("[Player] Recebendo dados de mapeamento de input: ", input_map_data)
	# Armazena apenas as ações relevantes para o Player
	_player_input_map = input_map_data.get("player_actions", {})
	print("[Player] Mini-tabela de input para Player: ", _player_input_map)
