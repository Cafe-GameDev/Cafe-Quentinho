# Shaders

A Godot Engine utiliza **Shaders** para dar vida e estilo visual aos seus jogos, sendo essenciais para criar efeitos visuais (VFX) complexos, manipular a renderização de objetos e aplicar pós-processamento na tela.

### Linguagem de Shader (GDShader)

A Godot possui sua própria linguagem de shader, chamada **GDShader**, que é baseada em GLSL (OpenGL Shading Language), mas simplificada e com funções úteis integradas. Existem três tipos principais de shaders, cada um para um contexto de renderização diferente:

*   **`spatial`**: Usado para objetos 3D. Permite manipular como a luz interage com a superfície de um modelo, criando efeitos de material, iluminação e reflexão.
*   **`canvas_item`**: Usado para objetos 2D e elementos de UI. Permite manipular a cor, textura e posição dos pixels de elementos 2D, ideal para efeitos como distorção, brilho, ou modificações de cor.
*   **`particles`**: Usado especificamente para sistemas de partículas (GPUParticles2D/3D). Permite controlar o comportamento e a aparência de milhares de partículas de forma eficiente na GPU.

#### Uniforms

**Uniforms** são variáveis que permitem passar dados do seu código (GDScript/C#) para o shader em tempo real. Eles são a ponte entre a lógica do seu jogo e os efeitos visuais do shader. Exemplos incluem a cor de um flash de dano, a força de uma distorção, ou a intensidade de um brilho.

```gdshader
// Exemplo de uniform em um shader canvas_item
shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0); // Cor padrão branca
uniform float intensity = 0.0; // Intensidade do efeito, de 0.0 a 1.0

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    // Mistura a cor base com a cor do flash baseada na intensidade
    COLOR = mix(base_color, flash_color, intensity);
}
```

No GDScript, você definiria esses uniforms assim:

```gdscript
# No script de um nó com um ShaderMaterial
@onready var material = $Sprite2D.material as ShaderMaterial

func apply_flash(color: Color, duration: float):
    material.set_shader_parameter("flash_color", color)
    var tween = create_tween()
    tween.tween_property(material, "shader_parameter/intensity", 1.0, duration / 2.0)
    tween.tween_property(material, "shader_parameter/intensity", 0.0, duration / 2.0)
```

### Editor Visual de Shaders

Para quem prefere não escrever código, a Godot oferece um **Editor de Shader Visual**. Ele permite construir shaders complexos conectando nós de lógica, matemática e textura em um ambiente visual. É uma excelente ferramenta para artistas e para prototipar ideias rapidamente, traduzindo-as para GDShader automaticamente.

### Sistemas de Partículas (GPUParticles2D / GPUParticles3D)

Para efeitos como fumaça, fogo, explosões e magia, utilize os nós de partículas da Godot. Eles são altamente performáticos porque rodam inteiramente na GPU. A aparência e o comportamento das partículas são definidos em seu **Process Material** (geralmente um `ParticleProcessMaterial`), onde você pode configurar velocidade, cor e escala ao longo do tempo.

### Boas Práticas de VFX com Shaders

*   **Otimização:** Shaders podem ser custosos em termos de performance. Mantenha-os o mais simples possível para a tarefa. Evite cálculos complexos no `fragment shader` se puderem ser feitos no `vertex shader`.
*   **Reutilização:** Crie shaders genéricos com `uniforms` para que possam ser reutilizados em diferentes materiais com parâmetros distintos. Isso reduz a duplicação de código e facilita a manutenção.
*   **Texturas para Lógica:** Utilize texturas (como um gradiente) para controlar o comportamento do shader ao longo do tempo ou do espaço. Isso é muitas vezes mais performático do que realizar cálculos matemáticos complexos diretamente no shader.
*   **Shaders Globais (Pós-Processamento):** Para efeitos que afetam a tela inteira (vinhetas, correção de cor, distorção), use shaders de pós-processamento aplicados a um `ColorRect` em um `CanvasLayer`.
*   **Parâmetros Globais de Shader:** Para sincronizar um valor através de múltiplos materiais e objetos (ex: vento que afeta todas as árvores), use `RenderingServer.global_shader_parameter_set()` para definir um `uniform` global que pode ser acessado por qualquer shader com a hint `:global`.
