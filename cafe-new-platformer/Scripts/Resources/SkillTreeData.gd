class_name SkillTreeData
extends Resource

@export var skill_name: String = "Nova Habilidade"
@export_multiline var description: String
@export var icon: Texture2D

@export_group("Regras da Árvore")
@export var skill_point_cost: int = 1
# Array de outros SkillTreeData que são pré-requisitos para este.
@export var prerequisites: Array[SkillTreeData] = []
# A habilidade (AbilityData) que este nó desbloqueia, se houver.
@export var unlocked_ability: AbilityData
