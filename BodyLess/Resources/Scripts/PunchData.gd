extends WeaponData
class_name PunchData

func _init():
	id = "punch"
	name_key = "WEAPON_PUNCH_NAME"
	description_key = "WEAPON_PUNCH_DESC"
	icon_path = "res://Assets/UI/Icons/punch_icon.png" # Placeholder
	damage = 5.0
	range = 0.5
	attack_type = "melee"
	reload_time = 0.0 # Não recarrega
	ammo_capacity = 0
	ammo_type = "none"
