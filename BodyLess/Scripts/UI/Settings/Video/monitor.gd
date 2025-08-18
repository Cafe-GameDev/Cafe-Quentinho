extends HBoxContainer

@onready var option_button: OptionButton = $MonitorOptionButton

func _ready() -> void:
	GlobalEvents.monitor_changed.connect(_on_monitor_changed)
	# Popula os monitores disponíveis.
	for i in range(DisplayServer.get_screen_count()):
		option_button.add_item("Monitor " + str(i + 1), i)

func _on_monitor_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("monitor_changed", index)

func _on_monitor_changed(monitor_index: int) -> void:
	if option_button.selected != monitor_index:
		option_button.select(monitor_index)
