extends Resource
class_name ItemData

@export var id: String = ""
@export var name_key: String = ""
@export var description_key: String = ""
@export var icon_path: String = ""
@export var item_type: String = "generic" # Ex: "consumable", "weapon", "quest_item"
@export var stackable: bool = false
@export var max_stack_size: int = 1
