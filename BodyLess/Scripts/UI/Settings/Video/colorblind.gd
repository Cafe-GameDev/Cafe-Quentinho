extends HBoxContainer

@onready var option_button: OptionButton = $ColorblindModeOptionButton

func _ready() -> void:
	GlobalEvents.colorblind_mode_changed.connect(_on_colorblind_mode_changed)
	# TODO: Popular o OptionButton com os modos de daltonismo.
	# option_button.add_item("Nenhum", 0)
	# option_button.add_item("Protanopia", 1) ...

func _on_colorblind_mode_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("colorblind_mode_changed", index)

func _on_colorblind_mode_changed(mode_index: int) -> void:
	if option_button.selected != mode_index:
		option_button.select(mode_index)
