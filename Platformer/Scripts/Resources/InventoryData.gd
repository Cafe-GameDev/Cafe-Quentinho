class_name InventoryData
extends Resource

# Um array que conterá outros Resources (ex: ItemData)
@export var items: Array[Resource] = []
@export var capacity: int = 20 # Número máximo de slots

func add_item(item_data: Resource) -> bool:
	if items.size() < capacity:
		items.append(item_data)
		return true
	return false

func remove_item(item_data: Resource):
	items.erase(item_data)
