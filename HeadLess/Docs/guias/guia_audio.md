# Guia de Padrões: Áudio

O sistema de áudio da Godot é baseado em três componentes principais: `AudioStream`, `AudioStreamPlayer` e `AudioBuses`.

## 1. AudioStream

É o **dado** de áudio, o arquivo em si.
*   **`.wav`:** Não comprimido. Ideal para efeitos sonoros curtos e em loop.
*   **`.ogg`:** Comprimido. Perfeito para músicas de fundo e sons longos.

## 2. AudioStreamPlayer

É o **reprodutor**. O nó que você coloca na sua cena para tocar um `AudioStream`.
*   **`AudioStreamPlayer`:** Toca som de forma não-posicional (2D). Perfeito para música e sons de UI.
*   **`AudioStreamPlayer2D`:** Toca som posicional em 2D. O volume e o pan (esquerda/direita) mudam com a distância da câmera.
*   **`AudioStreamPlayer3D`:** Toca som posicional em 3D.

## 3. Audio Buses (Canais de Áudio)

São o **mixer** do seu jogo. Você pode acessá-los na aba "Áudio" na parte inferior do editor.

A prática recomendada é criar canais separados para cada categoria de som.

*   **Master:** O canal principal. Todos os outros canais se conectam a ele.
*   **Music:** Crie este canal e direcione toda a sua música para ele. Assim, você pode controlar o volume de todas as músicas do jogo em um só lugar.
*   **SFX:** Crie este canal para todos os efeitos sonoros (passos, tiros, cliques).

### Aplicando Efeitos
Você pode adicionar efeitos (Reverb, EQ, Compressor) a qualquer canal. Por exemplo, adicionar Reverb ao canal "SFX" fará com que todos os efeitos sonoros do jogo pareçam estar em um ambiente reverberante.

## Boas Práticas

*   **Crie um `AudioManager` Singleton:** Centralize a lógica de áudio em um script AutoLoad. Em vez de cada script ter que encontrar e tocar um som, ele pode simplesmente chamar `AudioManager.play_sfx("player_jump")`.
*   **Use `AudioEventData`:** Para sons que se repetem muito (passos, tiros), use o `Resource` `AudioEventData` que criamos para adicionar variação de tom e volume, evitando que o som fique repetitivo e cansativo.
