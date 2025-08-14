# Máquinas de Estado Finitas (FSM)

As Máquinas de Estado Finitas (FSMs) são um padrão de design fundamental para gerenciar o comportamento de objetos em jogos, como personagens, inimigos ou elementos de UI. Elas permitem que um objeto tenha um número finito de estados distintos e transite entre eles com base em eventos ou condições específicas.

### Padrão State (Estado)

O padrão State é uma forma de implementar FSMs que encapsula o comportamento de cada estado em uma classe separada. Isso torna o código mais modular, legível e fácil de manter, pois a lógica de cada estado é isolada.

Em vez de ter um grande bloco `if/else` ou `match` para lidar com todos os estados e suas transições em um único script, o padrão State sugere que cada estado seja uma classe (ou script) independente. O objeto principal (o "contexto") mantém uma referência ao seu estado atual e delega as chamadas de método para esse objeto de estado.

### Implementação com Scripts na Godot

Na Godot, a implementação de FSMs usando scripts geralmente envolve:

1.  **Um Script Principal (Contexto):** Este script, anexado ao nó que você deseja controlar (ex: `Player.gd`, `Enemy.gd`), será responsável por:
    *   Manter uma referência ao estado atual.
    *   Chamar métodos no script de estado atual (ex: `_process`, `_physics_process`, `handle_input`).
    *   Gerenciar as transições de estado, geralmente chamando uma função `change_state()` que atualiza a referência do estado atual.

2.  **Scripts de Estado (Classes de Estado):** Cada estado é um script separado (ex: `IdleState.gd`, `WalkingState.gd`, `JumpingState.gd`). Estes scripts geralmente:
    *   Herdam de uma classe base comum (ex: `BaseState.gd`) para definir uma interface consistente (métodos como `enter()`, `exit()`, `update()`, `handle_input()`).
    *   Contêm a lógica específica para aquele estado (ex: animações, movimento, detecção de colisão).
    *   Podem ter uma referência ao nó principal (o contexto) para acessar suas propriedades ou chamar seus métodos.
    *   São responsáveis por determinar quando uma transição para outro estado deve ocorrer e notificar o contexto para realizar a mudança.

### Estrutura de FSM no Projeto

Este projeto já possui uma estrutura de FSM implementada na pasta `Scripts/FSM/`, que segue o padrão State com nós. Ela consiste em uma classe base `State.gd` e um gerenciador `StateMachine.gd`.

#### `State.gd` (Classe Base de Estado)

Este script define a interface que todos os estados devem seguir. Ele é a base para os estados específicos (como `Idle`, `Run`, `Jump`).

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

#### `StateMachine.gd` (Gerenciador de Estados)

Este script é o coração da FSM. Ele é anexado ao nó principal (o ator, como o jogador ou um inimigo) e gerencia as transições entre os estados.

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

### Benefícios das FSMs

*   **Organização e Clareza:** O código fica mais organizado, pois a lógica de cada comportamento é encapsulada em seu próprio estado. Isso facilita a compreensão do fluxo do jogo.
*   **Manutenção Simplificada:** Alterar ou adicionar novos comportamentos é mais fácil, pois você modifica ou cria um novo script de estado sem afetar a lógica de outros estados.
*   **Reusabilidade:** Os scripts de estado podem ser reutilizados em diferentes objetos que compartilham comportamentos semelhantes.
*   **Depuração Mais Fácil:** Problemas de comportamento são mais fáceis de rastrear, pois você pode identificar rapidamente em qual estado o erro está ocorrendo.
*   **Controle de Transições:** As transições entre estados são explícitas e controladas, evitando comportamentos inesperados ou estados inválidos.

Dominar as FSMs é crucial para criar comportamentos complexos e gerenciáveis em seus jogos Godot.
