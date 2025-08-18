extends HBoxContainer

@onready var option_button: OptionButton = $ResolutionOptionButton
var resolutions: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

func _ready() -> void:
	GlobalEvents.video_resolution_changed.connect(_on_video_resolution_changed)
	for i in range(resolutions.size()):
		option_button.add_item("%d x %d" % [resolutions[i].x, resolutions[i].y], i)


func _on_resolution_option_button_item_selected(index: int) -> void:
	if index >= 0 and index < resolutions.size():
		GlobalEvents.emit_signal("video_resolution_changed", resolutions[index])

func _on_video_resolution_changed(new_resolution: Vector2i) -> void:
	for i in range(resolutions.size()):
		if resolutions[i] == new_resolution:
			if option_button.selected != i:
				option_button.select(i)
			return
