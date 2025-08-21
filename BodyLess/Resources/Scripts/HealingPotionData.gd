extends ItemData
class_name HealingPotionData

@export var heal_amount: float = 25.0

func _init():
	id = "healing_potion"
	name_key = "ITEM_HEALING_POTION_NAME"
	description_key = "ITEM_HEALING_POTION_DESC"
	icon_path = "res://Assets/UI/Icons/healing_potion_icon.png" # Placeholder
	item_type = "consumable"
	stackable = true
	max_stack_size = 5
