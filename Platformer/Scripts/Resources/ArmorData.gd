class_name ArmorData
extends LootItemData # Herda de LootItemData

enum ArmorSlot { HEAD, CHEST, LEGS, FEET }

@export var armor_slot: ArmorSlot

@export_group("Atributos de Defesa")
@export var defense_value: int = 5
# Dicionário para resistências. Ex: {"fire_resistance": 0.2, "ice_resistance": -0.1}
# Onde 0.2 é 20% de resistência e -0.1 é 10% de fraqueza.
@export var resistance_modifiers: Dictionary = {}
