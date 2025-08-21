extends HBoxContainer

@onready var option_button: OptionButton = $VSyncOptionButton
@onready var vsync_label: Label = $VSyncLabel

func _ready() -> void:
	# Conecta aos sinais do GlobalEvents para carregar configurações
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Conecta os sinais de mouse para tooltips
	vsync_label.mouse_entered.connect(_on_mouse_entered_control.bind(vsync_label))
	vsync_label.mouse_exited.connect(_on_mouse_exited_control)
	option_button.mouse_entered.connect(_on_mouse_entered_control.bind(option_button))
	option_button.mouse_exited.connect(_on_mouse_exited_control)


func _on_v_sync_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("setting_changed", {"video": {"vsync_mode": option_button.get_item_id(index)}})

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings.video.has("vsync_mode"):
		var vsync_mode = settings.video.vsync_mode
		for i in range(option_button.item_count):
			if option_button.get_item_id(i) == vsync_mode:
				option_button.select(i)
				break

func _on_mouse_entered_control(control_node: Control) -> void:
	if control_node and control_node.has_meta("tooltip_text"):
		GlobalEvents.show_tooltip_requested.emit(control_node.get_meta("tooltip_text"), get_viewport().get_mouse_position())
	elif control_node and control_node.tooltip_text:
		GlobalEvents.show_tooltip_requested.emit(control_node.tooltip_text, get_viewport().get_mouse_position())

func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
