extends HBoxContainer

@onready var option_button: OptionButton = $WindowModeOptionButton
@onready var window_mode_label: Label = $WindowModeLabel

func _ready() -> void:
	# Popula com os modos de janela
	option_button.add_item("Janela", DisplayServer.WINDOW_MODE_WINDOWED)
	option_button.add_item("Tela Cheia", DisplayServer.WINDOW_MODE_FULLSCREEN)
	option_button.add_item("Janela sem Bordas", DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

	# Conecta aos sinais do GlobalEvents para carregar configurações
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Conecta os sinais de mouse para tooltips
	window_mode_label.mouse_entered.connect(_on_mouse_entered_control.bind(window_mode_label))
	window_mode_label.mouse_exited.connect(_on_mouse_exited_control)
	option_button.mouse_entered.connect(_on_mouse_entered_control.bind(option_button))
	option_button.mouse_exited.connect(_on_mouse_exited_control)

func _on_window_mode_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("setting_changed", {"video": {"window_mode": option_button.get_item_id(index)}})

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings.video.has("window_mode"):
		var window_mode = settings.video.window_mode
		for i in range(option_button.item_count):
			if option_button.get_item_id(i) == window_mode:
				option_button.select(i)
				break

func _on_mouse_entered_control(control_node: Control) -> void:
	if control_node.has_meta("tooltip_text"):
		GlobalEvents.show_tooltip_requested.emit(control_node.get_meta("tooltip_text"), get_global_mouse_position())
	elif control_node.tooltip_text:
		GlobalEvents.show_tooltip_requested.emit(control_node.tooltip_text, get_global_mouse_position())

func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
