extends EnemyData
class_name HunterData

func _init():
	id = "hunter"
	name_key = "ENEMY_HUNTER_NAME"
	description_key = "ENEMY_HUNTER_DESC"
	health = 80.0
	damage = 15.0
	speed = 150.0
	behavior_type = "fsm"
	loot_table_id = "advanced_enemy_loot"
