# Documentação de Handlers no Godot Engine

## 1. O que é um "Handler"?

No contexto do Godot Engine e da arquitetura "BodyLess", um "Handler" (ou Manipulador) é um script ou um sistema (frequentemente um Autoload/Singleton) cuja principal responsabilidade é **reagir a eventos (sinais) e orquestrar a lógica correspondente**. Ele atua como um intermediário que traduz uma "intenção" (expressa por um sinal) em uma ou mais "ações" concretas.

O padrão Handler é fundamental para o **desacoplamento** no Godot. Em vez de um nó ou sistema chamar diretamente uma função em outro nó/sistema, ele emite um sinal no EventBus (`GlobalEvents` ou `LocalEvents`). O Handler, que está ouvindo esse sinal, é então responsável por executar a lógica necessária, sem que o emissor precise saber quem ou como a ação será processada.

### Princípios do Handler:

*   **Ouvinte de Sinais:** Um Handler se conecta a um ou mais sinais relevantes do EventBus.
*   **Orquestrador de Lógica:** Ele contém a lógica complexa ou a coordenação de múltiplas ações que devem ocorrer em resposta a um evento.
*   **Desacoplamento:** Ele não tem referências diretas a muitos outros nós ou sistemas; sua interação é primariamente via EventBus.
*   **Responsabilidade Única:** Cada Handler deve ter uma responsabilidade bem definida (ex: gerenciar inputs, gerenciar combate, gerenciar o estado do jogo).

## 2. Como Implementar um Handler no Godot

Um Handler pode ser implementado como um script anexado a um nó (especialmente para lógica local de cena) ou, mais comumente em uma arquitetura desacoplada como a "BodyLess", como um **Autoload (Singleton)**.

### Exemplo de Estrutura Básica de um Handler (Autoload):

```gdscript
# Exemplo: CombatHandler.gd (Autoload)
extends Node

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	# Ouve o sinal de que um ataque foi solicitado
	GlobalEvents.attack_requested.connect(_on_attack_requested)
	# Ouve o sinal de que um personagem recebeu dano
	GlobalEvents.character_damaged.connect(_on_character_damaged)

func _on_attack_requested(attacker_data: Dictionary, target_node: Node) -> void:
	# Lógica de orquestração do ataque
	# 1. Calcula o dano com base em attacker_data
	var damage_amount = attacker_data.get("damage", 10)
	
	# 2. Aplica o dano ao alvo (pode ser via função direta se o alvo for um Character, ou via sinal)
	if target_node.has_method("take_damage"):
		target_node.take_damage(damage_amount)
		GlobalEvents.debug_log_requested.emit({"message": "[CombatHandler] " + target_node.name + " took " + str(damage_amount) + " damage.", "type": "info"})
	
	# 3. Emite sinais de feedback (ex: texto flutuante, som de acerto)
	GlobalEvents.show_floating_text_requested.emit(str(damage_amount), target_node.global_position, Color.RED)
	GlobalEvents.play_sfx_by_key_requested.emit("sfx_hit")

func _on_character_damaged(character_node: Node, damage_taken: float) -> void:
	# Lógica em resposta a um personagem ter recebido dano
	# (ex: verificar morte, atualizar UI de vida)
	if character_node.has_method("get_health") and character_node.get_health() <= 0:
		GlobalEvents.character_defeated.emit(character_node)
		GlobalEvents.debug_log_requested.emit({"message": "[CombatHandler] " + character_node.name + " defeated.", "type": "info"})

```

## 3. Onde e Como Usar Handlers no Projeto

Handlers são ideais para gerenciar lógicas que envolvem múltiplos sistemas ou que precisam ser centralizadas para manter o desacoplamento.

*   **`InputManager` (Já Existente):** Atua como um Handler de inputs. Ele ouve eventos brutos do `_unhandled_input` e emite sinais de "intenção" (ex: `pause_toggled`, `debug_console_toggled`). Ele não executa a ação de pausar, apenas informa que a ação foi solicitada.

*   **`GlobalMachine` (Já Existente):** Atua como um Handler de estados do jogo. Ele ouve `pause_toggled` e decide se o jogo deve pausar ou despausar, emitindo `game_state_changed`.

*   **`SaveSystem` (Já Existente):** Atua como um Handler de persistência. Ele ouve `request_save_game` e `request_load_game`, e orquestra a coleta/aplicação de dados de outros Managers.

*   **`InventoryManager` (A Ser Criado):** Será um Handler para a lógica de inventário. Ele ouvirá sinais como `item_collected` (emitido por um item no chão) e `request_use_item` (emitido pela UI), e gerenciará a adição/remoção/uso de itens no inventário do jogador.

*   **`CombatHandler` (Exemplo, pode ser integrado ao Player/Enemy ou um novo Autoload):**
    *   **Responsabilidade:** Gerenciar a lógica de dano, acertos, morte de personagens, e talvez efeitos de status.
    *   **Sinais que ouviria:** `attack_requested(attacker_data, target_node)`, `character_damaged(character_node, damage_amount)`.
    *   **Sinais que emitiria:** `character_defeated(character_node)`, `show_floating_text_requested`, `play_sfx_by_key_requested`.

*   **`QuestManager` (A Ser Criado):** Será um Handler para o sistema de quests. Ele ouvirá sinais de eventos de jogo (ex: `enemy_defeated`, `item_collected`) e atualizará o progresso das quests, emitindo `quest_updated`.

*   **`LootSystem` (A Ser Criado):** Será um Handler para a lógica de drops de itens. Ele ouvirá `character_defeated` e, com base na `LootTable` do inimigo, instanciará itens no mundo e emitirá `item_spawned`.

## 4. Relação com Outros Padrões

Handlers trabalham em conjunto com:

*   **Event Bus:** O Event Bus é o meio de comunicação que os Handlers utilizam.
*   **Managers (Singletons):** Muitos Handlers são implementados como Managers globais para centralizar a lógica.
*   **State Machines:** Handlers podem interagir com máquinas de estado, acionando transições ou reagindo a mudanças de estado.

## 5. Benefícios do Padrão Handler

*   **Desacoplamento:** Reduz a dependência direta entre classes, tornando o código mais modular e fácil de modificar.
*   **Manutenibilidade:** Lógicas complexas são centralizadas em um único local, facilitando a depuração e a manutenção.
*   **Extensibilidade:** Novas funcionalidades podem ser adicionadas simplesmente conectando-se aos sinais existentes ou adicionando novos Handlers, sem modificar o código existente.
*   **Testabilidade:** Handlers podem ser testados isoladamente, simulando a emissão de sinais.

---

**O padrão Handler é uma peça fundamental da arquitetura "BodyLess", promovendo um desenvolvimento limpo, escalável e eficiente no Godot Engine.**
