# Guia de Conceitos: Shaders

Shaders são programas que rodam na placa de vídeo (GPU) e dizem a ela como desenhar cada pixel de um objeto na tela. Eles são usados para criar uma infinidade de efeitos visuais, desde simples mudanças de cor até complexas distorções de água, contornos e efeitos de pós-processamento.

Em Godot, a linguagem de shader é chamada **GDShader**, e sua sintaxe é muito parecida com a popular GLSL.

## Tipos de Shader

Existem três tipos principais de shaders que você pode criar:

1.  **`spatial`:** Para objetos 3D (`MeshInstance3D`, etc.).
2.  **`canvas_item`:** Para objetos 2D (`Sprite2D`, UI, etc.).
3.  **`particles`:** Para controlar o comportamento de sistemas de partículas na GPU.

## Como Funciona um Shader?

Um shader é composto principalmente por duas funções:

*   **`vertex()`:** Executada uma vez para cada vértice (ponto) da sua malha. É aqui que você pode manipular a posição, rotação ou escala dos vértices para criar efeitos de deformação.
*   **`fragment()` (ou `light()` em 3D):** Executada uma vez para cada pixel visível do seu objeto. É aqui que você define a cor final do pixel. A maioria dos efeitos 2D (mudança de cor, texturização, contornos) acontece aqui.

## Passando Dados para o Shader (Uniforms)

Para controlar um shader a partir do seu código GDScript (ex: fazer um personagem piscar em vermelho ao sofrer dano), você usa **uniforms**.

```gdshader
// No seu shader (.gdshader)
shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0); // Cria uma variável controlável
uniform bool active = false;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    if (active) {
        COLOR = flash_color;
    } else {
        COLOR = original_color;
    }
}
```
```gdscript
# No seu GDScript (.gd)
func apply_damage_flash():
    $Sprite2D.material.set_shader_parameter("active", true)
    $Sprite2D.material.set_shader_parameter("flash_color", Color.RED)
```

## Visual Shaders

Se você não se sente confortável com código, Godot oferece um **Editor de Shader Visual**. Ele permite que você construa a lógica do shader conectando nós, de forma similar ao editor de cenas, tornando o processo mais acessível para artistas e iniciantes.
