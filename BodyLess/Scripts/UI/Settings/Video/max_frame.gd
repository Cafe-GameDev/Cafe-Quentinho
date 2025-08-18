extends HBoxContainer

@onready var slider: HSlider = $MaxFrameRateSlider

func _ready() -> void:
	GlobalEvents.max_frame_rate_changed.connect(_on_max_frame_rate_changed)

func _on_max_frame_rate_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalEvents.emit_signal("max_frame_rate_changed", int(slider.value))

func _on_max_frame_rate_changed(fps_value: int) -> void:
	if not is_equal_approx(slider.value, fps_value):
		slider.value = fps_value
