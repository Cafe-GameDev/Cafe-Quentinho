extends Node

# Enum para definir todos os estados possíveis da máquina de estados global.
# Isso centraliza a lógica de fluxo do jogo, determinando o que pode acontecer em cada momento.
enum State {
	MENU, # O jogador está no menu principal.
	SETTINGS, # O jogador está no menu de opções.
	LOADING, # O jogo está carregando uma cena/nível.
	PLAYING, # O jogador está ativamente no jogo.
	PLAYING_SAVING, # O jogo está salvando em segundo plano (autosave), mas a jogabilidade continua.
	PAUSED, # O jogo está pausado e o menu de pause está visível.
	QUIT_CONFIRMATION, # A caixa de diálogo "Deseja sair?" está na tela.
	SAVING_QUIT # O jogo está salvando os dados antes de fechar.
}

# A variável que armazena o estado atual do jogo.
var current_state: State = State.MENU
# Armazena o estado anterior para poder retornar de menus de sobreposição como SETTINGS.
var _previous_state: State = State.MENU


func _ready() -> void:
	# Garante que o jogo não comece pausado e que o processo da máquina de estados
	# continue mesmo quando o jogo estiver pausado.
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false

	# Conecta-se aos sinais de "intenção" do GlobalEvents para acionar as transições de estado.
	GlobalEvents.pause_toggled.connect(_on_pause_toggled)
	GlobalEvents.show_settings_menu_requested.connect(func(): _request_state_change(State.SETTINGS))
	GlobalEvents.show_quit_confirmation_requested.connect(func(): _request_state_change(State.QUIT_CONFIRMATION))
	GlobalEvents.return_to_previous_state_requested.connect(_on_return_to_previous_state_requested)
	GlobalEvents.quit_confirmed.connect(_on_quit_confirmed)
	GlobalEvents.quit_cancelled.connect(_on_quit_cancelled)
	GlobalEvents.scene_changed.connect(_on_scene_changed)


# Ponto de entrada central para todas as solicitações de mudança de estado.
# No futuro, pode conter lógica para validar se uma transição é permitida.
func _request_state_change(new_state: State) -> void:
	if new_state == current_state:
		return

	_change_state(new_state)


# Executa a mudança de estado e seus efeitos colaterais diretos.
func _change_state(new_state: State) -> void:
	var old_state = current_state

	# Salva o estado anterior se estivermos entrando em um menu de sobreposição.
	if new_state == State.SETTINGS or new_state == State.QUIT_CONFIRMATION:
		_previous_state = old_state

	current_state = new_state
	print("GlobalMachine: State changed from %s to %s" % [State.keys()[old_state], State.keys()[new_state]])

	# A lógica de pausar/despausar o jogo é um efeito colateral direto do estado
	# e é gerenciada aqui.
	match current_state:
		State.MENU, State.LOADING:
			get_tree().paused = false
		State.PLAYING, State.PLAYING_SAVING:
			get_tree().paused = false
		State.PAUSED, State.SETTINGS, State.QUIT_CONFIRMATION, State.SAVING_QUIT:
			get_tree().paused = true

	# Emite o sinal para que outros sistemas (como o SceneControl para a UI) possam reagir.
	GlobalEvents.game_state_changed.emit(current_state, old_state)


# --- Handlers de Sinais ---

func _on_pause_toggled() -> void:
	match current_state:
		State.PLAYING:
			_request_state_change(State.PAUSED)
		State.PAUSED:
			_request_state_change(State.PLAYING)
		State.SETTINGS:
			# Se estiver em SETTINGS, a ação de "pausa" funciona como "voltar".
			_on_return_to_previous_state_requested()


func _on_return_to_previous_state_requested() -> void:
	# Usado por menus como Configurações para voltar ao estado anterior (Menu ou Pausa).
	_request_state_change(_previous_state)


func _on_quit_confirmed() -> void:
	# Aqui poderíamos transicionar para SAVING_QUIT se necessário.
	# Por enquanto, vamos direto ao ponto.
	get_tree().quit()


func _on_quit_cancelled() -> void:
	# Retorna ao estado que estava antes da confirmação de saída.
	_request_state_change(_previous_state)


func _on_scene_changed(scene_path: String) -> void:
	if scene_path.contains("world.tscn"):
		_request_state_change(State.PLAYING)
	elif scene_path.contains("main_menu.tscn"):
		_request_state_change(State.MENU)
