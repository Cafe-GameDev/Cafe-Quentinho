extends HBoxContainer

@onready var option_button: OptionButton = $DynamicRenderScaleOptionButton

func _ready() -> void:
	GlobalEvents.dynamic_render_scale_changed.connect(_on_dynamic_render_scale_changed)
	# TODO: Popular o OptionButton com as opções.

func _on_dynamic_render_scale_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("dynamic_render_scale_changed", index)

func _on_dynamic_render_scale_changed(mode_index: int) -> void:
	if option_button.selected != mode_index:
		option_button.select(mode_index)
