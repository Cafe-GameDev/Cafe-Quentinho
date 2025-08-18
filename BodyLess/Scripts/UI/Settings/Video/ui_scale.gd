extends HBoxContainer

@onready var option_button: OptionButton = $UIScaleOptionButton

func _ready() -> void:
	GlobalEvents.ui_scale_preset_changed.connect(_on_ui_scale_preset_changed)
	# TODO: Popular com presets de escala. Ex: "100%", "125%", "150%"

func _on_ui_scale_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("ui_scale_preset_changed", option_button.get_item_text(index))

func _on_ui_scale_preset_changed(preset_name: String) -> void:
	for i in range(option_button.item_count):
		if option_button.get_item_text(i) == preset_name:
			if option_button.selected != i:
				option_button.select(i)
			return
