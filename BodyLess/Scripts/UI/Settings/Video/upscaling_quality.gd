extends HBoxContainer

@onready var option_button: OptionButton = $UpscalingQualityOptionButton
@onready var upscaling_quality_label: Label = $UpscalingQualityLabel

func _ready() -> void:
	# Conecta aos sinais do GlobalEvents para carregar configurações
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Conecta os sinais de mouse para tooltips
	upscaling_quality_label.mouse_entered.connect(_on_mouse_entered_control.bind(upscaling_quality_label))
	upscaling_quality_label.mouse_exited.connect(_on_mouse_exited_control)
	option_button.mouse_entered.connect(_on_mouse_entered_control.bind(option_button))
	option_button.mouse_exited.connect(_on_mouse_exited_control)


func _on_upscaling_quality_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("setting_changed", {"video": {"upscaling_quality": index}})

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings.video.has("upscaling_quality"):
		option_button.select(settings.video.upscaling_quality)

func _on_mouse_entered_control(control_node: Control) -> void:
	if control_node and control_node.has_meta("tooltip_text"):
		GlobalEvents.show_tooltip_requested.emit(control_node.get_meta("tooltip_text"), get_global_mouse_position())
	elif control_node and control_node.tooltip_text:
		GlobalEvents.show_tooltip_requested.emit(control_node.tooltip_text, get_global_mouse_position())

func _on_mouse_exited_control(_control_node: Control) -> void:
	GlobalEvents.hide_tooltip_requested.emit()