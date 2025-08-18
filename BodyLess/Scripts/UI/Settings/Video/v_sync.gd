extends HBoxContainer

@onready var option_button: OptionButton = $VSyncOptionButton

func _ready() -> void:
	GlobalEvents.vsync_mode_changed.connect(_on_vsync_mode_changed)
	# Popula com os modos de VSync
	option_button.add_item("Desligado", DisplayServer.VSYNC_DISABLED)
	option_button.add_item("Ligado", DisplayServer.VSYNC_ENABLED)
	option_button.add_item("Adaptativo", DisplayServer.VSYNC_ADAPTIVE)
	option_button.add_item("Mailbox", DisplayServer.VSYNC_MAILBOX)

func _on_v_sync_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("vsync_mode_changed", option_button.get_item_id(index))

func _on_vsync_mode_changed(mode: int) -> void:
	for i in range(option_button.item_count):
		if option_button.get_item_id(i) == mode:
			if option_button.selected != i:
				option_button.select(i)
			return
