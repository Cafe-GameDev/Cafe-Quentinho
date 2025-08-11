extends Node

# Responsável por carregar, descarregar e transicionar entre cenas.

var current_scene: Node
var loaded_scenes: Dictionary = {} # Cache para cenas já carregadas

var transition_layer: CanvasLayer
var color_rect: ColorRect
var tween: Tween

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	loaded_scenes[current_scene.scene_file_path] = current_scene
	
	# Prepara a camada de transição
	transition_layer = CanvasLayer.new()
	transition_layer.layer = 128
	add_child(transition_layer)
	
	color_rect = ColorRect.new()
	color_rect.anchors_preset = Control.PRESET_FULL_RECT
	color_rect.color = Color(0, 0, 0, 0)
	transition_layer.add_child(color_rect)

func change_scene_to_file(path: String) -> void:
	if tween and tween.is_running():
		return

	# Fade para preto
	tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 1), 0.5)
	await tween.finished

	# Desativa a cena atual
	current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	current_scene.hide()

	# Verifica se a nova cena já foi carregada
	if loaded_scenes.has(path):
		current_scene = loaded_scenes[path]
		current_scene.process_mode = Node.PROCESS_MODE_INHERIT
		current_scene.show()
	else:
		var next_scene_res = load(path)
		current_scene = next_scene_res.instantiate()
		current_scene.scene_file_path = path
		get_tree().root.add_child(current_scene)
		loaded_scenes[path] = current_scene

	# Fade para transparente
	tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 0), 0.5)
	await tween.finished
