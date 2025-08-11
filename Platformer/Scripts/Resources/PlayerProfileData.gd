class_name PlayerProfileData
extends Resource

@export var player_name: String = "Player"
@export var total_playtime_seconds: float = 0.0

@export_group("Moedas")
@export var shared_gold: int = 0 # Ouro compartilhado entre todos os saves
@export var premium_currency: int = 0

@export_group("Progresso Global")
# Um dicionário para rastrear conquistas. Ex: {"first_quest_completed": true}
@export var achievements: Dictionary = {}
# Um array de strings para modos de jogo desbloqueados. Ex: ["new_game_plus"]
@export var unlocked_game_modes: Array[String] = []
