extends HBoxContainer

@onready var slider: HSlider = $GammaCorrectionSlider

func _ready() -> void:
	GlobalEvents.gamma_correction_changed.connect(_on_gamma_correction_changed)

func _on_gamma_correction_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalEvents.emit_signal("gamma_correction_changed", slider.value)

func _on_gamma_correction_changed(value: float) -> void:
	if not is_equal_approx(slider.value, value):
		slider.value = value
