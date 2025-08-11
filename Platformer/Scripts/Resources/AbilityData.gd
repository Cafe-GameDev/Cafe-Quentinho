class_name AbilityData
extends Resource

@export var ability_name: String = "Bola de Fogo"
@export var damage: int = 25
@export var mana_cost: int = 10
@export var cooldown: float = 2.0 # Segundos
@export var animation_name: StringName
@export var vfx_scene: PackedScene # Efeito visual a ser instanciado
