class_name CharacterData
extends Resource

@export var character_name: String = "Herói"
@export var scene: PackedScene # A cena .tscn do personagem
@export var portrait: Texture2D # Imagem para a tela de seleção

@export_group("Estatísticas de Jogo")
@export var max_health: int = 100
@export var base_speed: float = 300.0
@export var jump_velocity: float = -400.0
