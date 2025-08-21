extends HBoxContainer

@onready var slider: HSlider = $GammaCorrectionSlider
@onready var gamma_correction_label: Label = $GammaCorrectionLabel

func _ready() -> void:
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Conecta os sinais de mouse para tooltips
	gamma_correction_label.mouse_entered.connect(_on_mouse_entered_control.bind(gamma_correction_label))
	gamma_correction_label.mouse_exited.connect(_on_mouse_exited_control)
	slider.mouse_entered.connect(_on_mouse_entered_control.bind(slider))
	slider.mouse_exited.connect(_on_mouse_exited_control)

func _on_gamma_correction_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalEvents.setting_changed.emit({"video": {"gamma_correction": slider.value}})

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings["video"].has("gamma_correction"):
		slider.value = settings["video"]["gamma_correction"]

func _on_mouse_entered_control(control_node: Control) -> void:
	if control_node and control_node.has_meta("tooltip_text"):
		GlobalEvents.show_tooltip_requested.emit(control_node.get_meta("tooltip_text"), get_global_mouse_position())
	elif control_node and control_node.tooltip_text:
		GlobalEvents.show_tooltip_requested.emit(control_node.tooltip_text, get_global_mouse_position())

func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()