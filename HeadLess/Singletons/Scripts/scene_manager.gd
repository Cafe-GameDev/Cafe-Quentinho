class_name SceneManager
extends Node

# Gerencia as transições de cena no jogo usando um sistema de empilhamento.

@onready var game_viewport: SubViewport = $GameViewportContainer/GameViewport
var _scene_stack: Array[Node] = [] # Pilha de cenas carregadas

func _ready():
	# Conecta-se aos sinais do EventBus para gerenciar as cenas.
	GlobalEvents.scene_push_requested.connect(_on_scene_push_requested)
	GlobalEvents.scene_pop_requested.connect(_on_scene_pop_requested)

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
			GlobalEvents.scene_changed.emit(path)
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

	GlobalEvents.scene_changed.emit(path)


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
		GlobalEvents.scene_changed.emit(previous_scene.scene_file_path)
