extends HBoxContainer

@onready var slider: HSlider = $SfxSlider

func _ready() -> void:
	GlobalEvents.sfx_volume_changed.connect(_on_sfx_volume_changed)

func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalEvents.emit_signal("sfx_volume_changed", slider.value)

func _on_sfx_volume_changed(linear_volume: float) -> void:
	if not is_equal_approx(slider.value, linear_volume):
		slider.value = linear_volume
