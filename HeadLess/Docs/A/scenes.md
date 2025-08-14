# Cenas (Scenes)

Na Godot Engine, a **Cena** é o conceito mais fundamental e o principal bloco de construção do seu jogo. Uma cena é uma coleção de Nós (Nodes) organizados em uma árvore, que pode ser salva em disco e instanciada em outras cenas.

## Filosofia: Composição e Reutilização

Pense em uma cena como um "modelo" ou "prefab" reutilizável. Qualquer coisa que você queira criar no seu jogo pode ser uma cena:

*   Um personagem (com seu sprite, script, corpo de colisão, etc.).
*   Uma arma, um item, um inimigo.
*   Um elemento de UI, como o menu principal ou uma barra de vida.
*   Um nível completo do seu jogo.

### Vantagens da Instanciação de Cenas:

*   **Modularidade:** Permite dividir seu jogo em componentes menores e gerenciáveis.
*   **Reutilização:** Você pode criar uma cena de "inimigo_comum" e instanciá-la várias vezes em diferentes níveis. Se você precisar mudar o comportamento desse inimigo, basta editar a cena original, e todas as instâncias serão atualizadas automaticamente.
*   **Organização:** Mantém seu projeto limpo e fácil de navegar.

## Formato de Arquivo (`.tscn`)

As cenas são salvas como arquivos de texto com a extensão `.tscn`. Isso é uma grande vantagem para o desenvolvimento colaborativo e para o controle de versão (Git), pois permite ver as alterações de forma legível e resolver conflitos de merge mais facilmente.

## Como Instanciar Cenas

Você pode instanciar cenas de duas maneiras principais:

### 1. No Editor

1.  Salve a cena que você deseja instanciar (ex: `Player.tscn`).
2.  Abra a cena onde você deseja adicionar a instância (ex: `Level1.tscn`).
3.  No painel "Cena" (Scene), selecione o nó pai sob o qual você deseja adicionar a instância.
4.  Clique no ícone de "link" (ou "corrente") na parte superior do painel "Cena".
5.  Selecione o arquivo `.tscn` que você deseja instanciar. Uma cópia da cena será adicionada como um nó filho.

### 2. Via Código (GDScript)

Instanciar cenas via código é essencial para criar objetos dinamicamente durante o jogo (ex: balas, inimigos que aparecem).

1.  **Carregar a Cena Salva:** Primeiro, você precisa carregar o recurso `PackedScene` da cena salva em disco. Use `preload()` para cenas que serão instanciadas frequentemente, pois ele carrega o recurso no momento da compilação, melhorando a performance.

    ```gdscript
    # Usando preload() (recomendado para uso frequente)
    var EnemyScene = preload("res://Scenes/Enemy.tscn")

    # Ou usando load() para carregamento dinâmico
    # var EnemyScene = load("res://Scenes/Enemy.tscn")
    ```

2.  **Criar uma Instância e Adicioná-la à Árvore de Cenas:** Depois de carregar o `PackedScene`, chame o método `.instantiate()` para criar uma nova instância da cena. Em seguida, adicione essa instância como um nó filho ao nó atual usando `add_child()`.

    ```gdscript
    func _ready():
        var new_enemy_instance = EnemyScene.instantiate()
        add_child(new_enemy_instance)
        new_enemy_instance.position = Vector2(100, 200) # Opcional: definir posição
    ```

Este processo de duas etapas permite que você mantenha uma cena compactada carregada e crie novas instâncias em tempo real, o que é muito eficiente para jogos dinâmicos.
