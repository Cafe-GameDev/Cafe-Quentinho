class_name EnemyData
extends Resource

@export var enemy_name: String = "Goblin"
@export var scene: PackedScene # A cena .tscn do inimigo

@export_group("Estatísticas de Combate")
@export var max_health: int = 50
@export var damage: int = 5
@export var move_speed: float = 150.0

@export_group("Comportamento")
@export var detection_radius: float = 300.0
@export var attack_radius: float = 50.0
