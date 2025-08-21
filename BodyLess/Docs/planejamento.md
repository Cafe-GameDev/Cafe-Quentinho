# Plano de Desenvolvimento Completo: "Cafe-Quentinho Template"

Este documento detalha o plano de desenvolvimento para o projeto "Cafe-Quentinho Template", abrangendo a refatoração do sistema de configurações, a implementação de feedback de UI, a robusta internacionalização (I18N/L10N), e a adição de novas funcionalidades de jogo. O plano é dividido em fases principais, com um total de 50 passos.

---

## Fase 0: Análise Inicial e Preparação (Passos 0-2)

*   **Passo 0: Análise de Erros do Godot**
    *   **Ação:** Executar o Godot Engine no modo de importação e com logs detalhados para identificar quaisquer erros ou avisos existentes no projeto.
    *   **Comando:** `C:/Users/bruno/Documents/Godot_v4.4.1-stable_win64_console.exe --import --verbose --path C:/Users/bruno/Desktop/Cafe-Quentinho/BodyLess` (para importação inicial) e `C:/Users/bruno/Documents/Godot_v4.4.1-stable_win64_console.exe --quit --verbose --path C:/Users/bruno/Desktop/Cafe-Quentinho/BodyLess` (para verificação de console).
    *   **Justificativa:** Garantir que o ambiente de desenvolvimento esteja limpo e sem problemas de importação antes de iniciar novas implementações.

*   **Passo 1: Análise Abrangente do Projeto Existente**
    *   **Ação:** Revisar a estrutura de pastas (`BodyLess/`, `HeadLess/`, `Platformer/`, `TopDown/`), ler os arquivos `project.godot` de cada template para entender as configurações atuais, e revisar os scripts existentes em `BodyLess/Autoloads/` e `BodyLess/Scripts/` para compreender a arquitetura atual e identificar pontos de refatoração/extensão. Fazer buscas por padrões de código relevantes (ex: `get_node`, `connect`, `emit_signal`) para entender o acoplamento.
    *   **Justificativa:** Obter uma compreensão profunda do estado atual do projeto para planejar as mudanças de forma eficaz e aderir às convenções existentes.

*   **Passo 2: Pesquisa e Definição de Conceitos (Handlers, Tooltips, etc.)**
    *   **Ação:** Realizar pesquisas sobre "Godot Handler pattern", "Godot Tooltip implementation", "Godot Popover", "Godot Toast" e "Godot Coach Marks" para consolidar o conhecimento. Definir claramente o que são esses conceitos no contexto do Godot e como serão aplicados no projeto.
    *   **Justificativa:** Assegurar uma base teórica sólida para a implementação de sistemas complexos e garantir a consistência arquitetural.

---

## Fase 1: Documentação e Planejamento Geral (Passos 3-10)

*   **Passo 3: Criação do `planejamento.md` (Este Arquivo)**
    *   **Ação:** Criar este arquivo `BodyLess/Docs/planejamento.md` e estruturá-lo com as fases e passos detalhados deste plano, incluindo os 50 passos solicitados.
    *   **Justificativa:** Fornecer um roteiro claro e abrangente para o desenvolvimento do projeto, servindo como a "blueprint" principal.

*   **Passo 4: Criação do GDD Geral do Projeto (`GDD_Geral.md`)**
    *   **Ação:** Criar o arquivo `BodyLess/Docs/GDD_Geral.md`. Este documento definirá a visão geral do jogo, público-alvo, mecânicas centrais (comuns a todos os modos), diretrizes de arte, som, e a filosofia de design "BodyLess" com o uso do EventBus como pilar central.
    *   **Justificativa:** Estabelecer a base conceitual e arquitetural para todo o projeto, garantindo alinhamento e consistência.

*   **Passo 5: Criação do GDD para o Modo TopDown (`GDD_TopDown.md`)**
    *   **Ação:** Criar o arquivo `BodyLess/Docs/GDD_TopDown.md`. Detalhar as mecânicas específicas do modo TopDown (movimento, combate, interação com o ambiente), listar exemplos de itens, armas e inimigos específicos para este modo, e descrever a construção de cenários.
    *   **Justificativa:** Fornecer um guia detalhado para o desenvolvimento do modo de jogo TopDown.

*   **Passo 6: Criação do GDD para o Modo Platformer (`GDD_Platformer.md`)**
    *   **Ação:** Criar o arquivo `BodyLess/Docs/GDD_Platformer.md`. Detalhar as mecânicas específicas do modo Platformer (pulo, plataformas, física, inimigos, itens), listar exemplos de itens, armas e inimigos específicos para este modo, e descrever a construção de cenários.
    *   **Justificativa:** Fornecer um guia detalhado para o desenvolvimento do modo de jogo Platformer.

*   **Passo 7: Criação do GDD para o Modo 3D (`GDD_3D.md`)**
    *   **Ação:** Criar o arquivo `BodyLess/Docs/GDD_3D.md`. Detalhar as mecânicas específicas do modo 3D (movimento, combate, interação com o ambiente, física 3D), explicar os dois modos de visão (primeira e terceira pessoa) e como serão implementados, listar exemplos de itens, armas e inimigos específicos para este modo, e descrever a construção de cenários.
    *   **Justificativa:** Fornecer um guia detalhado para o desenvolvimento do modo de jogo 3D, considerando suas complexidades adicionais.

*   **Passo 8: Documentação de Handlers (`Handlers.md`)**
    *   **Ação:** Criar `BodyLess/Docs/Handlers.md`. Este documento explicará o conceito de "Handler" no Godot (classes que reagem a eventos e orquestram lógica), fornecerá exemplos de implementação e indicará onde podem ser usados (ex: `InputHandler` para processar inputs brutos e emitir intenções, `CombatHandler` para gerenciar a lógica de combate).
    *   **Justificativa:** Padronizar a implementação de lógicas complexas e desacopladas.

*   **Passo 9: Documentação de Sistemas de Feedback de UI (`UI_Feedback_Systems.md`)**
    *   **Ação:** Criar `BodyLess/Docs/UI_Feedback_Systems.md`. Este documento detalhará Tooltips, Popovers, Toasts e Coach Marks: seu propósito, como serão implementados (estrutura de cena, scripts, managers), e como se comunicarão via EventBus.
    *   **Justificativa:** Garantir uma experiência de usuário consistente e informativa através de feedback visual e interativo.

*   **Passo 10: Documentação de Internacionalização (Atualização)**
    *   **Ação:** Atualizar `BodyLess/Docs/I18N_Documentation.md` para incluir as novas chaves de tradução para tooltips, nomes e descrições de itens, armas e inimigos. Reforçar a importância de todas as chaves estarem presentes em todos os arquivos `.po` para garantir a completude das traduções.
    *   **Justificativa:** Manter a documentação de I18N atualizada com as novas necessidades do projeto.

---

## Fase 2: Sistemas Gerais e Recursos (Passos 11-20)

*   **Passo 11: Refatoração do `GlobalEvents` (Revisão)**
    *   **Ação:** Garantir que o `BodyLess/Autoloads/EventBus/global_events.gd` contenha apenas os sinais unificados de configurações (`setting_changed`, `loading_settings_changed`, `request_setting_changed`, `request_loading_settings_changed`) e os novos sinais para os sistemas de jogo (inventário, save, etc.) que serão definidos nos próximos passos.
    *   **Justificativa:** Manter o EventBus limpo e focado em comunicação de alto nível.

*   **Passo 12: Planejamento e Implementação do `SaveSystem`**
    *   **Ação:** Modificar `BodyLess/Autoloads/save_system.gd`.
        *   Definir a estrutura de salvamento para 3 sessões distintas (uma para cada modo de jogo: TopDown, Platformer, 3D).
        *   Planejar o salvamento do Player em um `Dictionary` próprio, abrangente e exato (ex: `player_data: Dictionary = {"position": Vector3(), "health": 100, "inventory": {}, "current_weapon": ""}`).
        *   Decidir a estratégia de salvamento para outros elementos: agrupar por tipo (ex: `enemies_data: Dictionary`, `items_on_ground_data: Dictionary`) em um único arquivo de save por sessão, ou em pequenos grupos de arquivos (decisão: agrupar por tipo em um único arquivo por sessão para simplificar o gerenciamento).
        *   Definir os sinais de requisição e notificação de save/load via `GlobalEvents` (ex: `request_save_game(session_id: int)`, `game_saved(session_id: int)`, `request_load_game(session_id: int)`, `game_loaded(session_id: int, game_data: Dictionary)`).
    *   **Justificativa:** Criar um sistema de salvamento robusto e flexível que suporte múltiplos modos de jogo e organize os dados de forma eficiente.

*   **Passo 13: Planejamento e Criação do `InventoryManager` (Autoload)**
    *   **Ação:** Criar `BodyLess/Autoloads/inventory_manager.gd`. Este manager gerenciará o inventário do jogador, utilizando um `Dictionary` para representar os slots e referências a `Resource`s de itens.
    *   **Sinais:** Definir sinais via `GlobalEvents` para adicionar/remover itens (`item_added(item_data: Dictionary)`, `item_removed(item_id: String)`), usar itens (`item_used(item_id: String)`), etc.
    *   **Justificativa:** Centralizar a lógica do inventário e permitir que outros sistemas interajam com ele de forma desacoplada.

*   **Passo 14: Planejamento e Criação dos Recursos de Itens (`Resource`s)**
    *   **Ação:**
        *   Criar `BodyLess/Resources/Scripts/ItemData.gd` (extends Resource) com propriedades gerais como `id: String`, `name_key: String` (para tradução), `description_key: String` (para tradução), `icon_path: String`, `item_type: String` (ex: "consumable", "weapon").
        *   Criar `BodyLess/Resources/Scripts/HealingPotionData.gd` (extends ItemData) com propriedades específicas como `heal_amount: float`.
        *   Criar `BodyLess/Resources/Scripts/DamageBoostPotionData.gd` (extends ItemData) com propriedades específicas como `boost_value: float`, `duration: float`.
        *   Criar `.tres` para cada item (ex: `HealingPotion.tres`, `DamageBoostPotion.tres`) baseados nos scripts de `Resource` correspondentes.
        *   **I18N:** Adicionar chaves de tradução para os nomes e descrições de todos os itens nos arquivos `.po`.
    *   **Justificativa:** Modularizar os dados dos itens, facilitando a criação, balanceamento e tradução.

*   **Passo 15: Planejamento e Criação dos Recursos de Armas (`Resource`s)**
    *   **Ação:**
        *   Revisar `BodyLess/Resources/Scripts/WeaponData.gd` (extends ItemData) com propriedades como `damage: float`, `range: float`, `attack_type: String` (ex: "melee", "ranged"), `reload_time: float`, `ammo_capacity: int`, `ammo_type: String`.
        *   Criar `.tres` para cada arma (ex: `Punch.tres`, `Sword.tres`, `Bow.tres`, `Pistol.tres`, `Grenade.tres`, `MachineGun.tres`) baseados em `WeaponData.gd`.
        *   **I18N:** Adicionar chaves de tradução para os nomes e descrições de todas as armas nos arquivos `.po`.
    *   **Justificativa:** Padronizar e modularizar os dados das armas.

*   **Passo 16: Planejamento e Criação dos Recursos de Inimigos (`Resource`s)**
    *   **Ação:**
        *   Revisar `BodyLess/Resources/Scripts/EnemyData.gd` (extends Resource) com propriedades como `health: float`, `damage: float`, `speed: float`, `behavior_type: String` (ex: "static", "patrol", "fsm"), `loot_table_id: String`.
        *   Criar `.tres` para cada inimigo (ex: `DummyData.tres`, `PatrolBotData.tres`, `HunterData.tres`) baseados em `EnemyData.gd`.
        *   **I18N:** Adicionar chaves de tradução para os nomes e descrições de todos os inimigos nos arquivos `.po`.
    *   **Justificativa:** Modularizar os dados dos inimigos para fácil criação e balanceamento.

*   **Passo 17: Planejamento e Adaptação do `InputManager` (Mapeamento de Teclas)**
    *   **Ação:** Revisar `BodyLess/Autoloads/input_manager.gd`.
        *   Implementar o mapeamento de teclas solicitado: `E` para inventário, `R` para recarregar a arma, `Q` para uma habilidade especial, `Ctrl` para correr, `Shift` para abaixar (apenas no modo 3D).
        *   Garantir suporte a gamepad e navegação de menu via setas e outros botões do teclado.
        *   Emitir sinais de intenção via `GlobalEvents` (ex: `input_inventory_pressed`, `input_reload_pressed`, `input_special_pressed`, `input_sprint_toggled`, `input_crouch_toggled`).
    *   **Justificativa:** Centralizar o gerenciamento de inputs e fornecer uma interface de intenção desacoplada.

*   **Passo 18: Planejamento e Criação da HUD Universal**
    *   **Ação:** Criar `BodyLess/Scenes/UI/HUD.tscn` (CanvasLayer) e `BodyLess/Scripts/UI/HUD.gd`.
        *   Incluir elementos como barra de vida (conectada a `GlobalMachine` ou `PlayerState`), hotbar de inventário (conectada a `InventoryManager`), e espaço para tooltips.
        *   Implementar a lógica de atualização visual e troca de armas na hotbar.
    *   **Justificativa:** Fornecer uma interface de usuário em jogo consistente e desacoplada para todos os modos de jogo.

*   **Passo 19: Planejamento e Criação do `TooltipManager` (Autoload)**
    *   **Ação:** Criar `BodyLess/Autoloads/tooltip_manager.gd`. Este manager gerenciará a exibição e ocultação de tooltips.
    *   **Cena Base:** Criar `BodyLess/Scenes/UI/Components/Tooltip.tscn` (um `PanelContainer` com um `Label` para o texto).
    *   **Sinais:** Ouvir `GlobalEvents.show_tooltip_requested(text_key: String, position: Vector2, optional_args: Dictionary)` e `GlobalEvents.hide_tooltip_requested()`.
    *   **Justificativa:** Fornecer um sistema centralizado e desacoplado para exibir dicas informativas.

*   **Passo 20: Planejamento e Criação de Outros Sistemas de Feedback de UI (Popovers, Toasts, Coach Marks)**
    *   **Ação:**
        *   Revisar/Criar `BodyLess/Autoloads/popover_manager.gd`, `BodyLess/Autoloads/toast_manager.gd`, `BodyLess/Autoloads/tutorial_manager.gd`.
        *   Garantir que as cenas base (`BodyLess/Scenes/UI/Components/Popover.tscn`, `BodyLess/Scenes/UI/Components/Toast.tscn`, `BodyLess/Scenes/UI/Components/CoachMark.tscn`) e seus scripts estejam bem definidos e se comuniquem via EventBus.
        *   **I18N:** Adicionar chaves de tradução para todas as mensagens de popovers, toasts e coach marks.
    *   **Justificativa:** Melhorar a comunicação com o jogador através de diferentes tipos de feedback visual.

---

## Fase 3: Implementação dos Modos de Jogo (Passos 21-35)

*   **Passo 21: Estrutura de Pastas para Cenas de Jogo**
    *   **Ação:** Criar as seguintes pastas para organizar as cenas de cada modo de jogo:
        *   `BodyLess/Scenes/Game/TopDown/`
        *   `BodyLess/Scenes/Game/Platformer/`
        *   `BodyLess/Scenes/Game/3D/`
    *   **Justificativa:** Manter a organização do projeto e facilitar a navegação.

*   **Passo 22: Cena TopDown Playground (Criação)**
    *   **Ação:** Criar `BodyLess/Scenes/Game/TopDown/TopDown_Playground.tscn` (Node2D) com um `TileMap` para o ambiente.
    *   **Player:** Instanciar `BodyLess/Scenes/Player/Player_TopDown.tscn` (CharacterBody2D) com `AnimatedSprite2D` e `Camera2D` (com smoothing e limites).
    *   **Inimigo Base:** Instanciar `BodyLess/Scenes/Enemy/Enemy_TopDown.tscn` (CharacterBody2D/StaticBody2D).
    *   **Itens:** Instanciar `BodyLess/Scenes/Items/WeaponPickup_TopDown.tscn` e `BodyLess/Scenes/Items/HealingPotion_TopDown.tscn` (Area2D).
    *   **Justificativa:** Criar um ambiente de teste funcional para as mecânicas do modo TopDown.

*   **Passo 23: Lógica do Player TopDown**
    *   **Ação:** Criar `BodyLess/Scripts/Player/player_topdown.gd`. Implementar lógica de movimento (8 direções), ataque, interação com itens (coleta, uso), e integração com o `InventoryManager`. Conectar-se aos sinais de input do `InputManager`.
    *   **Justificativa:** Definir o comportamento do jogador no modo TopDown.

*   **Passo 24: Lógica do Inimigo TopDown**
    *   **Ação:** Criar `BodyLess/Scripts/Enemy/enemy_topdown.gd`. Implementar IA básica (patrulha de caminho, perseguição simples ao jogador). Utilizar o `EnemyData` resource para definir atributos e comportamentos.
    *   **Justificativa:** Definir o comportamento dos inimigos no modo TopDown.

*   **Passos 25-27: Cena e Lógica do Modo Platformer (15 passos para cada modo de jogo, então 3 passos aqui)**
    *   **Passo 25: Cena Platformer Playground (Criação)**
        *   **Ação:** Criar `BodyLess/Scenes/Game/Platformer/Platformer_Playground.tscn` (Node2D) com um `TileMap` para plataformas e obstáculos.
        *   **Player:** Instanciar `BodyLess/Scenes/Player/Player_Platformer.tscn` (CharacterBody2D) com `AnimatedSprite2D` e `Camera2D` (com smoothing e limites).
        *   **Inimigo Base:** Instanciar `BodyLess/Scenes/Enemy/Enemy_Platformer.tscn` (CharacterBody2D/StaticBody2D).
        *   **Itens:** Instanciar `BodyLess/Scenes/Items/WeaponPickup_Platformer.tscn` e `BodyLess/Scenes/Items/HealingPotion_Platformer.tscn` (Area2D).
        *   **Justificativa:** Criar um ambiente de teste funcional para as mecânicas do modo Platformer.
    *   **Passo 26: Lógica do Player Platformer**
        *   **Ação:** Criar `BodyLess/Scripts/Player/player_platformer.gd`. Implementar lógica de movimento (esquerda/direita), pulo (com diferentes alturas/velocidades), ataque, interação com itens, e integração com o `InventoryManager`. Conectar-se aos sinais de input do `InputManager`.
        *   **Justificativa:** Definir o comportamento do jogador no modo Platformer.
    *   **Passo 27: Lógica do Inimigo Platformer**
        *   **Ação:** Criar `BodyLess/Scripts/Enemy/enemy_platformer.gd`. Implementar IA básica (patrulha de plataforma, detecção de bordas, perseguição simples). Utilizar o `EnemyData` resource.
        *   **Justificativa:** Definir o comportamento dos inimigos no modo Platformer.

*   **Passos 28-35: Cena e Lógica do Modo 3D (8 passos aqui, para cobrir primeira e terceira pessoa)**
    *   **Passo 28: Cena 3D Playground (Criação)**
        *   **Ação:** Criar `BodyLess/Scenes/Game/3D/3D_Playground.tscn` (Node3D) com `MeshInstance3D` e `StaticBody3D` para o ambiente.
        *   **Player:** Instanciar `BodyLess/Scenes/Player/Player_3D.tscn` (CharacterBody3D) com `MeshInstance3D` e `Camera3D`.
        *   **Inimigo Base:** Instanciar `BodyLess/Scenes/Enemy/Enemy_3D.tscn` (CharacterBody3D/StaticBody3D).
        *   **Itens:** Instanciar `BodyLess/Scenes/Items/WeaponPickup_3D.tscn` e `BodyLess/Scenes/Items/HealingPotion_3D.tscn` (Area3D).
        *   **Justificativa:** Criar um ambiente de teste funcional para as mecânicas do modo 3D.
    *   **Passo 29: Lógica do Player 3D (Primeira Pessoa)**
        *   **Ação:** Criar `BodyLess/Scripts/Player/player_3d_first_person.gd`. Implementar movimento (WASD), rotação da câmera com o mouse, ataque, interação com itens, uso de inventário. Conectar-se aos sinais de input do `InputManager`.
        *   **Justificativa:** Definir o comportamento do jogador em primeira pessoa no modo 3D.
    *   **Passo 30: Lógica do Player 3D (Terceira Pessoa)**
        *   **Ação:** Criar `BodyLess/Scripts/Player/player_3d_third_person.gd`. Implementar movimento (WASD), câmera seguindo o jogador com rotação controlada pelo mouse, ataque, interação com itens, uso de inventário. Conectar-se aos sinais de input do `InputManager`.
        *   **Justificativa:** Definir o comportamento do jogador em terceira pessoa no modo 3D.
    *   **Passo 31: Lógica do Inimigo 3D**
        *   **Ação:** Criar `BodyLess/Scripts/Enemy/enemy_3d.gd`. Implementar IA básica (patrulha, perseguição, ataque). Utilizar o `EnemyData` resource.
        *   **Justificativa:** Definir o comportamento dos inimigos no modo 3D.
    *   **Passo 32: Implementação do Sistema de Spawner e Grupos**
        *   **Ação:** Criar `BodyLess/Scenes/Game/Spawner.tscn` (Node2D para 2D, Node3D para 3D) e seu script. Adicionar lógica para instanciar inimigos em pontos de spawn definidos e adicioná-los ao grupo "enemies".
        *   **Justificativa:** Gerenciar a criação e o ciclo de vida de inimigos e outros objetos no nível.
    *   **Passo 33: Implementação do Polimento e "Juice" (Geral)**
        *   **Ação:** Implementar Áudio Espacial (`AudioListener2D/3D` na câmera, `AudioStreamPlayer2D/3D` para SFX posicionais), Efeitos Visuais (`HitEffect.tscn` com `GPUParticles2D/3D` e som), Camera Shake (função `camera_shake` no script da câmera, chamada via sinal), e configurar `AnimationTree` nos Players para gerenciar animações.
        *   **Justificativa:** Melhorar a experiência do jogador com feedback visual e auditivo.
    *   **Passo 34: Testes Automatizados e Manuais (Modos de Jogo)**
        *   **Ação:** Criar e executar testes automatizados para cada modo de jogo, verificando mecânicas de movimento, inventário, combate e interações. Definir instruções claras para testes manuais.
        *   **Justificativa:** Garantir a funcionalidade e estabilidade de cada modo de jogo.
    *   **Passo 35: Otimização de Performance (Inicial)**
        *   **Ação:** Identificar gargalos de performance iniciais (CPU, GPU, memória) nos modos de jogo. Aplicar otimizações básicas como pooling de objetos para inimigos/projéteis e otimização de shaders simples.
        *   **Justificativa:** Assegurar que o jogo rode suavemente em diversas configurações de hardware desde o início.

---

## Fase 4: Refinamento e Finalização (Passos 36-50)

*   **Passo 36: Refinamento do SaveSystem**
    *   **Ação:** Implementar a lógica completa de salvamento e carregamento para as 3 sessões. Garantir que o `player_data` `Dictionary` seja salvo e carregado corretamente. Finalizar a estratégia de salvamento para outros elementos, garantindo que os dados sejam persistidos e recuperados de forma consistente.
    *   **Justificativa:** Assegurar a persistência do progresso do jogador em todos os modos de jogo.

*   **Passo 37: Refinamento da Internacionalização (I18N)**
    *   **Ação:** Revisar todas as chaves de tradução, garantindo que nomes e descrições de itens, armas e inimigos estejam traduzidos corretamente em todos os idiomas suportados. Testar a exibição de tooltips e outros elementos de UI em diferentes idiomas para verificar o layout e a legibilidade.
    *   **Justificativa:** Garantir uma experiência de usuário globalmente acessível e de alta qualidade.

*   **Passo 38: Refinamento dos Sistemas de Feedback de UI**
    *   **Ação:** Polir a aparência e as animações de Tooltips, Popovers, Toasts e Coach Marks. Garantir que a comunicação via EventBus seja fluida e que esses sistemas não interfiram na jogabilidade.
    *   **Justificativa:** Aprimorar a clareza e a estética da interface do usuário.

*   **Passo 39: Refinamento do Mapeamento de Teclas e Navegação de Menu**
    *   **Ação:** Testar exaustivamente o mapeamento de teclas e a navegação de menu com teclado e gamepad em todos os modos de jogo e menus. Ajustar a sensibilidade e a resposta conforme necessário.
    *   **Justificativa:** Garantir uma experiência de controle intuitiva e responsiva.

*   **Passo 40: Refinamento da HUD Universal**
    *   **Ação:** Ajustar o layout da HUD para diferentes proporções de tela, garantir a responsividade dos elementos e a integração perfeita com os sistemas de jogo (vida, munição, inventário).
    *   **Justificativa:** Otimizar a interface de usuário em jogo para clareza e usabilidade.

*   **Passo 41: Refinamento da IA dos Inimigos**
    *   **Ação:** Melhorar a inteligência artificial dos inimigos em cada modo de jogo, adicionando mais comportamentos, estados e interações com o ambiente.
    *   **Justificativa:** Aumentar o desafio e a imersão do combate.

*   **Passo 42: Refinamento dos Recursos (Itens, Armas, Inimigos)**
    *   **Ação:** Revisar e balancear as propriedades de todos os `Resource`s (itens, armas, inimigos) para garantir uma progressão de jogo justa e divertida.
    *   **Justificativa:** Assegurar o equilíbrio do jogo e a relevância dos elementos.

*   **Passo 43: Refinamento do Polimento e "Juice" (Avançado)**
    *   **Ação:** Adicionar mais efeitos visuais e sonoros, aprimorar animações, e refinar o feedback tátil para melhorar a sensação de "juice" do jogo.
    *   **Justificativa:** Elevar a qualidade percebida e a imersão do jogador.

*   **Passo 44: Otimização de Performance (Avançada)**
    *   **Ação:** Realizar otimizações mais profundas, se necessário, como otimização de shaders, LOD (Level of Detail) para modelos 3D, e culling de objetos.
    *   **Justificativa:** Garantir que o jogo mantenha uma alta taxa de quadros em diversas configurações de hardware.

*   **Passo 45: Acessibilidade (Implementação)**
    *   **Ação:** Implementar as opções de acessibilidade planejadas, como legendas configuráveis, remapeamento completo de controles, e modos daltônicos.
    *   **Justificativa:** Tornar o jogo acessível a um público mais amplo.

*   **Passo 46: Build e Distribuição (Testes Finais)**
    *   **Ação:** Configurar e testar a exportação do jogo para as plataformas alvo (PC, Web, Mobile, etc.). Realizar testes de build e distribuição em diferentes ambientes para garantir a compatibilidade.
    *   **Justificativa:** Preparar o jogo para o lançamento.

*   **Passo 47: Documentação Final (Revisão Geral)**
    *   **Ação:** Revisar todos os documentos criados (`planejamento.md`, GDDs, `Handlers.md`, `UI_Feedback_Systems.md`, `I18N_Documentation.md`) para garantir clareza, completude, consistência e aderência aos padrões do projeto.
    *   **Justificativa:** Fornecer uma base de conhecimento sólida para futuras manutenções e expansões.

*   **Passo 48: Testes de Regressão**
    *   **Ação:** Executar todos os testes automatizados e manuais para garantir que nenhuma funcionalidade existente foi quebrada durante o desenvolvimento das novas features.
    *   **Justificativa:** Assegurar a estabilidade do projeto.

*   **Passo 49: Revisão de Código e Padrões**
    *   **Ação:** Realizar uma revisão final do código para garantir que ele siga as convenções do projeto, os princípios de desacoplamento (especialmente o uso do EventBus e Dictionaries), e as boas práticas de GDScript.
    *   **Justificativa:** Manter a qualidade e a manutenibilidade do código.

*   **Passo 50: Entrega e Feedback**
    *   **Ação:** Preparar o projeto para a entrega final e solicitar feedback detalhado do usuário sobre a implementação e a documentação.
    *   **Justificativa:** Concluir o ciclo de desenvolvimento e garantir a satisfação do usuário.
