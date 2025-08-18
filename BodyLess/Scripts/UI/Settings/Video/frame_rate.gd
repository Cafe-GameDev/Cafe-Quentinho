extends HBoxContainer

@onready var option_button: OptionButton = $FrameRateLimitOptionButton

func _ready() -> void:
	GlobalEvents.frame_rate_limit_changed.connect(_on_frame_rate_limit_changed)
	# TODO: Popular o OptionButton com os limites de FPS.

func _on_frame_rate_limit_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("frame_rate_limit_changed", index)

func _on_frame_rate_limit_changed(mode_index: int) -> void:
	if option_button.selected != mode_index:
		option_button.select(mode_index)
