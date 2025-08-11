class_name QuestData
extends Resource

enum QuestState { NOT_STARTED, IN_PROGRESS, COMPLETED }

@export var quest_title: String = "Coletar Ervas"
@export_multiline var description_start: String
@export_multiline var description_in_progress: String
@export_multiline var description_completed: String

@export_group("Objetivos")
@export var required_item: LootItemData
@export var required_amount: int = 5

@export_group("Recompensas")
@export var reward_xp: int = 100
@export var reward_gold: int = 50
