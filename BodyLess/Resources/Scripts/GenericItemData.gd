extends ItemData
class_name GenericItemData

func _init():
	id = "generic_item"
	name_key = "ITEM_GENERIC_NAME"
	description_key = "ITEM_GENERIC_DESC"
	icon_path = "res://Assets/UI/Icons/generic_item_icon.png" # Placeholder
	item_type = "generic"
	stackable = true
	max_stack_size = 99
