class_name LootTableData
extends Resource

# Array de dicionários. Cada dicionário representa um item possível.
# Ex: [{"item": LootItemData, "weight": 10, "min_quantity": 1, "max_quantity": 1}]
# 'weight' é o peso da chance. Um item com peso 10 tem 10x mais chance de cair que um com peso 1.
@export var possible_drops: Array[Dictionary] = []

# Função para rolar a tabela e retornar o loot.
func roll_loot() -> Array:
	var total_weight = 0
	for drop in possible_drops:
		total_weight += drop.get("weight", 0)

	var chosen_loot = []
	if total_weight <= 0:
		return chosen_loot

	var random_roll = randi_range(1, total_weight)
	var current_weight = 0
	for drop in possible_drops:
		current_weight += drop.get("weight", 0)
		if random_roll <= current_weight:
			var item_resource = drop.get("item")
			if item_resource:
				var quantity = randi_range(drop.get("min_quantity", 1), drop.get("max_quantity", 1))
				chosen_loot.append({"item": item_resource, "quantity": quantity})
			break # Para a tabela dropar apenas um tipo de item por rolagem. Remova se quiser múltiplos.
	
	return chosen_loot
