# Guia de Padrões: Multiplayer Local (Tela Dividida)

Implementar um modo multiplayer local com tela dividida (split-screen) na Godot é feito principalmente com o uso de `Viewports`. Cada jogador terá sua própria câmera e uma "tela" dedicada para renderizá-la.

## 1. Mapeamento de Controles (Input Map)

O primeiro passo é garantir que cada jogador possa ser controlado de forma independente.

1.  Vá em **Projeto > Configurações do Projeto > Mapa de Entrada**.
2.  Crie ações separadas para cada jogador. Em vez de "mover_direita", crie "p1_mover_direita" e "p2_mover_direita".
3.  Associe as teclas a cada ação. Para controles, clique no ícone "+" e selecione "Botão do Joypad". Em **Device ID**, defina `0` para o primeiro jogador, `1` para o segundo, e assim por diante.
4.  No script do seu jogador, use uma variável (`@export var player_id: int`) para saber qual conjunto de ações ("p1_", "p2_", etc.) ele deve ouvir.

## 2. Estrutura da Cena para Tela Dividida

A organização dos nós é a chave. Para uma tela dividida horizontalmente para 2 jogadores:

*   **Raiz:** Use um `HBoxContainer` para dividir a tela horizontalmente. Configure seu `Layout` para "Full Rect" para que ele ocupe a janela inteira.
*   **Containers de Viewport:** Dentro do `HBoxContainer`, adicione dois nós `SubViewportContainer`.
    *   Em ambos, vá em `Layout > Size Flags` e marque "Fill" e "Expand" tanto para Horizontal quanto para Vertical. Isso faz com que cada um ocupe metade do `HBoxContainer`.
    *   Marque a propriedade `Stretch` em ambos.
*   **Viewports:** Dentro de cada `SubViewportContainer`, adicione um nó `Viewport`.
*   **Câmeras:** Cada `Viewport` precisa ter sua própria `Camera2D` ou `Camera3D` ativa (`current = true`). A câmera da `Viewport` 1 deve seguir o jogador 1, e a da `Viewport` 2 deve seguir o jogador 2.

## 3. Compartilhando o Mundo

Por padrão, cada novo `Viewport` tem seu próprio "mundo" vazio. Para que ambos os jogadores apareçam em ambas as telas, você precisa fazer com que a segunda `Viewport` use o mesmo mundo da primeira.

Isso é feito por código, geralmente em um script no nó raiz da cena.

```gdscript
@onready var viewport2 = $HBoxContainer/SubViewportContainer2/Viewport

func _ready():
    # Faz a viewport2 renderizar o mesmo mundo 2D da viewport1
    viewport2.world_2d = $HBoxContainer/SubViewportContainer/Viewport.world_2d
```

Com essa estrutura, cada jogador terá sua própria visão independente, mas compartilhando o mesmo espaço de jogo.
