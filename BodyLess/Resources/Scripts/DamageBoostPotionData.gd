extends ItemData
class_name DamageBoostPotionData

@export var boost_value: float = 0.25 # 25% de aumento de dano
@export var duration: float = 10.0 # Duração em segundos

func _init():
	id = "damage_boost_potion"
	name_key = "ITEM_DAMAGE_BOOST_NAME"
	description_key = "ITEM_DAMAGE_BOOST_DESC"
	icon_path = "res://Assets/UI/Icons/damage_boost_icon.png" # Placeholder
	item_type = "consumable"
	stackable = true
	max_stack_size = 3
