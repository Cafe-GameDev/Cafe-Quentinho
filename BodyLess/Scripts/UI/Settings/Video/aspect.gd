extends HBoxContainer


func _on_aspect_ratio_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("aspect_ratio_changed", index)
