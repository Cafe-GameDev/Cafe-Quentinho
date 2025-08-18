extends HBoxContainer

@onready var option_button: OptionButton = $ShadersQualityOptionButton

func _ready() -> void:
	GlobalEvents.shaders_quality_changed.connect(_on_shaders_quality_changed)
	# TODO: Popular com os níveis de qualidade. Ex: "Baixo", "Médio", "Alto"

func _on_shaders_quality_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("shaders_quality_changed", index)

func _on_shaders_quality_changed(quality_index: int) -> void:
	if option_button.selected != quality_index:
		option_button.select(quality_index)
