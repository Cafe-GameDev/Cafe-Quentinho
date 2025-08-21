extends WeaponData
class_name PistolData

@export var projectile_speed: float = 700.0

func _init():
	id = "pistol"
	name_key = "WEAPON_PISTOL_NAME"
	description_key = "WEAPON_PISTOL_DESC"
	icon_path = "res://Assets/UI/Icons/pistol_icon.png" # Placeholder
	damage = 25.0
	range = 700.0
	attack_type = "ranged"
	reload_time = 1.2
	ammo_capacity = 12
	ammo_type = "bullet"
