extends HBoxContainer

@onready var option_button: OptionButton = $EffectsQualityOptionButton
@onready var effects_quality_label: Label = $EffectsQualityLabel

func _ready() -> void:
	# Conecta aos sinais do GlobalEvents para carregar configurações
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Conecta os sinais de mouse para tooltips
	effects_quality_label.mouse_entered.connect(_on_mouse_entered_control.bind(effects_quality_label))
	effects_quality_label.mouse_exited.connect(_on_mouse_exited_control)
	option_button.mouse_entered.connect(_on_mouse_entered_control.bind(option_button))
	option_button.mouse_exited.connect(_on_mouse_exited_control)


func _on_effects_quality_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("setting_changed", {"video": {"effects_quality": index}})

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings.video.has("effects_quality"):
		option_button.select(settings.video.effects_quality)

func _on_mouse_entered_control(control_node: Control) -> void:
	if control_node and control_node.has_meta("tooltip_text"):
		GlobalEvents.show_tooltip_requested.emit(control_node.get_meta("tooltip_text"), get_global_mouse_position())
	elif control_node and control_node.tooltip_text:
		GlobalEvents.show_tooltip_requested.emit(control_node.tooltip_text, get_global_mouse_position())

func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
