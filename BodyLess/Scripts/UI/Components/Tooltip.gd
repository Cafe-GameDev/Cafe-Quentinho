extends CanvasLayer
class_name Tooltip

@onready var tooltip_container: Control = $TooltipContainer
@onready var background: ColorRect = $TooltipContainer/Background
@onready var text_label: Label = $TooltipContainer/TextLabel

func _ready() -> void:
	# O tooltip começa invisível por padrão.
	tooltip_container.visible = false
	set_process(false) # Desabilita _process por padrão para economizar recursos

func _process(delta: float) -> void:
	# Faz o tooltip seguir a posição do mouse com um pequeno offset.
	tooltip_container.global_position = get_viewport().get_mouse_position() + Vector2(10, 10)

func show_tooltip(text: String, position: Vector2) -> void:
	text_label.text = text
	tooltip_container.global_position = position # Define a posição inicial
	tooltip_container.visible = true
	set_process(true) # Habilita _process para seguir o mouse

func hide_tooltip() -> void:
	tooltip_container.visible = false
	set_process(false) # Desabilita _process quando o tooltip está escondido
