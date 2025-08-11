extends Node

# Este Singleton atua como um "Event Bus" ou "Quadro de Avisos" global.
# Outros scripts podem emitir sinais aqui, e qualquer outro script pode se conectar a eles
# sem que um precise conhecer o outro diretamente.

signal scene_change_requested(scene_path: String)
