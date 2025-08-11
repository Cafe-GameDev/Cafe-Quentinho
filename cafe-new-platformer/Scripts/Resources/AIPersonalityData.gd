class_name AIPersonalityData
extends Resource

enum Behavior {
    PATROL,  # Patrulha uma área definida
    GUARD,   # Fica parado em um ponto, mas persegue se avistar o jogador
    AGGRESSIVE, # Persegue o jogador ativamente
    COWARD    # Foge do jogador quando com vida baixa
}

@export var behavior_type: Behavior = Behavior.PATROL

@export_group("Parâmetros de Comportamento")
@export var patrol_path_node: NodePath # Para o comportamento de patrulha
@export var coward_health_threshold: float = 0.2 # Percentual de vida para começar a fugir
