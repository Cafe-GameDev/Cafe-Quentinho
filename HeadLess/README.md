# Template "HeadLess" - Café Quentinho

O "HeadLess" é um kit de desenvolvimento e template de fundação "sem corpo" para a Godot Engine. Seu propósito não é ser um jogo, mas sim fornecer uma arquitetura de sistemas essenciais, robusta e escalável, que sirva como o ponto de partida definitivo para novos projetos. Ele foi concebido para resolver o problema comum de desenvolvedores que negligenciam ou adiam a implementação de sistemas cruciais, permitindo que as equipes de desenvolvimento foquem no que realmente importa: a criação da lógica e conteúdo do jogo (o "corpo").

Ele serve como base para outros templates do ecossistema "Café Quentinho", como o `TopDown` e o `Platformer`, e também é projetado para ser facilmente acoplado a projetos já existentes.

## Pilares da Arquitetura

A filosofia do template se baseia em quatro pilares fundamentais:

*   **Desacoplamento Total (Event-Driven):** A comunicação entre os sistemas principais é feita exclusivamente através de um "Barramento de Eventos" (`GlobalEvents`). Nenhum manager tem conhecimento direto sobre o outro, permitindo modificações e substituições sem quebrar o projeto.
*   **Modularidade e Responsabilidade Única:** Cada sistema principal é um Singleton (Autoload) com uma responsabilidade claramente definida, resultando em código limpo e fácil de manter.
*   **Orientado a Dados:** Separação entre lógica e dados, incentivando o uso de `Resources` e carregamento dinâmico de assets.
*   **Pronto para Produção:** Funcionalidades essenciais para um jogo completo já vêm pré-configuradas.

## Funcionalidades Principais

O template oferece os seguintes sistemas pré-configurados, com foco em eficiência e boas práticas:

### Singletons (Autoloads)

*   **`GlobalEvents` (Event Bus):**
    *   **Propósito:** O coração da comunicação desacoplada.
    *   **Eficiência:** Contém exclusivamente declarações de `signal`, atuando como um quadro de avisos central e passivo para eventos globais. Isso garante que os sistemas se comuniquem sem conhecer uns aos outros, promovendo um desacoplamento extremo, alta modularidade, testabilidade e escalabilidade.
*   **`GameManager`:**
    *   **Propósito:** Gerenciar o estado global do jogo.
    *   **Eficiência:** Implementa uma Máquina de Estados Finitos (FSM) simples (`MENU`, `PLAYING`, `PAUSED`, `SETTINGS`, `QUIT_CONFIRMATION`), centralizando a lógica de pausa e o fluxo geral do jogo. Isso evita lógica de estado espalhada e facilita a transição entre diferentes modos de jogo.
*   **`SceneManager`:**
    *   **Propósito:** Gerenciar o carregamento, descarregamento e transições de cenas de forma eficiente e controlada.
    *   **Eficiência:**
        *   **Sistema de Pilha (`push`/`pop`):** Utiliza uma pilha (`_scene_stack`) para gerenciar as cenas carregadas. Isso permite um fluxo de cena intuitivo (ex: `push` para abrir um menu sobre o jogo, `pop` para retornar), otimizando o uso de memória ao liberar cenas da árvore (`queue_free`) quando não são mais necessárias.
        *   **Renderização em `SubViewport`:** Todas as cenas do jogo (menus, o mundo do jogo) são renderizadas *dentro* de um `SubViewport` filho do `SceneManager`. Isso é crucial para:
            *   **Desacoplamento de Resolução:** Permite que a resolução de renderização do jogo seja diferente da resolução da janela. Você pode renderizar o jogo a uma resolução menor (ex: 720p) para otimizar a performance (especialmente útil para pixel art ou jogos 3D em hardware mais fraco) e deixar a Godot escalar a textura do `SubViewport` para a resolução nativa do monitor do jogador (1080p, 4K), mantendo a UI principal (que estaria fora do `SubViewport`, em uma `CanvasLayer`) nítida na resolução nativa.
            *   **Efeitos de Pós-Processamento:** Facilita a aplicação de shaders de tela cheia e outros efeitos de pós-processamento ao jogo renderizado, sem afetar a UI.
*   **`AudioManager`:**
    *   **Propósito:** Centralizar o carregamento e a reprodução de música e efeitos sonoros (SFX).
    *   **Eficiência:**
        *   **Carregamento Dinâmico:** Varre recursivamente o diretório `res://Assets/Audio/` usando `DirAccess` no `_ready()`, detectando e integrando automaticamente qualquer arquivo de áudio adicionado nas pastas corretas, sem a necessidade de modificar código.
        *   **Categorização Automática por Pastas:** A estrutura de pastas (`Assets/Audio/music/`, `Assets/Audio/interface/click/`) dita como os sons são categorizados em bibliotecas de música e SFX, gerando chaves de acesso automáticas (ex: `interface_click`).
        *   **Pool de `AudioStreamPlayer`s para SFX:** Cria um pool de 15 `AudioStreamPlayer`s por padrão, permitindo a reprodução de múltiplos SFX simultaneamente sem que um som corte o outro, otimizando o uso de recursos.
        *   **Sistema de Playlist de Música:** Gerencia uma playlist contínua, tocando faixas aleatórias da mesma categoria e trocando para uma playlist completamente nova a cada 5 minutos (via `Timer`), garantindo variedade sonora.
*   **`SettingsManager`:**
    *   **Propósito:** Gerenciar a persistência das configurações do jogo, aplicando-as em tempo real e oferecendo controle sobre o salvamento.
    *   **Eficiência:**
        *   **Persistência Robusta:** Salva e carrega as configurações do jogo em `user://settings.json`, um diretório seguro e compatível com todas as plataformas, garantindo que as preferências do jogador sejam mantidas entre as sessões.
        *   **Gerenciamento de Dois Estados (`_current_settings` vs. `_staged_settings`):** Implementa um sistema de configurações em duas etapas: `_staged_settings` (alterações na UI em tempo real) e `_current_settings` (configurações salvas e aplicadas). Isso permite "Aplicar" e "Descartar" mudanças, proporcionando uma experiência de usuário flexível e segura.
        *   **Aplicação Centralizada e Reativa:** Ouve sinais do `GlobalEvents` para atualizar `_staged_settings` e aplicar as mudanças em tempo real (ex: ajustando volume, modo de janela).
        *   **Notificação da UI:** Emite `GlobalEvents.settings_loaded` após carregar ou salvar, permitindo que os controles da UI se inicializem/atualizem automaticamente.
*   **`InputManager`:**
    *   **Propósito:** Traduzir input bruto em intenções de jogo.
    *   **Eficiência:** Captura inputs globais (ex: "pausar", "abrir console") usando `_unhandled_input` para priorizar a UI, e os traduz em sinais de "intenção" para o `GlobalEvents`, desacoplando a entrada física da ação do jogo.
*   **`DebugConsole`:**
    *   **Propósito:** Fornecer feedback visual para depuração em tempo real.
    *   **Eficiência:** Uma `CanvasLayer` que se conecta a **todos** os sinais do `GlobalEvents` e exibe um log formatado em tempo real, além de informações da máquina, acelerando drasticamente o processo de desenvolvimento e depuração.

### Estruturas de Dados Essenciais

*   **Hash Map (Dictionary):** Utilizado extensivamente em todo o projeto para organizar e gerenciar dados de forma flexível e eficiente. Exemplos incluem:
    *   Armazenamento de configurações no `SettingsManager`.
    *   Bibliotecas de áudio no `AudioManager` (mapeando chaves de som para arrays de `AudioStream`).
    *   Dados de save/load.
    *   Definição de receitas de crafting, tabelas de loot, atributos de personagens e inimigos em `Resources`.

### Sistema de UI Reativo

*   Cenas de UI (ex: `main_menu`, `pause_menu`, `settings_menu`) são "burras" por design. Elas apenas apresentam botões, emitem sinais de "requisição" para o `GlobalEvents` e reagem a sinais de mudança de estado (ex: `game_state_changed`) para controlar sua visibilidade.

### Internacionalização (I18N)

*   Estrutura completa para tradução usando arquivos `.po` na pasta `I18N/` e o `TranslationServer` da Godot. Textos na UI e em código usam chaves de tradução (ex: `UI_NEW_GAME`).

### Outros Recursos e Padrões

*   **`Resources` para Dados:** Uso extensivo de `Resources` (`.tres`) para separar dados da lógica (ex: `CharacterData`, `WeaponData`, `EnemyData`, `LootItemData`, `CraftingRecipeData`, `QuestData`, `BiomeData`, `AIPersonalityData`, `InteractableData`, `PlayerProfileData`, `SkillTreeData`, `EnchantmentData`, `ToolData`, `LootTableData`, `ArmorData`, `CutsceneData`).
*   **Sistema de Save/Load:** Utiliza `FileAccess` e `user://` para persistência de dados, com recomendação de `JSON` ou serialização binária e criptografia.
*   **Multiplayer (API de Alto Nível):** Suporte a `MultiplayerAPI`, `ENetMultiplayerPeer`, RPCs, `MultiplayerSpawner` e `MultiplayerSynchronizer`.
*   **Otimização de Performance:** Abordagens para otimização de CPU e GPU, incluindo multithreading.
*   **Multithreading:** Uso da classe `Thread` para executar tarefas pesadas em segundo plano, com comunicação segura via sinais e `call_deferred()`.
*   **Geração Procedural:** Uso de `TileMaps`, `ArrayMesh`, funções de ruído e `Resources` para criar conteúdo dinamicamente.
*   **Cutscenes:** Implementação via cenas dedicadas e `AnimationPlayer`.
*   **Splitscreen:** Uso de múltiplos `Viewport`s e `Camera`s para tela dividida.
*   **Pixel Art Configuration:** Configurações específicas para manter a nitidez da pixel art.
*   **Fórmulas de Salto Cinemático:** Abordagem baseada em design para calcular velocidade de pulo e gravidade.
*   **Tweens:** Uso de `Tween` para animações procedurais de propriedades.
*   **Addons:** Utilização de addons como GUT para testes unitários.
*   **Publicação e Exportação:** Diretrizes para exportação para Desktop, Web (HTML5), e a necessidade de parceiros de portabilidade para Consoles.
*   **Comando `cafe-new`:** Ferramenta de linha de comando para iniciar novos projetos a partir dos templates "HeadLess", "TopDown" e "Platformer".

---

## Erros Atuais e Desvios das Boas Práticas (Exemplo: `SettingsMenu`)

É crucial reconhecer que, apesar da arquitetura bem definida, o `SettingsMenu` atual apresenta um desvio significativo dos princípios de desacoplamento e responsabilidade única, tornando-o um "ninho de mafagafos" e dificultando a adaptação da interface.

**Problema Atual no `SettingsMenu` (`settings_menu.gd`):**

*   **Alto Acoplamento:** O script `settings_menu.gd` atualmente referencia diretamente **todos** os nós de controle de UI (sliders, option buttons, checkboxes) através de `@onready var` e conecta seus sinais nativos (`value_changed`, `item_selected`, `toggled`) diretamente a métodos dentro do próprio `settings_menu.gd`.
*   **Violação da Responsabilidade Única:** O `settings_menu.gd` não apenas gerencia a visibilidade dos painéis de categoria, mas também contém a lógica para:
    *   Popular as opções de cada controle (monitores, modos de janela, etc.).
    *   Emitir os sinais globais correspondentes a cada alteração de configuração.
    *   Atualizar a visibilidade de outros controles (ex: slider de escala de renderização).
    *   Inicializar os valores dos controles com base nas configurações carregadas.
*   **Dificuldade de Adaptação da UI:** Essa estrutura engessada significa que qualquer alteração no layout da UI (mover um slider, adicionar um novo botão, reorganizar painéis) exige modificações diretas no script `settings_menu.gd`. Isso é problemático para desenvolvedores que desejam adaptar a interface sem mergulhar na lógica interna do menu.
*   **Contraria o Princípio de UI "Burra":** O template prega que as cenas de UI devem ser "burras", apenas emitindo requisições e reagindo a sinais. O `settings_menu.gd` atual age como um "controlador" complexo, violando essa diretriz.

**Solução Proposta (Adesão às Boas Práticas):**

A refatoração proposta visa corrigir esses problemas, alinhando o `SettingsMenu` com os pilares do repositório:

*   **Cada Controle, Seu Script:** Cada botão, slider e checkbox de configuração terá seu próprio script GDScript dedicado (`Scripts/UI/Settings/Controls/*.gd`).
*   **Encapsulamento da Lógica do Controle:** A lógica de população de opções, a conexão do sinal nativo do controle e a emissão do sinal *global* correspondente para o `GlobalEvents` serão encapsuladas dentro do script de cada controle individual.
*   **UI "Burra" no `SettingsMenu`:** O `settings_menu.gd` será simplificado para apenas gerenciar a visibilidade dos painéis de categoria e os botões de ação (Aplicar, Voltar). Ele não terá conhecimento direto dos controles internos.
*   **Comunicação Exclusiva via EventBus:** Os controles individuais se comunicarão diretamente com o `GlobalEvents`, e o `SettingsManager` ouvirá esses sinais. O `SettingsMenu` não atuará como um intermediário de lógica para cada controle.
*   **Flexibilidade de Layout:** Ao desacoplar a lógica dos controles do script do menu, o usuário terá total liberdade para reorganizar, adicionar ou remover elementos da UI no `settings_menu.tscn` sem precisar alterar o código GDScript do menu principal, facilitando a adaptação da interface.
