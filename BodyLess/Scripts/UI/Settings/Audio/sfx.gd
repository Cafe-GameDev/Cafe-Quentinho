extends HBoxContainer

@onready var slider: HSlider = $SfxSlider
@onready var sfx_label: Label = $SfxLabel

func _ready() -> void:
	# Conecta aos sinais do GlobalEvents para carregar configurações
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Conecta os sinais de mouse para tooltips
	sfx_label.mouse_entered.connect(_on_mouse_entered_control.bind(sfx_label))
	sfx_label.mouse_exited.connect(_on_mouse_exited_control)
	slider.mouse_entered.connect(_on_mouse_entered_control.bind(slider))
	slider.mouse_exited.connect(_on_mouse_exited_control)


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalEvents.emit_signal("setting_changed", {"audio": {"sfx_volume": slider.value}})

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("audio") and settings.audio.has("sfx_volume"):
		slider.value = settings.audio.sfx_volume

func _on_mouse_entered_control(control_node: Control) -> void:
	if control_node and control_node.has_meta("tooltip_text"):
		GlobalEvents.show_tooltip_requested.emit(control_node.get_meta("tooltip_text"), get_global_mouse_position())
	elif control_node and control_node.tooltip_text:
		GlobalEvents.show_tooltip_requested.emit(control_node.tooltip_text, get_global_mouse_position())

func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
