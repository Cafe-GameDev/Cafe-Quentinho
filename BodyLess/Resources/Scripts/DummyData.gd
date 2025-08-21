extends EnemyData
class_name DummyData

func _init():
	id = "dummy"
	name_key = "ENEMY_DUMMY_NAME"
	description_key = "ENEMY_DUMMY_DESC"
	health = 9999.0 # Para ser um alvo de treino resistente
	damage = 0.0
	speed = 0.0
	behavior_type = "static"
	loot_table_id = "none"
