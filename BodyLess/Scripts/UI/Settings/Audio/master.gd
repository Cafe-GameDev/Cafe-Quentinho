extends HBoxContainer

@onready var slider: HSlider = $MasterSlider

func _ready() -> void:
	# Conecta ao sinal do SettingsManager para inicializar o valor do slider.
	GlobalEvents.master_volume_changed.connect(_on_master_volume_changed)

func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalEvents.emit_signal("master_volume_changed", slider.value)

func _on_master_volume_changed(linear_volume: float) -> void:
	# Atualiza a UI se o valor for alterado externamente (ex: ao carregar o jogo).
	if not is_equal_approx(slider.value, linear_volume):
		slider.value = linear_volume
