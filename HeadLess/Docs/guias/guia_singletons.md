# Guia de Padrões: Singletons (Autoloads)

O padrão Singleton é um mecanismo que garante que exista apenas uma única instância de uma classe, acessível globalmente. Em Godot, isso é alcançado através do recurso **AutoLoad**.

## Para que serve?

Autoloads são ideais para sistemas que precisam estar sempre disponíveis, independentemente da cena atual.

*   **Gerenciadores Globais:** Como um `AudioManager` para tocar sons de qualquer lugar, ou um `SceneManager` para controlar transições de cena.
*   **Dados Globais:** Para armazenar informações que persistem durante todo o jogo, como a pontuação do jogador ou o estado de um quest global.

## Como Configurar

1.  **Crie um Script:** Crie um script que herde de `Node` (ex: `MeuSingleton.gd`).
2.  **Vá em Projeto > Configurações do Projeto.**
3.  Selecione a aba **AutoLoad**.
4.  Em "Caminho", selecione seu script. Em "Nome do Nó", defina o nome global que você usará para acessá-lo (ex: `MeuSingleton`). Clique em "Adicionar".

## Como Usar

Uma vez configurado, o AutoLoad fica acessível globalmente pelo nome que você definiu.

```gdscript
# Em qualquer script do seu jogo:

func _ready():
    # Supondo que MeuSingleton.gd tenha uma variável 'pontuacao'
    MeuSingleton.pontuacao += 10
    print(MeuSingleton.pontuacao)

    # E uma função 'salvar_jogo()'
    MeuSingleton.salvar_jogo()
```

---

## Padrões Avançados e Casos de Uso

### 1. Padrão "Event Bus" (Barramento de Eventos Global)

Esta é uma das aplicações mais poderosas de um Singleton. Em vez de nós se conectarem diretamente uns aos outros, eles se conectam ao Singleton central, que atua como um grande "quadro de avisos".

**Implementação:**

```gdscript
# No seu Singleton (ex: GlobalEvents.gd)
extends Node

signal jogador_morreu
signal pontuacao_atualizada(nova_pontuacao)
signal inimigo_derrotado(posicao_inimigo)
```

*   **Emissão:** Quando o jogador morre, ele não precisa saber quem está ouvindo. Ele simplesmente avisa o "quadro de avisos":
    ```gdscript
    # No script do jogador
    func morrer():
        GlobalEvents.jogador_morreu.emit()
        queue_free()
    ```
*   **Recepção:** Outros sistemas, como a UI ou um `GameManager`, podem ouvir esses eventos globais:
    ```gdscript
    # No script da UI
    func _ready():
        GlobalEvents.jogador_morreu.connect(_on_jogador_morreu)

    func _on_jogador_morreu():
        # Mostra a tela de Game Over
        show_game_over_screen()
    ```
**Vantagem:** Desacoplamento máximo. O jogador não sabe da existência da UI, e a UI não sabe da existência do jogador. Eles só conhecem o `GlobalEvents`.

### 2. Gerenciamento de Estado do Jogo (FSM Global)

Um Singleton é o lugar perfeito para gerenciar o estado geral do jogo usando uma Máquina de Estados Finitos (Finite State Machine - FSM).

```gdscript
# No seu Singleton (ex: GameStateManager.gd)
extends Node

enum Estado { MENU, JOGANDO, PAUSADO, GAME_OVER }
var estado_atual: Estado = Estado.MENU

func mudar_estado(novo_estado: Estado):
    estado_atual = novo_estado
    match estado_atual:
        Estado.MENU:
            get_tree().paused = false
            # Lógica para mostrar o menu principal
        Estado.JOGANDO:
            get_tree().paused = false
            # Lógica para iniciar/continuar o jogo
        Estado.PAUSADO:
            get_tree().paused = true
            # Lógica para mostrar a tela de pausa
```
Qualquer outro script pode então verificar `GameStateManager.estado_atual` para decidir o que fazer.

### 3. Singleton como Provedor de Serviços

Use um Singleton para centralizar operações complexas, em vez de apenas guardar dados.
*   **`MusicManager`**: Um Singleton que gerencia uma *playlist*, toca a próxima música automaticamente e cria transições suaves (fade-in/fade-out) entre as faixas.
*   **`PathfindingManager`**: Um Singleton que expõe uma função `calcular_caminho(inicio, fim)` para que qualquer inimigo possa solicitar um caminho sem precisar ter sua própria lógica de `AStar` ou `NavigationServer`.

### 4. Quando NÃO Usar um Singleton

O acesso global é poderoso, mas pode levar a código "espaguete" se usado em excesso.

*   **Dados de um Inimigo Específico:** A vida de um inimigo deve estar no script do próprio inimigo, não em um Singleton.
*   **Configurações de uma Arma:** Use um `Resource` (`WeaponData.tres`) para isso. `Resources` são compartilháveis, mas não precisam estar sempre carregados como um AutoLoad.
*   **Nós de UI:** Se você precisa de uma referência a um nó de UI, geralmente é melhor usar `get_node()` ou exportar uma `NodePath` do que transformar a UI em um Singleton.

A regra de ouro: um script deve ser um Singleton apenas se você precisar de **exatamente uma instância** dele, que precisa estar **sempre acessível** de **qualquer lugar** do seu jogo.