extends WeaponData
class_name MachineGunData

@export var fire_rate: float = 0.1 # Tempo entre tiros

func _init():
	id = "machine_gun"
	name_key = "WEAPON_MACHINE_GUN_NAME"
	description_key = "WEAPON_MACHINE_GUN_DESC"
	icon_path = "res://Assets/UI/Icons/machine_gun_icon.png" # Placeholder
	damage = 10.0
	range = 600.0
	attack_type = "ranged"
	reload_time = 3.0
	ammo_capacity = 50
	ammo_type = "bullet"
