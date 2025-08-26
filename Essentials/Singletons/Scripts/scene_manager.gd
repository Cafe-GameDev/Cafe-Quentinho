class_name SceneManager
extends Control

# Gerencia as transições de cena no jogo usando um sistema de empilhamento.
@onready var main_menu: Panel = $MenuViewportContainer/GameViewport/Control/MainMenu
@onready var pause_menu: Panel = $MenuViewportContainer/GameViewport/Control/PauseMenu
@onready var options_menu: Panel = $MenuViewportContainer/GameViewport/Control/OptionsMenu
@onready var quit_confirmation_dialog: PanelContainer = $MenuViewportContainer/GameViewport/Control/QuitConfirmationDialog

@onready var game_viewport: SubViewport = $GameViewportContainer/GameViewport
var _scene_stack: Array[Node] = [] # Pilha de cenas carregadas

func _ready():
	# Conecta-se aos sinais do EventBus para gerenciar as cenas.
	GlobalEvents.scene_push_requested.connect(_on_scene_push_requested)
	GlobalEvents.scene_pop_requested.connect(_on_scene_pop_requested)
	GlobalEvents.game_state_updated.connect(_on_game_state_updated) # Conecta ao sinal de atualização de estado do jogo
	CafeAudioManager.emit_signal("request_audio_start")
	
	# A cena inicial (MainMenu, etc.) agora está em um CanvasLayer separado.
	# Não precisamos mais inicializá-las aqui.


func _on_scene_push_requested(path: String):
	"""
	Carrega uma nova cena e a adiciona à pilha, ou a traz para frente se já estiver carregada.
	"""
	if path.is_empty():
		printerr("SceneManager: Recebido pedido para carregar cena com caminho vazio.")
		return

	# Lógica "Inteligente": Verifica se a cena já está na pilha.
	for i in range(_scene_stack.size()):
		var existing_scene = _scene_stack[i]
		if existing_scene.scene_file_path == path:
			print("SceneManager: Cena '%s' já está na pilha. Trazendo para frente." % path)
			# Esconde a cena atual
			if not _scene_stack.is_empty():
				_scene_stack.back().hide()
			# Move a cena existente para o topo da pilha
			_scene_stack.remove_at(i)
			_scene_stack.push_back(existing_scene)
			# Mostra a cena que agora está no topo
			existing_scene.show()
			existing_scene.process_mode = Node.PROCESS_MODE_INHERIT
			GlobalEvents.scene_updated.emit({"path": path, "type": "game_world"})
			return

	# Se a cena não estava na pilha, carrega-a.
	if not ResourceLoader.exists(path):
		printerr("SceneManager: Caminho da cena inválido ou não encontrado: ", path)
		return
		
	# Esconde a cena atual no topo da pilha.
	if not _scene_stack.is_empty():
		_scene_stack.back().hide()

	# Carrega e instancia a nova cena.
	var new_scene = load(path).instantiate()
	
	# Adiciona a nova cena como filha do GameViewport.
	game_viewport.add_child(new_scene)
	_scene_stack.append(new_scene)

	GlobalEvents.scene_updated.emit({"path": path, "type": "game_world"})


func _on_game_state_updated(state_data: Dictionary) -> void:
	var new_state = state_data.get("new_state", "")
	var is_paused = state_data.get("is_paused", false)

	# Esconde todas as UIs por padrão e mostra apenas as relevantes.
	main_menu.visible = false
	pause_menu.visible = false
	options_menu.visible = false
	quit_confirmation_dialog.visible = false

	match new_state:
		"MENU":
			main_menu.visible = true
		"PLAYING":
			pass # Nenhuma UI de menu visível durante o jogo.
		"PAUSED":
			pause_menu.visible = true
		"SETTINGS":
			options_menu.visible = true
		"QUIT_CONFIRMATION":
			quit_confirmation_dialog.visible = true

	# Ajusta o process_mode das cenas de jogo com base no estado de pausa.
	for scene in _scene_stack:
		if scene != null and is_instance_valid(scene):
			scene.process_mode = Node.PROCESS_MODE_INHERIT if not is_paused else Node.PROCESS_MODE_DISABLED


func _on_scene_pop_requested():
	"""
	Remove a cena atual da pilha e retorna à cena anterior.
	"""
	if _scene_stack.size() <= 1:
		printerr("SceneManager: Não há cenas para remover da pilha.")
		# Em um jogo real, poderia voltar ao menu principal ou sair.
		get_tree().quit()
		return

	# Remove e libera a cena atual.
	var current_scene = _scene_stack.pop_back()
	current_scene.queue_free()

	# Ativa e exibe a cena anterior.
	if not _scene_stack.is_empty():
		var previous_scene = _scene_stack.back()
		previous_scene.show()
		previous_scene.process_mode = Node.PROCESS_MODE_INHERIT
		GlobalEvents.scene_updated.emit({"path": previous_scene.scene_file_path, "type": "game_world"})
