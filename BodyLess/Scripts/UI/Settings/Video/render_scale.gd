extends HBoxContainer

@onready var slider: HSlider = $RenderScaleSlider

func _ready() -> void:
	GlobalEvents.render_scale_changed.connect(_on_render_scale_changed)

func _on_render_scale_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalEvents.emit_signal("render_scale_changed", slider.value)

func _on_render_scale_changed(value: float) -> void:
	if not is_equal_approx(slider.value, value):
		slider.value = value
