class_name StatusEffectData
extends Resource

enum EffectType { BUFF, DEBUFF }
enum StatModifier { SPEED, DAMAGE, DEFENSE }

@export var effect_name: String = "Veneno"
@export var effect_type: EffectType = EffectType.DEBUFF
@export var duration: float = 5.0 # Segundos

@export_group("Efeitos Contínuos")
@export var damage_per_second: int = 2

@export_group("Modificadores de Stats")
@export var stat_to_modify: StatModifier
@export var modifier_value: float = 0.8 # Ex: 0.8 para 20% de redução
