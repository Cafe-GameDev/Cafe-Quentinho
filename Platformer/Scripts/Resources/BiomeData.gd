class_name BiomeData
extends Resource

@export var biome_name: String = "Floresta"

@export_group("Spawning")
# Array de EnemyData que podem aparecer neste bioma.
@export var possible_enemies: Array[EnemyData] = []
# Array de LootItemData (recursos coletáveis) que podem ser encontrados.
@export var possible_resources: Array[LootItemData] = []

@export_group("Ambiente")
@export var background_music: AudioStream
# Poderia ser uma cena de efeito de clima (chuva, neve) a ser instanciada.
@export var weather_effect_scene: PackedScene
