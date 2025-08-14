# Multiplayer Local (LAN)

Para configurar um multiplayer local (LAN) na Godot, você utilizará a API de alto nível de rede, que simplifica bastante o processo. O foco principal é o `MultiplayerAPI` e o `ENetMultiplayerPeer` para a comunicação, e os RPCs (Remote Procedure Calls) para a troca de mensagens entre os jogadores.

### 1. Conceitos Fundamentais

*   **`MultiplayerAPI`**: É a interface de alto nível para gerenciar a rede. Você a acessa através de `get_tree().multiplayer`.
*   **`ENetMultiplayerPeer`**: É a implementação de rede subjacente que a Godot usa para comunicação via UDP, ideal para jogos. Ele lida com a conexão e o envio/recebimento de pacotes.
*   **RPCs (Remote Procedure Calls)**: Permitem que você chame funções em nós remotos na rede. Você marca uma função com `@rpc` no GDScript para que ela possa ser chamada por outros pares.
*   **Autoridade de Rede (`authority`)**: Cada nó na árvore de cena pode ter uma "autoridade" de rede. Geralmente, o servidor é a autoridade para a maioria dos nós do jogo, e os clientes são a autoridade para seus próprios jogadores.

### 2. Configurando o Host (Servidor)

O host será o jogador que inicia a partida e os outros jogadores se conectarão a ele.

```gdscript
# script_do_host.gd
extends Node

@export var port = 9999

func _ready():
    # Cria um peer de rede ENet
    var peer = ENetMultiplayerPeer.new()
    # Escuta na porta especificada
    var error = peer.create_server(port)
    if error != OK:
        print("Erro ao criar servidor: ", error)
        return

    # Define o peer para a API de multiplayer da árvore de cena
    get_tree().multiplayer.multiplayer_peer = peer
    print("Servidor iniciado na porta ", port)

    # Conecta-se a sinais importantes
    get_tree().multiplayer.peer_connected.connect(_on_peer_connected)
    get_tree().multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id):
    print("Cliente conectado: ", id)
    # Aqui você pode instanciar o jogador para o novo cliente
    # e sincronizar o estado do jogo.

func _on_peer_disconnected(id):
    print("Cliente desconectado: ", id)
    # Aqui você pode remover o jogador correspondente.
```

### 3. Configurando o Cliente

Os clientes se conectarão ao host usando o endereço IP do host e a porta.

```gdscript
# script_do_cliente.gd
extends Node

@export var host_ip = "127.0.0.1" # Use o IP local do host na LAN
@export var port = 9999

func _ready():
    # Cria um peer de rede ENet
    var peer = ENetMultiplayerPeer.new()
    # Conecta-se ao servidor
    var error = peer.create_client(host_ip, port)
    if error != OK:
        print("Erro ao conectar ao servidor: ", error)
        return

    # Define o peer para a API de multiplayer da árvore de cena
    get_tree().multiplayer.multiplayer_peer = peer
    print("Conectando ao servidor ", host_ip, ":", port)

    # Conecta-se a sinais importantes
    get_tree().multiplayer.connected_to_server.connect(_on_connected_to_server)
    get_tree().multiplayer.connection_failed.connect(_on_connection_failed)
    get_tree().multiplayer.server_disconnected.connect(_on_server_disconnected)

func _on_connected_to_server():
    print("Conectado ao servidor!")
    # O cliente agora pode enviar RPCs e receber atualizações.

func _on_connection_failed():
    print("Falha na conexão com o servidor.")

func _on_server_disconnected():
    print("Servidor desconectado.")
```

### 4. Comunicação com RPCs

Para que os nós se comuniquem pela rede, você usa RPCs.

```gdscript
# Exemplo de script de jogador (Player.gd)
extends CharacterBody2D

# Marca a função para ser chamada remotamente
@rpc("any_peer", "call_local") # Pode ser chamada por qualquer peer, e também executada localmente
func move_player(new_position: Vector2):
    position = new_position

func _physics_process(delta):
    if is_multiplayer_authority(): # Verifica se este é o jogador local (autoridade)
        # Lógica de input e movimento do jogador local
        var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
        velocity = input_direction * 200

        move_and_slide()

        # Envia a nova posição para todos os outros peers via RPC
        # O "rpc()" chama a função "move_player" em todos os outros peers
        # que possuem uma instância deste nó com a mesma autoridade.
        rpc("move_player", position)
```

**Explicação do `@rpc`:**

*   `@rpc("any_peer", "call_local")`:
    *   `any_peer`: Significa que qualquer peer (servidor ou outro cliente) pode chamar esta função.
    *   `call_local`: Significa que a função também será executada na instância local do nó, além de ser enviada pela rede. Isso é útil para o jogador local ver seu próprio movimento imediatamente.

### 5. Sincronização de Estado com `MultiplayerSynchronizer`

Para sincronizar propriedades de nós (como posição, rotação, variáveis) automaticamente, você pode usar o nó `MultiplayerSynchronizer`.

1.  Adicione um nó `MultiplayerSynchronizer` como filho do nó que você deseja sincronizar (ex: seu nó `Player`).
2.  No Inspector do `MultiplayerSynchronizer`, em "Replicated Properties", adicione as propriedades que você quer sincronizar (ex: `position`, `rotation`, `health`).
3.  Defina a "Multiplayer Authority" do nó pai (ex: `Player`) para `Multiplayer.RPC_MODE_AUTHORITY` se o servidor for a autoridade, ou `Multiplayer.RPC_MODE_OWNER` se o cliente que possui o nó for a autoridade.

### 6. Considerações para LAN

*   **Endereço IP**: Para jogos em LAN, os clientes precisarão do endereço IP local do host (ex: `192.168.1.100`). Você pode precisar de uma forma de descobrir esse IP ou permitir que o usuário o insira.
*   **Firewall**: Certifique-se de que o firewall do sistema operacional do host não esteja bloqueando a porta que você está usando (9999 no exemplo).
*   **Descoberta de Servidor**: Para uma experiência mais amigável em LAN, você pode implementar um sistema de descoberta de servidor usando broadcast UDP, onde o host anuncia sua presença e os clientes escutam por esses anúncios. Isso evita a necessidade de digitar IPs manualmente.

Ao seguir essas diretrizes, você terá uma base sólida para desenvolver jogos multiplayer em LAN com a Godot. Lembre-se de que a arquitetura de rede (servidor autoritativo vs. peer-to-peer) é uma decisão importante que afetará a complexidade e a segurança do seu jogo. Para a maioria dos jogos, um servidor autoritativo (mesmo que um dos jogadores seja o servidor) é a abordagem mais robusta.
