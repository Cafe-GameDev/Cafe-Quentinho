# Guia de Arquitetura: Dados com Resources

Este guia documenta a abordagem padrão do projeto para gerenciar dados de jogo usando a classe `Resource` da Godot. Separar os **dados** (o que um objeto *é*) da **lógica** (o que um objeto *faz*) é uma prática fundamental para criar um projeto escalável, fácil de manter e amigável para designers.

## O que são `Resources`?

`Resource` é uma classe especial na Godot projetada para conter dados. Pense neles como "contêineres de dados" ou "arquivos de configuração" que você pode criar, salvar e modificar diretamente no editor da Godot.

Quando você cria um script que herda de `Resource` (ex: `WeaponData.gd`), a Godot permite que você crie novos "arquivos de recurso" (`.tres`) a partir dele no menu do sistema de arquivos. Cada arquivo `.tres` é uma instância única desse recurso, com seus próprios valores nas variáveis exportadas.

**Vantagens:**

*   **Organização:** Mantém os dados do jogo (stats de armas, vida de inimigos) separados da lógica do jogador ou do inimigo.
*   **Reutilização:** Um mesmo `Resource` (ex: `potion.tres`) pode ser usado por vários nós.
*   **Facilidade de Balanceamento:** Um game designer pode ajustar a vida de um inimigo ou o dano de uma arma editando um arquivo `.tres` no Inspector, sem precisar tocar em nenhum código.
*   **Flexibilidade:** `Resources` podem ser carregados, duplicados e modificados em tempo de execução.

---

## Padrões de `Resource` do Projeto

A seguir estão os padrões de `Resource` recomendados para os sistemas mais comuns do jogo.

### 1. `CharacterData`

*   **Propósito:** Define os atributos e assets de um personagem jogável. Ideal para sistemas de seleção de personagem.
*   **Exemplo de Código (`Scripts/Resources/CharacterData.gd`):**
    ```gdscript
    class_name CharacterData
    extends Resource

    @export var character_name: String = "Herói"
    @export var scene: PackedScene # A cena .tscn do personagem
    @export var portrait: Texture2D # Imagem para a tela de seleção

    @export_group("Estatísticas de Jogo")
    @export var max_health: int = 100
    @export var base_speed: float = 300.0
    @export var jump_velocity: float = -400.0
    ```
*   **Uso:** Uma tela de seleção de personagem leria vários arquivos `CharacterData.tres` (`knight.tres`, `mage.tres`) e, ao selecionar um, instanciaria a cena definida em `character_data.scene`.

### 2. `WeaponData`

*   **Propósito:** Define as estatísticas e o comportamento de uma arma.
*   **Exemplo de Código (`Scripts/Resources/WeaponData.gd`):**
    ```gdscript
    class_name WeaponData
    extends Resource

    @export var weapon_name: String = "Espada"
    @export var attack_damage: int = 10
    @export var attack_range: float = 1.5
    @export var attack_speed: float = 0.8 # Ataques por segundo
    @export var attack_animation: StringName # Nome da animação a ser tocada
    @export var icon: Texture2D
    ```
*   **Uso:** O script do jogador teria uma variável `@export var current_weapon: WeaponData`. Ao atacar, ele leria `current_weapon.attack_damage` para calcular o dano.

### 3. `EnemyData`

*   **Propósito:** Define os atributos de um tipo de inimigo, criando "arquétipos".
*   **Exemplo de Código (`Scripts/Resources/EnemyData.gd`):**
    ```gdscript
    class_name EnemyData
    extends Resource

    @export var enemy_name: String = "Goblin"
    @export var scene: PackedScene # A cena .tscn do inimigo
    
    @export_group("Estatísticas de Combate")
    @export var max_health: int = 50
    @export var damage: int = 5
    @export var move_speed: float = 150.0
    
    @export_group("Comportamento")
    @export var detection_radius: float = 300.0
    @export var attack_radius: float = 50.0
    ```
*   **Uso:** Um `EnemySpawner` poderia ter um array de `EnemyData` e, ao instanciar um inimigo, passaria o `Resource` para que o inimigo se configurasse (vida, velocidade, etc.).

### 4. `InventoryData`

*   **Propósito:** Representa o inventário de uma entidade (jogador, baú). Ele não é o item, mas o contêiner dos itens.
*   **Exemplo de Código (`Scripts/Resources/InventoryData.gd`):**
    ```gdscript
    class_name InventoryData
    extends Resource

    # Um array que conterá outros Resources (ex: ItemData)
    @export var items: Array[Resource] = []
    @export var capacity: int = 20 # Número máximo de slots

    func add_item(item_data: Resource) -> bool:
        if items.size() < capacity:
            items.append(item_data)
            return true
        return false

    func remove_item(item_data: Resource):
        items.erase(item_data)
    ```
*   **Uso:** O jogador teria uma instância de `InventoryData.tres`. Quando ele coleta um item, o `ItemData` correspondente é adicionado ao array `items` do inventário.

### 5. `LootItemData`

*   **Propósito:** Define um item que pode ser coletado (loot). Pode ser usado em conjunto com `InventoryData`.
*   **Exemplo de Código (`Scripts/Resources/LootItemData.gd`):**
    ```gdscript
    class_name LootItemData
    extends Resource

    enum ItemType { CONSUMABLE, WEAPON, ARMOR, KEY }

    @export var item_name: String = "Poção"
    @export var item_type: ItemType = ItemType.CONSUMABLE
    @export_multiline var description: String
    @export var icon: Texture2D
    @export var stackable: bool = true
    ```
*   **Uso:** Um inimigo, ao morrer, poderia dropar uma cena de "item no chão" que contém uma referência a um `LootItemData.tres` (ex: `potion_of_health.tres`).

### 6. `LevelData`

*   **Propósito:** Armazena metadados sobre uma fase ou nível do jogo.
*   **Exemplo de Código (`Scripts/Resources/LevelData.gd`):**
    ```gdscript
    class_name LevelData
    extends Resource

    @export var level_name: String = "Floresta Sombria"
    @export var scene_path: String # Caminho para o arquivo .tscn da fase
    @export var music_track: AudioStream # Música de fundo para a fase
    @export var time_limit_seconds: int = 300
    ```
*   **Uso:** O `SceneManager` ou um menu de seleção de fases poderia usar `LevelData` para saber qual cena carregar e qual música tocar.

### 7. `DialogueData`

*   **Propósito:** Define uma sequência de diálogo para um NPC.
*   **Exemplo de Código (`Scripts/Resources/DialogueData.gd`):**
    ```gdscript
    class_name DialogueData
    extends Resource

    # Array de dicionários, cada um representando uma fala.
    # Ex: [{"character": "Herói", "text": "Olá!"}, {"character": "NPC", "text": "Bem-vindo."}]
    @export var dialogue_lines: Array[Dictionary] = []
    ```
*   **Uso:** Um NPC teria uma variável `@export var dialogue: DialogueData`. Ao interagir com ele, um sistema de UI de diálogo leria o `dialogue_lines` para exibir a conversa.

---
## Padrões Adicionais Avançados

### 8. `AbilityData`

*   **Propósito:** Define uma habilidade ou ataque especial, desacoplando a lógica da habilidade do personagem que a usa.
*   **Exemplo de Código (`Scripts/Resources/AbilityData.gd`):**
    ```gdscript
    class_name AbilityData
    extends Resource

    @export var ability_name: String = "Bola de Fogo"
    @export var damage: int = 25
    @export var mana_cost: int = 10
    @export var cooldown: float = 2.0 # Segundos
    @export var animation_name: StringName
    @export var vfx_scene: PackedScene # Efeito visual a ser instanciado
    ```
*   **Uso:** Um `AbilityComponent` no jogador ou inimigo leria uma lista de `AbilityData` e gerenciaria os cooldowns e custos de mana para executar as habilidades.

### 9. `StatusEffectData`

*   **Propósito:** Define um efeito de status (buff/debuff) que pode ser aplicado a uma entidade.
*   **Exemplo de Código (`Scripts/Resources/StatusEffectData.gd`):**
    ```gdscript
    class_name StatusEffectData
    extends Resource

    enum EffectType { BUFF, DEBUFF }
    enum StatModifier { SPEED, DAMAGE, DEFENSE }

    @export var effect_name: String = "Veneno"
    @export var effect_type: EffectType = EffectType.DEBUFF
    @export var duration: float = 5.0 # Segundos
    
    @export_group("Efeitos Contínuos")
    @export var damage_per_second: int = 2
    
    @export_group("Modificadores de Stats")
    @export var stat_to_modify: StatModifier
    @export var modifier_value: float = 0.8 # Ex: 0.8 para 20% de redução
    ```
*   **Uso:** Quando uma arma com "dano de veneno" atinge um inimigo, o inimigo recebe uma instância deste `Resource` e um `StatusEffectComponent` gerenciaria a aplicação do dano ao longo do tempo.

### 10. `ShopData`

*   **Propósito:** Define o inventário e os preços de uma loja ou vendedor.
*   **Exemplo de Código (`Scripts/Resources/ShopData.gd`):**
    ```gdscript
    class_name ShopData
    extends Resource

    # Dicionário onde a chave é o ItemData e o valor é o preço.
    # Ex: {load("res://Items/potion.tres"): 50}
    @export var items_for_sale: Dictionary = {}
    ```
*   **Uso:** Um NPC de vendedor teria uma variável `@export var shop_inventory: ShopData`. Ao interagir, uma UI de loja leria este `Resource` para popular a lista de itens à venda.

### 11. `QuestData`

*   **Propósito:** Define uma missão, incluindo seus objetivos, textos e recompensas.
*   **Exemplo de Código (`Scripts/Resources/QuestData.gd`):**
    ```gdscript
    class_name QuestData
    extends Resource

    enum QuestState { NOT_STARTED, IN_PROGRESS, COMPLETED }

    @export var quest_title: String = "Coletar Ervas"
    @export_multiline var description_start: String
    @export_multiline var description_in_progress: String
    @export_multiline var description_completed: String
    
    @export_group("Objetivos")
    @export var required_item: LootItemData
    @export var required_amount: int = 5
    
    @export_group("Recompensas")
    @export var reward_xp: int = 100
    @export var reward_gold: int = 50
    ```
*   **Uso:** Um `QuestManager` global rastrearia o estado de vários `QuestData.tres`, e os NPCs poderiam consultar este gerente para saber qual diálogo exibir (ex: "Você já coletou as 5 ervas?").

### 12. `FactionData`

*   **Propósito:** Gerencia as relações de alinhamento entre diferentes grupos de entidades (NPCs, inimigos, jogador). Permite criar sistemas de reputação e IAs que reagem de forma diferente a depender da facção.
*   **Exemplo de Código (`Scripts/Resources/FactionData.gd`):**
    ```gdscript
    class_name FactionData
    extends Resource

    enum Stance { HOSTILE, NEUTRAL, FRIENDLY }

    @export var faction_name: String = "Default"
    # Dicionário para armazenar a relação com outras facções.
    # A chave é o Resource FactionData da outra facção.
    # O valor é a Stance (HOSTILE, NEUTRAL, FRIENDLY).
    # Ex: {load("res://Resources/Factions/player_faction.tres"): Stance.FRIENDLY}
    @export var stances: Dictionary = {}
    ```
*   **Uso:** Cada entidade (jogador, inimigo) teria uma variável `@export var faction: FactionData`. Antes de atacar, a IA de um inimigo verificaria `self.faction.stances.get(player.faction)` para determinar se o jogador é um alvo hostil.

### 13. `CraftingRecipeData`

*   **Propósito:** Define uma receita para a criação de um novo item a partir de outros. Essencial para sistemas de crafting.
*   **Exemplo de Código (`Scripts/Resources/CraftingRecipeData.gd`):**
    ```gdscript
    class_name CraftingRecipeData
    extends Resource

    # Dicionário de ingredientes. Chave: LootItemData, Valor: quantidade.
    # Ex: {load("res://Resources/Items/wood.tres"): 5, load("res://Resources/Items/stone.tres"): 2}
    @export var ingredients: Dictionary = {}

    # O item resultante da receita.
    @export var output_item: LootItemData
    @export var output_quantity: int = 1
    ```
*   **Uso:** Uma UI de crafting leria uma lista de `CraftingRecipeData.tres`. Ao tentar criar um item, o sistema verificaria se o `InventoryData` do jogador contém os `ingredients` na quantidade necessária.

### 14. `SkillTreeData`

*   **Propósito:** Representa um único nó em uma árvore de talentos ou habilidades, definindo seu custo, pré-requisitos e o que ele desbloqueia.
*   **Exemplo de Código (`Scripts/Resources/SkillTreeData.gd`):**
    ```gdscript
    class_name SkillTreeData
    extends Resource

    @export var skill_name: String = "Nova Habilidade"
    @export_multiline var description: String
    @export var icon: Texture2D

    @export_group("Regras da Árvore")
    @export var skill_point_cost: int = 1
    # Array de outros SkillTreeData que são pré-requisitos para este.
    @export var prerequisites: Array[SkillTreeData] = []
    # A habilidade (AbilityData) que este nó desbloqueia, se houver.
    @export var unlocked_ability: AbilityData
    ```
*   **Uso:** Um sistema de árvore de habilidades leria todos os `SkillTreeData.tres` e os organizaria visualmente. Ele verificaria os `prerequisites` para determinar se um nó pode ser comprado.

### 15. `EnchantmentData`

*   **Propósito:** Define um encantamento mágico que pode ser aplicado a um item (arma, armadura) para conceder bônus ou efeitos especiais.
*   **Exemplo de Código (`Scripts/Resources/EnchantmentData.gd`):**
    ```gdscript
    class_name EnchantmentData
    extends Resource

    @export var enchantment_name: String = "Encantamento de Fogo"
    @export_multiline var description: String

    @export_group("Modificadores")
    # Um dicionário para modificadores de estatísticas genéricas.
    # Ex: {"damage": 5, "defense": 2}
    @export var stat_modifiers: Dictionary = {}

    # Efeito de status a ser aplicado (ex: veneno, queimadura).
    @export var status_effect: StatusEffectData
    @export var status_application_chance: float = 0.0 # Chance de 0.0 a 1.0
    ```
*   **Uso:** Um `WeaponData` ou `ArmorData` poderia ter uma variável `enchantment: EnchantmentData`. Ao calcular o dano de um ataque, o sistema somaria os `stat_modifiers` do encantamento da arma.

### 16. `ToolData`

*   **Propósito:** Define um item que é uma ferramenta, usada para interações específicas com o mundo (coleta, etc.), e não para combate. Herda de `LootItemData`.
*   **Exemplo de Código (`Scripts/Resources/ToolData.gd`):**
    ```gdscript
    class_name ToolData
    extends LootItemData # Herda de LootItemData para reusar propriedades base.

    enum ToolType { PICKAXE, AXE, FISHING_ROD, SHOVEL }

    @export var tool_type: ToolType
    @export var durability: int = 100
    @export var efficiency: float = 1.0 # Ex: 1.0 para velocidade normal de coleta.
    ```
*   **Uso:** Ao interagir com um nó de "minério", o jogo verificaria se o jogador tem um item equipado cujo `Resource` é um `ToolData` do tipo `PICKAXE`. A cada uso, a `durability` poderia ser reduzida.

### 17. `LootTableData`

*   **Propósito:** Define uma "tabela de loot" para gerenciar drops de itens com diferentes pesos e chances. Ideal para tornar as recompensas de inimigos e baús mais dinâmicas.
*   **Exemplo de Código (`Scripts/Resources/LootTableData.gd`):**
    ```gdscript
    class_name LootTableData
    extends Resource

    # Array de dicionários. Cada dicionário representa um item possível.
    # Ex: [{"item": LootItemData, "weight": 10, "min_quantity": 1, "max_quantity": 1}]
    # 'weight' é o peso da chance. Um item com peso 10 tem 10x mais chance de cair que um com peso 1.
    @export var possible_drops: Array[Dictionary] = []

    # Função para rolar a tabela e retornar o loot.
    func roll_loot() -> Array:
        var total_weight = 0
        for drop in possible_drops:
            total_weight += drop.get("weight", 0)

        var chosen_loot = []
        if total_weight <= 0:
            return chosen_loot

        var random_roll = randi_range(1, total_weight)
        var current_weight = 0
        for drop in possible_drops:
            current_weight += drop.get("weight", 0)
            if random_roll <= current_weight:
                var item_resource = drop.get("item")
                if item_resource:
                    var quantity = randi_range(drop.get("min_quantity", 1), drop.get("max_quantity", 1))
                    chosen_loot.append({"item": item_resource, "quantity": quantity})
                break # Para a tabela dropar apenas um tipo de item por rolagem. Remova se quiser múltiplos.
        
        return chosen_loot
    ```
*   **Uso:** Um `EnemyData` ou um nó de baú poderia ter uma variável `@export var loot_table: LootTableData`. Ao ser derrotado ou aberto, ele chamaria `loot_table.roll_loot()` para determinar qual item (ou itens) gerar.

### 18. `ArmorData`

*   **Propósito:** Define uma peça de armadura, com atributos específicos de defesa e resistências. Herda de `LootItemData`.
*   **Exemplo de Código (`Scripts/Resources/ArmorData.gd`):**
    ```gdscript
    class_name ArmorData
    extends LootItemData # Herda de LootItemData

    enum ArmorSlot { HEAD, CHEST, LEGS, FEET }

    @export var armor_slot: ArmorSlot
    
    @export_group("Atributos de Defesa")
    @export var defense_value: int = 5
    # Dicionário para resistências. Ex: {"fire_resistance": 0.2, "ice_resistance": -0.1}
    # Onde 0.2 é 20% de resistência e -0.1 é 10% de fraqueza.
    @export var resistance_modifiers: Dictionary = {}
    ```
*   **Uso:** Um sistema de inventário ou de personagem poderia ter slots de equipamento. Ao equipar um item cujo `Resource` é um `ArmorData`, o sistema somaria o `defense_value` e as `resistance_modifiers` aos status totais do jogador.

### 19. `BiomeData`

*   **Propósito:** Define as características de uma área ou região do mundo, como os inimigos que podem ser encontrados, os recursos disponíveis e a ambientação.
*   **Exemplo de Código (`Scripts/Resources/BiomeData.gd`):**
    ```gdscript
    class_name BiomeData
    extends Resource

    @export var biome_name: String = "Floresta"

    @export_group("Spawning")
    # Array de EnemyData que podem aparecer neste bioma.
    @export var possible_enemies: Array[EnemyData] = []
    # Array de LootItemData (recursos coletáveis) que podem ser encontrados.
    @export var possible_resources: Array[LootItemData] = []

    @export_group("Ambiente")
    @export var background_music: AudioStream
    # Poderia ser uma cena de efeito de clima (chuva, neve) a ser instanciada.
    @export var weather_effect_scene: PackedScene
    ```
*   **Uso:** Um `LevelData` ou um gerenciador de mundo poderia ter uma referência a um `BiomeData`. Ao gerar inimigos ou recursos de coleta, ele selecionaria aleatoriamente a partir das listas `possible_enemies` e `possible_resources`.

### 20. `CutsceneData`

*   **Propósito:** Define uma sequência de eventos para uma cena não-interativa (cutscene), permitindo orquestrar diálogos, animações e movimentos de câmera de forma estruturada.
*   **Exemplo de Código (`Scripts/Resources/CutsceneData.gd`):**
    ```gdscript
    class_name CutsceneData
    extends Resource

    # Um array de eventos que compõem a cutscene.
    # Cada evento é um dicionário que define a ação.
    # Ex: {"type": "dialogue", "data": DialogueData},
    #     {"type": "move_camera", "target_node": NodePath, "duration": 2.0},
    #     {"type": "play_animation", "target_node": NodePath, "animation_name": "victory"}
    @export var event_sequence: Array[Dictionary] = []
    ```
*   **Uso:** Um `CutsceneManager` receberia um `CutsceneData`. Ele leria o `event_sequence` passo a passo, executando cada evento em ordem: mostrando um diálogo, movendo a câmera, tocando uma animação em um personagem, etc.

### 21. `AIPersonalityData`

*   **Propósito:** Desacopla o *comportamento* de uma IA de suas *estatísticas*. Permite que diferentes inimigos compartilhem a mesma lógica de IA (ex: patrulha), mas com parâmetros diferentes, ou que um mesmo inimigo possa ter seu comportamento alterado dinamicamente.
*   **Exemplo de Código (`Scripts/Resources/AIPersonalityData.gd`):**
    ```gdscript
    class_name AIPersonalityData
    extends Resource

    enum Behavior {
        PATROL,  # Patrulha uma área definida
        GUARD,   # Fica parado em um ponto, mas persegue se avistar o jogador
        AGGRESSIVE, # Persegue o jogador ativamente
        COWARD    # Foge do jogador quando com vida baixa
    }

    @export var behavior_type: Behavior = Behavior.PATROL
    
    @export_group("Parâmetros de Comportamento")
    @export var patrol_path_node: NodePath # Para o comportamento de patrulha
    @export var coward_health_threshold: float = 0.2 # Percentual de vida para começar a fugir
    ```
*   **Uso:** Um script de IA genérico em um inimigo teria uma variável `@export var personality: AIPersonalityData`. No loop de física, ele usaria uma máquina de estados (`match personality.behavior_type:`) para executar a lógica correspondente, usando os parâmetros definidos no `Resource`.

### 22. `InteractableData`

*   **Propósito:** Define as propriedades de um objeto interativo no mundo, permitindo que um script genérico lide com diferentes tipos de interações (ler placas, abrir portas, puxar alavancas).
*   **Exemplo de Código (`Scripts/Resources/InteractableData.gd`):**
    ```gdscript
    class_name InteractableData
    extends Resource

    @export var interaction_prompt: String = "Interagir" # Ex: "Abrir Baú", "Ler Placa"
    
    @export_group("Eventos")
    # Sinal a ser emitido pelo objeto quando a interação for bem-sucedida.
    # Ex: "lever_pulled", "door_opened"
    @export var success_signal: StringName 
    # Animação a ser tocada no objeto durante a interação.
    @export var animation_name: StringName
    ```
*   **Uso:** Um nó `Area2D` em um objeto interativo detectaria o jogador. Ao pressionar o botão de ação, o script leria o `InteractableData`, mostraria o `interaction_prompt` na UI, tocaria a `animation_name` no objeto e emitiria o `success_signal`, que seria conectado a outro sistema (ex: um gerenciador de portas).

### 23. `PlayerProfileData`

*   **Propósito:** Armazena dados globais do jogador que persistem entre sessões e não estão ligados a um save de personagem específico, como conquistas, moeda premium e modos de jogo desbloqueados.
*   **Exemplo de Código (`Scripts/Resources/PlayerProfileData.gd`):**
    ```gdscript
    class_name PlayerProfileData
    extends Resource

    @export var player_name: String = "Player"
    @export var total_playtime_seconds: float = 0.0
    
    @export_group("Moedas")
    @export var shared_gold: int = 0 # Ouro compartilhado entre todos os saves
    @export var premium_currency: int = 0

    @export_group("Progresso Global")
    # Um dicionário para rastrear conquistas. Ex: {"first_quest_completed": true}
    @export var achievements: Dictionary = {}
    # Um array de strings para modos de jogo desbloqueados. Ex: ["new_game_plus"]
    @export var unlocked_game_modes: Array[String] = []
    ```
*   **Uso:** Este `Resource` seria salvo em um arquivo separado do save do jogo (ex: `user://profile.dat`). Ele seria carregado no início do jogo para verificar conquistas, popular a loja de moeda premium e determinar quais opções do menu principal estão disponíveis.
