extends HBoxContainer

@onready var checkbox: CheckBox = $ReduceScreenShakeCheckBox

func _ready() -> void:
	GlobalEvents.reduce_screen_shake_changed.connect(_on_reduce_screen_shake_changed)
	checkbox.toggled.connect(_on_reduce_screen_shake_check_box_toggled)

func _on_reduce_screen_shake_check_box_toggled(button_pressed: bool) -> void:
	GlobalEvents.emit_signal("reduce_screen_shake_changed", button_pressed)

func _on_reduce_screen_shake_changed(enabled: bool) -> void:
	if checkbox.button_pressed != enabled:
		checkbox.button_pressed = enabled
