extends Control

# O script da cena Tooltip.tscn.
# Ele é responsável por exibir o texto do tooltip e se posicionar.

@onready var label: Label = $Label

func _ready() -> void:
	# Esconde o tooltip por padrão. O manager o tornará visível.
	visible = false

func set_text(text_content: String) -> void:
	label.text = text_content
	# Ajusta o tamanho do tooltip para caber no texto
	size = label.get_minimum_size() + Vector2(10, 10) # Adiciona um padding