class_name LootItemData
extends Resource

enum ItemType { CONSUMABLE, WEAPON, ARMOR, KEY }

@export var item_name: String = "Poção"
@export var item_type: ItemType = ItemType.CONSUMABLE
@export_multiline var description: String
@export var icon: Texture2D
@export var stackable: bool = true
