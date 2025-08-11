class_name InteractableData
extends Resource

@export var interaction_prompt: String = "Interagir" # Ex: "Abrir Baú", "Ler Placa"

@export_group("Eventos")
# Sinal a ser emitido pelo objeto quando a interação for bem-sucedida.
# Ex: "lever_pulled", "door_opened"
@export var success_signal: StringName 
# Animação a ser tocada no objeto durante a interação.
@export var animation_name: StringName
