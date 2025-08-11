class_name ShopData
extends Resource

# Dicionário onde a chave é o ItemData e o valor é o preço.
# Ex: {load("res://Items/potion.tres"): 50}
@export var items_for_sale: Dictionary = {}
