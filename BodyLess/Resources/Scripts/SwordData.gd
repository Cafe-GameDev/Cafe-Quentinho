extends WeaponData
class_name SwordData

func _init():
	id = "sword"
	name_key = "WEAPON_SWORD_NAME"
	description_key = "WEAPON_SWORD_DESC"
	icon_path = "res://Assets/UI/Icons/sword_icon.png" # Placeholder
	damage = 20.0
	range = 1.0
	attack_type = "melee"
	reload_time = 0.0
	ammo_capacity = 0
	ammo_type = "none"
