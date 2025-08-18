extends HBoxContainer

@onready var slider: HSlider = $BrightnessSlider

func _ready() -> void:
	GlobalEvents.brightness_changed.connect(_on_brightness_changed)

func _on_brightness_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalEvents.emit_signal("brightness_changed", slider.value)

func _on_brightness_changed(value: float) -> void:
	if not is_equal_approx(slider.value, value):
		slider.value = value
