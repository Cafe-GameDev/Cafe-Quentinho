extends HBoxContainer

@onready var slider: HSlider = $ContrastSlider

func _ready() -> void:
	GlobalEvents.contrast_changed.connect(_on_contrast_changed)

func _on_contrast_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalEvents.emit_signal("contrast_changed", slider.value)

func _on_contrast_changed(value: float) -> void:
	if not is_equal_approx(slider.value, value):
		slider.value = value
