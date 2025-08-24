extends HBoxContainer

@onready var slider: HSlider = $BrightnessSlider
@onready var brightness_label: Label = $BrightnessLabel
@onready var value_label: Label = $BrightnessValueLabel

func _ready() -> void:
	# Conecta aos sinais do GlobalEvents para carregar configurações
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Conecta os sinais de mouse para tooltips
	brightness_label.mouse_entered.connect(_on_mouse_entered_control.bind(brightness_label))
	brightness_label.mouse_exited.connect(_on_mouse_exited_control)
	slider.mouse_entered.connect(_on_mouse_entered_control.bind(slider))
	slider.mouse_exited.connect(_on_mouse_exited_control)

	# Conecta o slider para atualizar o valor em tempo real e emitir o sinal de mudança
	slider.value_changed.connect(_on_slider_value_changed)
	_update_value_label(slider.value)

func _on_slider_value_changed(value: float) -> void:
	_update_value_label(value)
	GlobalEvents.emit_signal("setting_changed", {"video": {"brightness": value}})

func _on_brightness_slider_drag_ended(value_changed: bool) -> void:
	# O sinal de drag_ended não é mais necessário, pois value_changed já lida com isso.
	pass

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings.video.has("brightness"):
		slider.value = settings.video.brightness
		_update_value_label(slider.value)

func _update_value_label(value: float) -> void:
	value_label.text = "%.2f" % value

func _update_ui(video_settings: Dictionary) -> void:
	# Função pública para ser chamada pelo OptionsMenu para atualizar a UI
	if video_settings.has("brightness"):
		slider.value = video_settings.brightness
		_update_value_label(slider.value)

func _on_mouse_entered_control(control_node: Control) -> void:
	var tooltip_text = ""
	if control_node and control_node.has_meta("tooltip_text"):
		tooltip_text = control_node.get_meta("tooltip_text")
	elif control_node and control_node.tooltip_text:
		tooltip_text = tr(control_node.tooltip_text)

	if not tooltip_text.is_empty():
		GlobalEvents.show_tooltip_requested.emit({"text": tooltip_text, "position": get_global_mouse_position()})

func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
