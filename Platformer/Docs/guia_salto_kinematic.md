# Guia de Padrões: Fórmulas de Salto Cinemático

Ao programar o pulo de um personagem, é comum ajustar valores de "força do pulo" e "gravidade" na base da tentativa e erro até que o resultado pareça bom. Uma abordagem mais elegante e baseada em design é usar fórmulas cinemáticas.

Com elas, você define o **resultado** que deseja, e a fórmula calcula a física necessária para você.

## As Variáveis de Design

Em vez de pensar em física, pense como um designer. As perguntas que você quer responder são:

*   **`jump_height`:** Qual a altura máxima que o personagem deve alcançar (em pixels ou metros)?
*   **`time_to_peak`:** Quanto tempo (em segundos) o personagem deve levar para atingir o pico do pulo?
*   **`time_to_fall`:** Quanto tempo (em segundos) o personagem deve levar para cair do pico até o chão?

## As Fórmulas

Com as variáveis de design acima, podemos calcular a velocidade inicial do pulo e a gravidade.

### 1. Velocidade Inicial do Pulo (`jump_velocity`)

Esta fórmula calcula a força inicial necessária para o pulo.

*   **Fórmula:** `jump_velocity = (2.0 * jump_height) / time_to_peak`
*   **No GDScript:**
    ```gdscript
    @export var jump_height = 80.0
    @export var time_to_peak = 0.4

    var jump_velocity

    func _ready():
        jump_velocity = (2.0 * jump_height) / time_to_peak
    ```

### 2. Gravidade (`gravity`)

A gravidade precisa ser calculada para corresponder ao tempo de subida e descida.

*   **Fórmula:** `gravity = (2.0 * jump_height) / (time_to_peak * time_to_peak)`
*   **No GDScript:**
    ```gdscript
    @export var jump_height = 80.0
    @export var time_to_peak = 0.4

    var gravity

    func _ready():
        gravity = (2.0 * jump_height) / (time_to_peak * time_to_peak)
    ```

## Implementação no `_physics_process`

No seu `CharacterBody2D`, você aplicaria esses valores da seguinte forma:

```gdscript
# ... (variáveis e _ready() com as fórmulas) ...

func _physics_process(delta):
    if not is_on_floor():
        velocity.y += gravity * delta

    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = -jump_velocity # Negativo porque o Y é para baixo

    move_and_slide()
```

Esta abordagem dá a você controle total sobre a "sensação" do pulo, permitindo ajustes finos de forma intuitiva.
