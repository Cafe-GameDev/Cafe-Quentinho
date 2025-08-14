# Splitscreen (Tela Dividida)

Para implementar **Splitscreen** (tela dividida) no Godot, a abordagem principal envolve o uso de múltiplos nós `Viewport` e `Camera2D` (para 2D) ou `Camera3D` (para 3D). Cada viewport renderiza uma parte diferente do mundo do jogo, e você pode exibir essas viewports lado a lado na tela principal.

### 1. Estrutura de Cenas

*   Crie uma cena principal que servirá como o contêiner para as telas divididas.
*   Dentro desta cena principal, adicione nós `SubViewportContainer`. Estes nós são úteis para organizar as viewports na UI, permitindo layouts como tela dividida horizontal ou vertical.
*   Dentro de cada `SubViewportContainer`, adicione um nó `SubViewport`. Este `SubViewport` será onde o mundo do jogo para cada jogador será renderizado.

### 2. Câmeras e Jogadores

*   Para cada jogador, você terá uma instância do seu personagem e uma `Camera2D` (ou `Camera3D`) que seguirá esse personagem.
*   Certifique-se de que a `Camera2D`/`Camera3D` de cada jogador esteja configurada para usar o `SubViewport` correspondente como seu `Viewport` de destino. Você pode fazer isso definindo a propriedade `current` da câmera como `true` e garantindo que ela seja filha do `SubViewport` ou que sua propriedade `viewport` esteja apontando para o `SubViewport` correto.

### 3. Configuração do `SubViewport`

*   Cada `SubViewport` deve ter sua propriedade `size` definida para a resolução desejada para aquela parte da tela dividida (por exemplo, metade da largura da tela principal para uma divisão vertical).
*   A propriedade `update_mode` do `SubViewport` geralmente pode ser deixada como `When Visible` para otimização, mas pode ser ajustada se houver problemas de renderização.

### 4. Exemplo de Layout (2 Jogadores, Divisão Vertical)

```
- Cena Principal (Node2D ou Control)
    - HBoxContainer (para dividir horizontalmente)
        - SubViewportContainer (Jogador 1)
            - SubViewport (Jogador 1)
                - Player1 (instância da cena do jogador)
                    - Camera2D (seguindo Player1)
        - SubViewportContainer (Jogador 2)
            - SubViewport (Jogador 2)
                - Player2 (instância da cena do jogador)
                    - Camera2D (seguindo Player2)
```

### 5. Lógica de Jogo

*   **Gerenciamento de Input:** Você precisará gerenciar os inputs de cada jogador separadamente. Isso pode ser feito usando o sistema de `Input Map` do Godot, criando ações de input específicas para cada jogador (ex: "player1_move_left", "player2_move_left").
*   **Interação no Mundo:** A lógica de cada jogador (movimento, ações) deve ser independente, mas eles interagem no mesmo mundo do jogo (se for o caso).

Ao seguir essas diretrizes, você pode criar uma experiência de tela dividida funcional e otimizada em seu jogo Godot.
