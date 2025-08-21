extends WeaponData
class_name BowData

@export var projectile_speed: float = 500.0

func _init():
	id = "bow"
	name_key = "WEAPON_BOW_NAME"
	description_key = "WEAPON_BOW_DESC"
	icon_path = "res://Assets/UI/Icons/bow_icon.png" # Placeholder
	damage = 15.0
	range = 500.0 # Distância do projétil
	attack_type = "ranged"
	reload_time = 1.0
	ammo_capacity = 1 # Uma flecha por vez
	ammo_type = "arrow" # Exemplo de tipo de munição
