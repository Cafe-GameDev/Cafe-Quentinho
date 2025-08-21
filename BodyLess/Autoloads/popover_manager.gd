extends Node

@onready var popover_scene: PackedScene = preload("res://Scenes/UI/Components/Popover.tscn")
var _current_popover: Control = null

func _ready() -> void:
	GlobalEvents.show_popover_requested.connect(_on_show_popover_requested)
	GlobalEvents.hide_popover_requested.connect(_on_hide_popover_requested)

func _on_show_popover_requested(content_data: Dictionary, parent_node: Node) -> void:
	if not _current_popover:
		_current_popover = popover_scene.instantiate()
		get_tree().root.add_child(_current_popover)
	
	_current_popover.setup_popover(content_data)
	
	# Posiciona o popover perto do nó pai
	var parent_global_pos = parent_node.global_position
	var parent_size = parent_node.size
	_current_popover.global_position = parent_global_pos + Vector2(parent_size.x / 2 - _current_popover.size.x / 2, parent_size.y + 10)

func _on_hide_popover_requested() -> void:
	if _current_popover:
		_current_popover.hide_popover()
