extends Node

@onready var toast_scene: PackedScene = preload("res://Scenes/UI/Components/Toast.tscn")
var _toast_queue: Array = []
var _is_showing_toast: bool = false

func _ready() -> void:
	GlobalEvents.show_toast_requested.connect(_on_show_toast_requested)

func _on_show_toast_requested(toast_data: Dictionary) -> void:
	var message: String = toast_data.get("message", "")
	var type: String = toast_data.get("type", "info")
	_toast_queue.push_back({"message": message, "type": type})
	if not _is_showing_toast:
		_show_next_toast()

func _show_next_toast() -> void:
	if _toast_queue.is_empty():
		_is_showing_toast = false
		return

	_is_showing_toast = true
	var toast_data = _toast_queue.pop_front()
	var toast_instance: Control = toast_scene.instantiate()
	get_tree().root.add_child(toast_instance)
	toast_instance.show_toast(toast_data["message"], toast_data["type"])
	
	# Conecta ao sinal de término da animação para mostrar o próximo toast
	# Await para garantir que a animação comece antes de conectar o sinal de término
	await toast_instance.animation_player.animation_finished
	_show_next_toast()
