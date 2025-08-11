class_name FactionData
extends Resource

enum Stance { HOSTILE, NEUTRAL, FRIENDLY }

@export var faction_name: String = "Default"
# Dicionário para armazenar a relação com outras facções.
# A chave é o Resource FactionData da outra facção.
# O valor é a Stance (HOSTILE, NEUTRAL, FRIENDLY).
# Ex: {load("res://Resources/Factions/player_faction.tres"): Stance.FRIENDLY}
@export var stances: Dictionary = {}
