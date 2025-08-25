extends PanelContainer

@onready var rich_text_label: RichTextLabel = $RichTextLabel

func set_text(text_content: String) -> void:
	rich_text_label.text = text_content
	# Ajusta o tamanho do tooltip para caber no texto
	custom_minimum_size = rich_text_label.get_minimum_size()

func _ready() -> void:
	# Esconde o tooltip por padrão
	hide()
