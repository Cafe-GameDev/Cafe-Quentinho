extends ItemData
class_name WeaponData

@export var damage: float = 10.0
@export var range: float = 1.0 # Para corpo a corpo, ou distância para projéteis
@export var attack_type: String = "melee" # "melee", "ranged", "explosive"
@export var reload_time: float = 1.5 # Tempo em segundos
@export var ammo_capacity: int = 0 # 0 para armas corpo a corpo
@export var ammo_type: String = "none" # Ex: "bullet", "arrow", "grenade"

func _init():
	item_type = "weapon"
	stackable = false
	max_stack_size = 1
