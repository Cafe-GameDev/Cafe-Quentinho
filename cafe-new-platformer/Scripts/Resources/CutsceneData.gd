class_name CutsceneData
extends Resource

# Um array de eventos que compõem a cutscene.
# Cada evento é um dicionário que define a ação.
# Ex: {"type": "dialogue", "data": DialogueData},
#     {"type": "move_camera", "target_node": NodePath, "duration": 2.0},
#     {"type": "play_animation", "target_node": NodePath, "animation_name": "victory"}
@export var event_sequence: Array[Dictionary] = []
