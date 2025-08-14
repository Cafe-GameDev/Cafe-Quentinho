# Guia de Configuração: Pixel Art

Para que a pixel art funcione corretamente em Godot, sem borrões ou distorções, é crucial ajustar algumas configurações do projeto. Por padrão, o motor tenta suavizar as imagens, o que é o oposto do que queremos.

Siga estes três passos para uma configuração perfeita.

## 1. Filtro de Textura (O Mais Importante)

Este passo garante que a Godot não suavize (blur) suas texturas ao escalá-las.

1.  Vá em **Projeto > Configurações do Projeto**.
2.  Navegue até **Rendering > Textures**.
3.  Em **Default Texture Filter**, mude de `Linear` para `Nearest`.

## 2. Resolução e Modo de Expansão (Stretch)

Aqui definimos o tamanho da "tela virtual" do seu jogo e como ela se adapta a monitores maiores.

1.  Ainda nas **Configurações do Projeto**, vá para **Display > Window**.
2.  **Viewport Width / Height:** Defina a resolução base do seu jogo. Valores comuns para pixel art são 320x180, 480x270 ou 640x360.
3.  **Stretch > Mode:**
    *   **`viewport`:** A opção mais comum para pixel art. Renderiza o jogo na resolução base e depois estica a imagem inteira para caber na janela. Isso mantém a proporção dos pixels perfeitamente, dando um look retrô autêntico.
    *   **`canvas_items`:** Renderiza a UI e os elementos 2D na resolução da janela, mas mantém as posições relativas. Útil se você quer uma UI de alta resolução sobre um jogo pixelado.

4.  **Stretch > Aspect:** Mude para **`keep`** para evitar que seu jogo estique de forma desproporcional em monitores com aspect ratio diferente.

## 3. Alinhamento de Pixel (Pixel Snap)

Este passo ajuda a evitar artefatos visuais (linhas ou espaços entre tiles) quando a câmera ou os objetos se movem.

1.  Ainda nas **Configurações do Projeto**, vá para **Rendering > 2d**.
2.  Ative a opção **Snapping > Use Gpu Pixel Snap**.

Com essas três configurações, seu projeto estará perfeitamente ajustado para um desenvolvimento com pixel art nítida e consistente.
