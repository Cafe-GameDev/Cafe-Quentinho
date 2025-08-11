class_name EnchantmentData
extends Resource

@export var enchantment_name: String = "Encantamento de Fogo"
@export_multiline var description: String

@export_group("Modificadores")
# Um dicionário para modificadores de estatísticas genéricas.
# Ex: {"damage": 5, "defense": 2}
@export var stat_modifiers: Dictionary = {}

# Efeito de status a ser aplicado (ex: veneno, queimadura).
@export var status_effect: StatusEffectData
@export var status_application_chance: float = 0.0 # Chance de 0.0 a 1.0
