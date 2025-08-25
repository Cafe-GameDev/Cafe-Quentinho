extends Node

enum GameState { MENU, PLAYING, PAUSED, SETTINGS, QUIT_CONFIRMATION }

var current_game_state: GameState = GameState.MENU
var _previous_game_state: GameState = GameState.MENU # Para retornar após menus

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Garante que o jogo não comece pausado.
	get_tree().paused = false

	# Conecta aos sinais globais para receber solicitações de mudança de estado.
	GlobalEvents.request_game_state_change.connect(set_game_state)
	GlobalEvents.return_to_previous_state_requested.connect(_on_return_to_previous_state_requested)
	GlobalEvents.quit_confirmed.connect(_on_quit_confirmed)
	GlobalEvents.quit_cancelled.connect(_on_quit_cancelled)


func set_game_state(state_request_data: Dictionary) -> void:
	var new_state_key = state_request_data.get("new_state", "")
	if new_state_key.is_empty():
		printerr("GameManager: Tentativa de mudar o estado do jogo sem 'new_state' no dicionário.")
		return

	var new_state_index = GameState.keys().find(new_state_key)
	if new_state_index == -1:
		printerr("GameManager: Estado de jogo inválido solicitado: %s" % new_state_key)
		return
	var new_state = GameState.values()[new_state_index]

	if new_state == current_game_state:
		return # Não faz nada se o estado já for o atual.

	var old_state = current_game_state
	
	# Salva o estado anterior se estivermos entrando em um menu de sobreposição.
	if new_state == GameState.SETTINGS or new_state == GameState.QUIT_CONFIRMATION:
		_previous_game_state = old_state
	
	current_game_state = new_state
	print("GameManager: Mudando estado de %s para %s. Previous state: %s" % [GameState.keys()[old_state], GameState.keys()[new_state], GameState.keys()[_previous_game_state]])
	
	# A lógica de pausar/despausar o jogo e mostrar/esconder UI
	# é centralizada aqui, baseada no novo estado.
	match current_game_state:
		GameState.MENU:
			get_tree().paused = false
			GlobalEvents.hide_quit_confirmation_requested.emit() # Hide if returning from quit confirmation
		GameState.PLAYING:
			get_tree().paused = false
			GlobalEvents.hide_quit_confirmation_requested.emit() # Hide if returning from quit confirmation
		GameState.PAUSED:
			get_tree().paused = true
			GlobalEvents.hide_quit_confirmation_requested.emit() # Hide if returning from quit confirmation
		GameState.SETTINGS:
			get_tree().paused = true
			GlobalEvents.hide_quit_confirmation_requested.emit() # Hide if returning from quit confirmation
		GameState.QUIT_CONFIRMATION:
			get_tree().paused = true
			GlobalEvents.show_quit_confirmation_requested.emit() # Show quit confirmation dialog
	
	# Emite o sinal para que outros sistemas (como a UI) possam reagir.
	GlobalEvents.game_state_updated.emit({"new_state": GameState.keys()[new_state], "previous_state": GameState.keys()[old_state], "is_paused": get_tree().paused})


# --- Handlers de Sinais Globais ---
	
func _on_quit_confirmed() -> void:
	get_tree().quit()

func _on_quit_cancelled() -> void:
	print("GameManager: Quit cancelled. Returning to previous state: %s" % GameState.keys()[_previous_game_state])
	# Retorna ao estado que estava antes da confirmação de saída.
	set_game_state({"new_state": GameState.keys()[_previous_game_state], "reason": "return_from_quit_confirmation"})

func _on_return_to_previous_state_requested() -> void:
	# Usado por menus como Configurações para voltar ao estado anterior (Menu Principal ou Pausa).
	set_game_state({"new_state": GameState.keys()[_previous_game_state], "reason": "return_from_menu"})

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		match current_game_state:
			GameState.PLAYING:
				set_game_state({"new_state": GameState.keys()[GameState.PAUSED], "reason": "user_pause"})
			GameState.PAUSED:
				set_game_state({"new_state": GameState.keys()[GameState.PLAYING], "reason": "user_unpause"})
			GameState.SETTINGS:
				# Se estiver em SETTINGS, retorna ao estado anterior (MENU ou PAUSED)
				GlobalEvents.return_to_previous_state_requested.emit()
			GameState.MENU:
				# Se estiver no MENU, mostra a confirmação de saída
				GlobalEvents.show_quit_confirmation_requested.emit()
