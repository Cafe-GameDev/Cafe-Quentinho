extends HBoxContainer

@onready var option_button: OptionButton = $EffectsQualityOptionButton

func _ready() -> void:
	GlobalEvents.effects_quality_changed.connect(_on_effects_quality_changed)
	# TODO: Popular o OptionButton com os níveis de qualidade.

func _on_effects_quality_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("effects_quality_changed", index)

func _on_effects_quality_changed(quality_index: int) -> void:
	if option_button.selected != quality_index:
		option_button.select(quality_index)
