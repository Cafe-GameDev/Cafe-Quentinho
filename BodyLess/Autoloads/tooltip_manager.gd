extends Node

# O TooltipManager gerencia a exibição e ocultação de tooltips.
# Ele ouve os sinais do GlobalEvents e gerencia a instância da cena Tooltip.tscn.

const TOOLTIP_SCENE = preload("res://Scenes/UI/Components/Tooltip.tscn")

var _current_tooltip_instance: Control = null

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	GlobalEvents.show_tooltip_requested.connect(_on_show_tooltip_requested)
	GlobalEvents.hide_tooltip_requested.connect(_on_hide_tooltip_requested)

func _on_show_tooltip_requested(tooltip_data: Dictionary) -> void:
	var text_to_display: String = tooltip_data.get("text", "")
	var position: Vector2 = tooltip_data.get("position", Vector2.ZERO)
	var duration: float = tooltip_data.get("duration", 0.0) # Not currently used, but for future extensibility

	if _current_tooltip_instance:
		_current_tooltip_instance.queue_free()
		_current_tooltip_instance = null

	_current_tooltip_instance = TOOLTIP_SCENE.instantiate()
	get_tree().root.add_child(_current_tooltip_instance) # Adiciona ao root para estar sempre no topo

	# Configura o texto do tooltip
	var tooltip_label = _current_tooltip_instance.find_child("Label")
	if tooltip_label:
		tooltip_label.text = tr(text_to_display) # Simplify tr() call

	_current_tooltip_instance.position = position
	_current_tooltip_instance.visible = true

func _on_hide_tooltip_requested() -> void:
	if _current_tooltip_instance:
		_current_tooltip_instance.queue_free()
		_current_tooltip_instance = null
