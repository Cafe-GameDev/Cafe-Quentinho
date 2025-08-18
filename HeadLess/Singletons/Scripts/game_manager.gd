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

	GlobalEvents.pause_toggled.connect(_on_pause_toggled) # Connect to the new pause signal


func set_game_state(new_state: GameState) -> void:
	if new_state == current_game_state:
		return # Não faz nada se o estado já for o atual.

	var old_state = current_game_state
	
	# Salva o estado anterior se estivermos entrando em um menu de sobreposição.
	if new_state == GameState.SETTINGS or new_state == GameState.QUIT_CONFIRMATION:
		_previous_game_state = old_state
	
	current_game_state = new_state
	print("GameManager: Mudando estado de %s para %s" % [GameState.keys()[old_state], GameState.keys()[new_state]])
	
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
	GlobalEvents.game_state_changed.emit(new_state)


# --- Handlers de Sinais Globais ---
	
func _on_quit_confirmed() -> void:
	get_tree().quit()

func _on_quit_cancelled() -> void:
	# Retorna ao estado que estava antes da confirmação de saída.
	set_game_state(_previous_game_state)

func _on_return_to_previous_state_requested() -> void:
	# Usado por menus como Configurações para voltar ao estado anterior (Menu Principal ou Pausa).
	set_game_state(_previous_game_state)

func _on_pause_toggled() -> void:
	# Lógica de pausa baseada no estado atual do jogo
	match current_game_state:
		GameState.PLAYING:
			set_game_state(GameState.PAUSED)
		GameState.PAUSED:
			set_game_state(GameState.PLAYING)
		GameState.SETTINGS:
			# Se estiver em SETTINGS, retorna ao estado anterior (MENU ou PAUSED)
			GlobalEvents.return_to_previous_state_requested.emit()
		GameState.MENU:
			# Se estiver no MENU, fecha o jogo
			get_tree().quit()
