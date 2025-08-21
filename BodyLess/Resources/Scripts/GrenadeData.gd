extends WeaponData
class_name GrenadeData

@export var explosion_radius: float = 5.0
@export var fuse_time: float = 3.0

func _init():
	id = "grenade"
	name_key = "WEAPON_GRENADE_NAME"
	description_key = "WEAPON_GRENADE_DESC"
	icon_path = "res://Assets/UI/Icons/grenade_icon.png" # Placeholder
	damage = 50.0
	range = 10.0 # Distância de arremesso
	attack_type = "explosive"
	reload_time = 2.0
	ammo_capacity = 1
	ammo_type = "grenade"
