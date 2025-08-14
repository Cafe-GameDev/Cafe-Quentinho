# Guia de Conceitos: Viewport

Um `Viewport` é, em sua essência, uma tela. É uma área retangular que renderiza uma visão do seu jogo. A própria janela do seu jogo é um `Viewport`, conhecido como "Root Viewport" (Viewport Raiz).

Eles são um dos nós mais poderosos da Godot e permitem a criação de uma variedade de efeitos e sistemas.

## Principais Casos de Uso

### 1. Sub-Viewports (Telas dentro de Telas)

Quando um nó `Viewport` é filho de um `SubViewportContainer`, ele renderiza tudo o que está dentro dele em uma área específica da tela principal. Isso é a base para:

*   **Split-screen (Tela Dividida):** Para jogos multiplayer locais, onde cada jogador tem sua própria câmera e visão do jogo.
*   **Minimapas:** Renderizar uma visão de cima do nível em um canto da tela.
*   **Interfaces 3D no Espaço 2D:** Renderizar um modelo 3D de um personagem em uma tela de inventário 2D.

### 2. Render Targets (Alvos de Renderização)

Um `Viewport` pode ser configurado para não aparecer na tela. Em vez disso, tudo o que ele renderiza é capturado em uma textura (`ViewportTexture`). Essa textura pode ser usada em qualquer outro lugar do jogo.

*   **Monitores de Segurança:** A textura pode ser aplicada a um material em um modelo 3D de um monitor, mostrando o que uma câmera de segurança está vendo em tempo real.
*   **Espelhos e Portais:** Renderizar a cena a partir de uma perspectiva espelhada para criar um efeito de reflexo.
*   **Efeitos de Pós-Processamento Customizados:** Aplicar shaders à `ViewportTexture` para criar efeitos visuais complexos.

## Propriedades Importantes

*   **`world_2d` / `world_3d`:** Cada `Viewport` pode ter seu próprio "mundo", isolando a física e a renderização de seus filhos do resto do jogo.
*   **`own_world`:** Se esta propriedade for marcada, o `Viewport` criará um novo mundo em vez de usar o do seu `Viewport` pai.
*   **`handle_input_locally`:** Quando ativado, o `Viewport` lida com eventos de mouse e teclado dentro de sua área, útil para interfaces complexas.
