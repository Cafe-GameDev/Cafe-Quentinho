extends Resource
class_name EnemyData

@export var id: String = ""
@export var name_key: String = ""
@export var description_key: String = ""
@export var health: float = 100.0
@export var damage: float = 10.0
@export var speed: float = 100.0
@export var behavior_type: String = "static" # "static", "patrol", "fsm"
@export var loot_table_id: String = "" # ID da tabela de loot para este inimigo
