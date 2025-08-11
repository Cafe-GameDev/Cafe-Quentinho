# Guia de Implementação: Máquina de Estado Finita (FSM)

Este guia documenta o padrão de design de Máquina de Estado Finita (FSM), baseado na abordagem recomendada pela [GDQuest](https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/). A FSM é essencial para gerenciar o comportamento de entidades complexas, como o jogador ou inimigos, de forma organizada e escalável.

## O que é uma FSM?

Uma FSM é um modelo que organiza o comportamento de um objeto em um número finito de **estados**. O objeto só pode estar em **um estado por vez**.

**Exemplo:** Um jogador pode estar no estado `Parado`, `Andando` ou `Pulando`. Ele não pode estar `Andando` e `Pulando` ao mesmo tempo.

A transição de um estado para outro acontece em resposta a eventos (ex: o jogador pressiona a tecla de pulo) ou condições (ex: a vida do inimigo chega a zero).

## Por que usar uma FSM?

Sem uma FSM, o código de um personagem pode se tornar uma série de condicionais `if/elif/else` complexas e difíceis de manter:

```gdscript
# Exemplo RUIM (sem FSM)
func _physics_process(delta):
    if is_jumping:
        # ... lógica de pulo
    elif is_running:
        # ... lógica de corrida
    elif is_attacking:
        # ... lógica de ataque
```

A FSM resolve isso encapsulando a lógica de cada estado em sua própria classe, tornando o código mais limpo, modular e fácil de depurar.

## Implementação (Padrão State com Nós)

Nossa implementação usa o padrão "State", onde cada estado é um nó com seu próprio script.

### 1. A Classe Base: `State.gd`

Este é o "contrato" que todo estado deve seguir. Crie um script `State.gd` (pode ser em `Scripts/FSM/` ou similar) com o seguinte conteúdo. Ele não precisa ser anexado a nenhum nó, pois será usado como uma classe base com `class_name`.

```gdscript
# Scripts/FSM/State.gd
class_name State
extends Node

# Opcional: referência ao ator (jogador, inimigo) para acesso fácil.
@export var actor: Node

# Sinal emitido para solicitar uma transição para outro estado.
# O StateMachine irá ouvir este sinal.
signal transition_requested(new_state_name: String)

# Chamado quando a máquina de estados entra neste estado.
# Ideal para inicializar, como tocar uma animação.
func enter():
	pass

# Chamado quando a máquina de estados sai deste estado.
# Ideal para limpar, como parar um som.
func exit():
	pass

# Chamado a cada frame de física, se este for o estado ativo.
func physics_update(_delta: float):
	pass

# Chamado a cada frame normal, se este for o estado ativo.
func process_update(_delta: float):
	pass
```

### 2. O Gerenciador: `StateMachine.gd`

Este nó será um filho do seu ator (jogador, inimigo) e gerenciará os estados. Os nós de estado individuais serão filhos deste `StateMachine`.

```gdscript
# Scripts/FSM/StateMachine.gd
class_name StateMachine
extends Node

# O estado inicial. Se não for definido, será o primeiro filho.
@export var initial_state: State

var current_state: State

func _ready():
	# Aguarda o pai (ator) estar pronto para garantir que os nós estejam disponíveis.
	await owner.ready

	# Define o estado inicial.
	initial_state = get_child(0) if not initial_state else initial_state
	
	# Conecta o sinal de transição de todos os estados filhos.
	for child in get_children():
		if child is State:
			child.transition_requested.connect(_on_transition_requested)
	
	# Entra no estado inicial.
	current_state = initial_state
	current_state.enter()

func _physics_process(delta: float):
	if current_state:
		current_state.physics_update(delta)

func _process(delta: float):
	if current_state:
		current_state.process_update(delta)

# Função que realiza a transição de estado.
func _on_transition_requested(new_state_name: String):
	var new_state = get_node_or_null(new_state_name)
	if not new_state or not new_state is State:
		return # O estado solicitado não existe ou não é um nó de Estado.

	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
```

### 3. Exemplo de Estado Concreto: `Idle.gd`

Este é um exemplo de um estado real. Crie um script `Idle.gd` que herda de `State`.

```gdscript
# Scripts/Player/States/Idle.gd
extends State

@onready var animation_player = owner.get_node("AnimationPlayer")

func enter():
	animation_player.play("idle")

func physics_update(_delta: float):
	# Exemplo de transição: se o jogador se mover, transita para o estado "Run".
	if Input.get_axis("move_left", "move_right") != 0:
		transition_requested.emit("Run")
```

## Como Usar

1.  **Estrutura de Nós:**
    ```
    - Player (CharacterBody2D)
      - AnimationPlayer
      - StateMachine (com o script StateMachine.gd)
        - Idle (Nó com o script Idle.gd)
        - Run (Nó com o script Run.gd)
        - Jump (Nó com o script Jump.gd)
    ```

2.  **Configure os Estados:** Em cada script de estado (Idle, Run, etc.), certifique-se de que eles herdem de `State` (`extends State`).

3.  **Emita Sinais:** Dentro de cada estado, use `transition_requested.emit("NomeDoOutroEstado")` para solicitar uma mudança de estado.

Esta abordagem mantém a lógica de cada comportamento isolada, tornando seu projeto muito mais fácil de gerenciar e expandir.
