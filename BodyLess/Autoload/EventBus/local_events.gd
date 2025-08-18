extends Node

# LocalEvents: Um barramento de eventos para comunicação local de gameplay.
# Este singleton deve ser usado para eventos que afetam apenas partes específicas
# do jogo (ex: player, inimigos, itens), sem a necessidade de serem globais.
# Ele ajuda a manter o desacoplamento dentro de domínios de gameplay.

# Exemplo de sinal:
# signal player_health_changed(new_health: int)
# signal enemy_died(enemy_id: String)
# signal item_picked_up(item_id: String, quantity: int)
