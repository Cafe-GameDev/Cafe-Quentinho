class_name CraftingRecipeData
extends Resource

# Dicionário de ingredientes. Chave: LootItemData, Valor: quantidade.
# Ex: {load("res://Resources/Items/wood.tres"): 5, load("res://Resources/Items/stone.tres"): 2}
@export var ingredients: Dictionary = {}

# O item resultante da receita.
@export var output_item: LootItemData
@export var output_quantity: int = 1
