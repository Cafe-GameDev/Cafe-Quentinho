# Sinais (Signals)

Sinais na Godot Engine são um conceito fundamental para a comunicação entre nós de forma desacoplada e eficiente. Eles permitem que um nó "emita" um evento, e outros nós "escutem" e reajam a esse evento, sem que os nós precisem ter conhecimento direto uns dos outros. Isso promove uma arquitetura de código mais limpa e modular.

### O que são Sinais?

Sinais são uma forma de comunicação baseada em eventos. Em vez de um nó chamar diretamente uma função em outro nó (o que criaria um acoplamento forte), ele emite um sinal. Qualquer outro nó interessado pode se conectar a esse sinal e executar uma função (chamada de "slot" ou "callback") quando o sinal é emitido.

**Vantagens:**
*   **Desacoplamento:** Nós não precisam saber da existência uns dos outros. Um botão não precisa saber quem vai reagir ao seu clique; ele apenas emite o sinal `pressed`.
*   **Reusabilidade:** Componentes podem ser facilmente reutilizados em diferentes contextos, pois sua lógica não está amarrada a nós específicos.
*   **Flexibilidade:** Múltiplos nós podem se conectar ao mesmo sinal, e um nó pode se conectar a múltiplos sinais.

### 1. Conectando Sinais

Existem duas maneiras principais de conectar sinais: via editor Godot ou via código.

#### 1.1. Conectando via Editor Godot

Esta é a forma mais visual e recomendada para sinais que são conectados uma vez e permanecem assim.

1.  Selecione o nó que emite o sinal (ex: um `Button`).
2.  No painel "Node" (geralmente ao lado do Inspector), vá para a aba "Signals".
3.  Você verá uma lista de sinais que o nó pode emitir (ex: `pressed` para um `Button`).
4.  Dê um duplo clique no sinal desejado ou selecione-o e clique em "Connect...".
5.  Uma janela "Connect a Signal" aparecerá. Selecione o nó que receberá o sinal (o nó onde a função de callback será executada).
6.  A Godot sugerirá um nome de função padrão (ex: `_on_Button_pressed`). Você pode alterá-lo.
7.  Clique em "Connect". A Godot criará automaticamente a função no script do nó receptor.

#### 1.2. Conectando via Código (GDScript)

Conectar sinais via código é essencial para conexões dinâmicas, onde os nós são instanciados em tempo de execução ou as conexões precisam ser alteradas.

A função principal para conectar sinais é `connect()`.

```gdscript
# Exemplo: Conectando um sinal 'pressed' de um botão
func _ready():
    var button = get_node("Button") # Obtém uma referência ao nó Button
    button.connect("pressed", _on_button_pressed) # Conecta o sinal "pressed" à função "_on_button_pressed"

func _on_button_pressed():
    print("Botão pressionado!")
```

**Parâmetros de `connect()`:**
*   `signal_name` (String): O nome do sinal a ser conectado.
*   `callable` (Callable): A função que será chamada quando o sinal for emitido. Em GDScript, você pode usar `_on_button_pressed` ou `Callable(self, "_on_button_pressed")`.
*   `flags` (int, opcional): Flags para controlar o comportamento da conexão (ex: `CONNECT_ONE_SHOT` para desconectar após a primeira emissão).

**Desconectando Sinais:**
Para remover uma conexão, use `disconnect()`:

```gdscript
button.disconnect("pressed", _on_button_pressed)
```

### 2. Criando Sinais Personalizados

Você pode definir seus próprios sinais em qualquer script para criar eventos específicos do seu jogo.

1.  **Declarar o Sinal:** Use a palavra-chave `signal` no topo do seu script. Você pode definir parâmetros para o sinal.

    ```gdscript
    # Scripts/Player.gd
    extends CharacterBody2D

    signal health_changed(new_health: int)
    signal died()

    var current_health: int = 100:
        set(value):
            current_health = value
            health_changed.emit(current_health) # Emite o sinal quando a saúde muda
            if current_health <= 0:
                died.emit() # Emite o sinal quando o jogador morre

    func take_damage(amount: int):
        current_health -= amount
    ```

2.  **Emitir o Sinal:** Use o método `emit()` no sinal declarado, passando os valores dos parâmetros, se houver.

    ```gdscript
    # No exemplo acima, os sinais são emitidos dentro do setter da propriedade 'current_health'.
    # Você também pode emitir sinais em qualquer outra função:
    func _on_enemy_hit():
        take_damage(10)
    ```

3.  **Conectar e Reagir ao Sinal Personalizado:** Outros nós podem se conectar a esses sinais personalizados da mesma forma que se conectam a sinais embutidos.

    ```gdscript
    # Scripts/GameUI.gd
    extends Control

    func _ready():
        var player = get_node("/root/Game/Player") # Assumindo que o Player está em /root/Game/Player
        player.health_changed.connect(_on_player_health_changed)
        player.died.connect(_on_player_died)

    func _on_player_health_changed(new_health: int):
        print("Saúde do jogador: ", new_health)
        # Atualizar barra de vida na UI

    func _on_player_died():
        print("Game Over!")
        # Mostrar tela de Game Over
    ```

### 3. Uso de `await` com Sinais

O `await` é uma ferramenta poderosa em GDScript que permite pausar a execução de uma função até que um sinal específico seja emitido. Isso é extremamente útil para lógica assíncrona e sequências de eventos.

A sintaxe básica é `await node.signal_name`.

```gdscript
# Exemplo: Esperando um botão ser pressionado antes de fazer algo
func start_game_sequence():
    print("Pressione o botão para começar...")
    await get_node("StartButton").pressed # A execução pausa aqui até o botão ser pressionado
    print("Botão pressionado! Iniciando o jogo...")

    # Exemplo: Esperando uma animação terminar
    var player_sprite = get_node("Player/Sprite2D")
    player_sprite.play("attack")
    await player_sprite.animation_finished # Espera a animação "attack" terminar
    print("Animação de ataque concluída.")

    # Exemplo: Esperando um timer
    print("Esperando 3 segundos...")
    await get_tree().create_timer(3.0).timeout # Cria um timer e espera seu sinal de timeout
    print("3 segundos se passaram!")

    # Exemplo: Esperando um sinal personalizado com parâmetros
    var player = get_node("/root/Game/Player")
    print("Esperando o jogador morrer...")
    await player.died # Espera o sinal 'died' do jogador
    print("O jogador morreu. Fim do jogo.")
```

**Pontos importantes sobre `await`:**
*   A função que usa `await` não precisa ser um `_process` ou `_physics_process`. Ela pode ser uma função comum.
*   Quando `await` é usado, a função é suspensa, mas o resto do jogo continua rodando normalmente.
*   Quando o sinal é emitido, a função é retomada a partir do ponto onde foi pausada.
*   Se o sinal emitir parâmetros, você pode capturá-los na linha seguinte ao `await` se a função for definida para recebê-los. No entanto, o `await` em si não captura os parâmetros diretamente na linha do `await`. Para capturar os parâmetros, você geralmente conecta o sinal a uma função separada ou usa uma abordagem diferente para lógica mais complexa. Para casos simples como `animation_finished` ou `timeout`, onde os parâmetros não são cruciais para a continuação imediata, `await` é perfeito.

### Resumo

Sinais são a espinha dorsal da comunicação na Godot, promovendo um design de código flexível e modular. Você pode usar os sinais embutidos, criar seus próprios sinais personalizados e usar `await` para orquestrar a lógica do seu jogo de forma assíncrona e reativa a eventos. Dominar os sinais é um passo crucial para desenvolver jogos robustos e escaláveis na Godot Engine.
