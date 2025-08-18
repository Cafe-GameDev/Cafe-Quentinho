# Upscale e Downscale (Redimensionamento)

No Godot Engine, o redimensionamento (upscale e downscale) da sua aplicação é gerenciado principalmente através das configurações de "Estiramento" (Stretch) nas Configurações do Projeto, além de opções específicas para renderização 3D e tratamento de pixel art. O objetivo é garantir que seu jogo tenha uma aparência consistente e um desempenho otimizado em uma ampla variedade de dispositivos e resoluções de tela.

### Configurações de Estiramento (Stretch Settings)

As configurações mais importantes para controlar como seu jogo se adapta a diferentes resoluções de tela estão em **Projeto > Configurações do Projeto > Exibir > Janela > Estiramento**.

1.  **Modo (Mode):**
    *   **`disabled`**: O viewport não é esticado. Se a janela for redimensionada, a área visível do jogo (campo de visão da câmera) se expande ou contrai. Isso significa que mais ou menos do mundo do jogo será visível, sem redimensionamento dos elementos.
    *   **`canvas_items`**: Este modo estica a resolução base definida nas Configurações do Projeto para preencher a tela inteira. É ideal para jogos 2D onde você deseja que todos os elementos da interface e do jogo sejam dimensionados proporcionalmente.
    *   **`viewport`**: Similar ao `canvas_items`, mas mantém uma correspondência 1:1 entre a resolução base e a saída esticada. É frequentemente recomendado para jogos de pixel art, pois ajuda a manter os pixels nítidos, embora possa resultar em barras pretas (letterboxing ou pillarboxing) se a proporção da tela não corresponder à resolução base.

2.  **Aspecto (Aspect):**
    *   **`ignore`**: O jogo é esticado para preencher a tela, ignorando a proporção original. Isso pode causar distorção da imagem.
    *   **`keep`**: Mantém a proporção original do jogo, adicionando barras pretas nas laterais ou na parte superior/inferior da tela se a proporção da tela não corresponder à resolução base.
    *   **`expand`**: Expande o viewport para preencher a tela enquanto mantém a proporção. Em vez de adicionar barras pretas, ele revela mais do mundo do jogo em telas com proporções diferentes.

3.  **Modo de Escala de Estiramento (Stretch Scale Mode):**
    *   **`fractional`**: Permite o dimensionamento por fatores não inteiros. Isso pode resultar em pixels borrados ou artefatos visuais, especialmente em pixel art.
    *   **`integer`**: Garante que os pixels sejam dimensionados por números inteiros (por exemplo, 1x, 2x, 3x). Isso é crucial para manter a nitidez em jogos de pixel art, mas pode levar a barras pretas se a resolução da janela não for um múltiplo exato da resolução base.

### Considerações Específicas

#### Para Pixel Art 2D

Para garantir que sua pixel art permaneça nítida e sem borrões ao ser dimensionada:
*   **Filtro de Textura Padrão**: Em **Projeto > Configurações do Projeto > Renderização > Texturas**, defina o `Filtro de Textura Padrão` para **`Nearest`**. Isso impede que o Godot use interpolação linear, que borra os pixels. Você também pode definir isso individualmente para cada sprite no Inspetor.
*   **Modo `viewport` com Escala `integer`**: Esta combinação é geralmente a mais recomendada para pixel art, pois garante que os pixels sejam sempre dimensionados por múltiplos inteiros, mantendo sua definição.
*   **Movimento Sub-pixel**: Se você tiver movimento sub-pixel (onde os objetos se movem por frações de pixel), isso pode causar "jittering" ou cintilação. Algumas soluções envolvem o uso de shaders personalizados para suavizar o movimento sem perder a nitidez dos pixels.

#### Para Renderização 3D

*   **Escala de Renderização 3D**: Em **Projeto > Configurações do Projeto > Renderização > Escala 3D**, a configuração `Escala` ajusta a resolução de renderização dos elementos 3D. Valores abaixo de 1.0 podem ser usados para melhorar o desempenho em dispositivos de baixo custo, à custa de uma imagem mais borrada.
*   **Dimensionamento Dinâmico**: É possível implementar um sistema de dimensionamento de resolução dinâmico para elementos 3D. Isso geralmente envolve renderizar a cena 3D para um `Viewport` separado e, em seguida, dimensionar a saída desse `Viewport` para a tela principal. Isso permite que a interface do usuário (UI) permaneça nítida enquanto a resolução 3D é ajustada para otimização de desempenho.

#### Controle Programático

Você pode alterar as configurações de resolução e estiramento em tempo de execução através de código GDScript:
*   Para definir o tamanho da janela: `DisplayServer.window_set_size(Vector2i(largura, altura))`
*   Para alterar o modo de estiramento e aspecto:
    ```gdscript
    get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
    get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
    ```
    Ou, alternativamente, usando `get_window()`:
    ```gdscript
    get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
    get_window().content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
    ```

Ao entender e configurar essas opções, você pode garantir que seu jogo Godot tenha uma aparência consistente e um desempenho otimizado em uma ampla variedade de dispositivos e resoluções de tela.
