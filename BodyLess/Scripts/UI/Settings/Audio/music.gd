extends HBoxContainer

@onready var slider: HSlider = $MusicSlider
@onready var music_label: Label = $MusicLabel
@onready var value_label: Label = $MusicValueLabel

func _ready() -> void:
	# Conecta aos sinais do GlobalEvents para carregar configurações
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Conecta os sinais de mouse para tooltips
	music_label.mouse_entered.connect(_on_mouse_entered_control.bind(music_label))
	music_label.mouse_exited.connect(_on_mouse_exited_control)
	slider.mouse_entered.connect(_on_mouse_entered_control.bind(slider))
	slider.mouse_exited.connect(_on_mouse_exited_control)

	# Conecta o slider para atualizar o valor em tempo real e emitir o sinal de mudança
	slider.value_changed.connect(_on_slider_value_changed)
	_update_value_label(slider.value)

func _on_slider_value_changed(value: float) -> void:
	_update_value_label(value)
	GlobalEvents.emit_signal("setting_changed", {"audio": {"music_volume": value}})

func _on_music_slider_drag_ended(value_changed: bool) -> void:
	# O sinal de drag_ended não é mais necessário, pois value_changed já lida com isso.
	pass

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("audio") and settings.audio.has("music_volume"):
		slider.value = settings.audio.music_volume
		_update_value_label(slider.value)

func _update_value_label(value: float) -> void:
	value_label.text = str(int(value * 100)) + "%"

func _update_ui(audio_settings: Dictionary) -> void:
	# Função pública para ser chamada pelo OptionsMenu para atualizar a UI
	if audio_settings.has("music_volume"):
		slider.value = audio_settings.music_volume
		_update_value_label(slider.value)

func _on_mouse_entered_control(control_node: Control) -> void:
	var tooltip_text = ""
	if control_node and control_node.has_meta("tooltip_text"):
		tooltip_text = control_node.get_meta("tooltip_text")
	elif control_node and control_node.tooltip_text:
		tooltip_text = control_node.tooltip_text

	if not tooltip_text.is_empty():
		GlobalEvents.show_tooltip_requested.emit({"text": tooltip_text, "position": get_global_mouse_position()})

func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
