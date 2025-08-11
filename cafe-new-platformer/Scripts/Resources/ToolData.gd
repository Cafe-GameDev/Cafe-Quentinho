class_name ToolData
extends LootItemData # Herda de LootItemData para reusar propriedades base.

enum ToolType { PICKAXE, AXE, FISHING_ROD, SHOVEL }

@export var tool_type: ToolType
@export var durability: int = 100
@export var efficiency: float = 1.0 # Ex: 1.0 para velocidade normal de coleta.
