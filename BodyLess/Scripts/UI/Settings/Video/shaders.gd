extends HBoxContainer

@onready var option_button: OptionButton = $ShadersQualityOptionButton
@onready var shaders_quality_label: Label = $ShadersQualityLabel

func _ready() -> void:
	# Conecta aos sinais do GlobalEvents para carregar configurações
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Conecta os sinais de mouse para tooltips
	shaders_quality_label.mouse_entered.connect(_on_mouse_entered_control.bind(shaders_quality_label))
	shaders_quality_label.mouse_exited.connect(_on_mouse_exited_control)
	option_button.mouse_entered.connect(_on_mouse_entered_control.bind(option_button))
	option_button.mouse_exited.connect(_on_mouse_exited_control)


func _on_shaders_quality_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("setting_changed", {"video": {"shaders_quality": index}})

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings.video.has("shaders_quality"):
		option_button.select(settings.video.shaders_quality)

func _on_mouse_entered_control(control_node: Control) -> void:
	if control_node and control_node.has_meta("tooltip_text"):
		GlobalEvents.show_tooltip_requested.emit(control_node.get_meta("tooltip_text"), get_global_mouse_position())
	elif control_node and control_node.tooltip_text:
		GlobalEvents.show_tooltip_requested.emit(control_node.tooltip_text, get_global_mouse_position())

func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
