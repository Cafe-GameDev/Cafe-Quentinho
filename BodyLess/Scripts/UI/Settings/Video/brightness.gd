extends HBoxContainer

@onready var slider: HSlider = $BrightnessSlider
@onready var brightness_label: Label = $BrightnessLabel

func _ready() -> void:
	# Conecta aos sinais do GlobalEvents para carregar configurações
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Conecta os sinais de mouse para tooltips
	brightness_label.mouse_entered.connect(_on_mouse_entered_control.bind(brightness_label))
	brightness_label.mouse_exited.connect(_on_mouse_exited_control)
	slider.mouse_entered.connect(_on_mouse_entered_control.bind(slider))
	slider.mouse_exited.connect(_on_mouse_exited_control)


func _on_brightness_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalEvents.emit_signal("setting_changed", {"video": {"brightness": slider.value}})

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings.video.has("brightness"):
		slider.value = settings.video.brightness

func _on_mouse_entered_control(control_node: Control) -> void:
	if control_node and control_node.has_meta("tooltip_text"):
		GlobalEvents.show_tooltip_requested.emit(control_node.get_meta("tooltip_text"), get_global_mouse_position())
	elif control_node and control_node.tooltip_text:
		GlobalEvents.show_tooltip_requested.emit(control_node.tooltip_text, get_global_mouse_position())

func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
