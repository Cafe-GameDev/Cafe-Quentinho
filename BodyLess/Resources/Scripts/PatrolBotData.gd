extends EnemyData
class_name PatrolBotData

func _init():
	id = "patrol_bot"
	name_key = "ENEMY_PATROL_BOT_NAME"
	description_key = "ENEMY_PATROL_BOT_DESC"
	health = 50.0
	damage = 5.0
	speed = 75.0
	behavior_type = "patrol"
	loot_table_id = "basic_enemy_loot"
