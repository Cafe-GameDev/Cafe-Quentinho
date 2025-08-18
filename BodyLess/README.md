# Template "BodyLess" - Café Quentinho

O "BodyLess" é um kit de desenvolvimento e template de fundação "sem corpo" para a Godot Engine. Seu propósito não é ser um jogo, mas sim fornecer uma arquitetura de sistemas essenciais, robusta e escalável, que sirva como o ponto de partida definitivo para novos projetos. Ele foi concebido para resolver o problema comum de desenvolvedores que negligenciam ou adiam a implementação de sistemas cruciais, permitindo que as equipes de desenvolvimento foquem no que realmente importa: a criação da lógica e conteúdo do jogo (o "corpo").

Ele serve como base para outros templates do ecossistema "Café Quentinho", como o `TopDown` e o `Platformer`, e também é projetado para ser facilmente acoplado a projetos já existentes.

## Pilares da Arquitetura

A filosofia do template se baseia em quatro pilares fundamentais:

*   **Desacoplamento Total (Event-Driven):** A comunicação entre os sistemas principais é feita exclusivamente através de um "Barramento de Eventos" (`GlobalEvents`). Nenhum manager tem conhecimento direto sobre o outro, permitindo modificações e substituições sem quebrar o projeto.
*   **Modularidade e Responsabilidade Única:** Cada sistema principal é um Singleton (Autoload) com uma responsabilidade claramente definida, resultando em código limpo e fácil de manter.
<<<<<<< HEAD
*   **Orientado a Dados:** Separação entre lógica e dados, incentivando o uso de `Resources` e Dicionários para gerenciar o estado do jogo.
=======
*   **Orientado a Dados:** Separação entre lógica e dados, incentivando o uso de `Resources` e carregamento dinâmico de assets.
>>>>>>> ee7bc34fd3e892534753d4af6c060df0e4bb91c5
*   **Pronto para Produção:** Funcionalidades essenciais para um jogo completo já vêm pré-configuradas.

## Funcionalidades Principais

O template oferece os seguintes sistemas pré-configurados, com foco em eficiência e boas práticas:

<<<<<<< HEAD
### Singletons (Autoloads)

*   **`GlobalEvents` (Event Bus):**
    *   **Propósito:** O coração da comunicação desacoplada. Contém exclusivamente declarações de `signal`, atuando como um quadro de avisos central e passivo para eventos globais.
*   **`SceneManager`:**
    *   **Propósito:** Gerenciar o carregamento, descarregamento e transições de cenas de forma eficiente e controlada usando um sistema de pilha (`push`/`pop`).
*   **`AudioManager`:**
    *   **Propósito:** Centralizar o carregamento e a reprodução de música e efeitos sonoros (SFX).
    *   **Eficiência:** Carrega sons dinamicamente de pastas, os categoriza automaticamente e usa um pool de players para SFX, evitando que sons se cortem.
*   **`SettingsManager`:**
    *   **Propósito:** Gerenciar o estado das configurações do jogo (áudio, vídeo, etc.) em um dicionário. Ele aplica as configurações e reage a mudanças, mas não lida com salvamento/carregamento.
*   **`SaveSystem`:**
    *   **Propósito:** Único responsável por interagir com o sistema de arquivos. Ele salva e carrega dicionários de dados (como as configurações do `SettingsManager`) em formato JSON no diretório `user://`.
*   **`InputManager`:**
    *   **Propósito:** Traduzir input bruto (teclado, controle) em sinais de "intenção" para o `GlobalEvents`, desacoplando a entrada física da ação do jogo.
*   **`DebugConsole`:**
    *   **Propósito:** Fornecer feedback visual para depuração em tempo real, ouvindo todos os sinais do `GlobalEvents` e exibindo um log formatado.

### Sistema de UI Reativo

*   Cenas de UI (ex: `main_menu`, `pause_menu`, `settings_menu`) são "burras" por design. Elas apenas apresentam botões, emitem sinais de "requisição" para o `GlobalEvents` (ex: `scene_push_requested`) e reagem a sinais de mudança de estado para controlar sua visibilidade.

### Internacionalização (I18N)

*   Estrutura completa para tradução usando arquivos `.po`. Os textos na UI são definidos por chaves (ex: `UI_NEW_GAME`) diretamente no editor, permitindo que o `TranslationServer` do Godot os traduza automaticamente.

## Sugestões para Atualizações Futuras

*   **UI/UX (Mobile & Gamepad):** Adicionar HUDs para touch e gamepad, e garantir navegação completa dos menus via controle.
*   **Sistemas Essenciais:** Implementar remapeamento de inputs e um conjunto robusto de opções de acessibilidade (modos para daltônicos, legendas personalizáveis, etc.).
*   **Visuais:** Adicionar exemplos de partículas e shaders para demonstrar efeitos visuais.
=======
## Cena Principal
*   **`SceneManager`:**
    *   **Propósito:** Gerenciar o carregamento, descarregamento e transições de cenas de forma eficiente e controlada.
    *   **Eficiência:**
        *   **Sistema de Pilha (`push`/`pop`):** Utiliza uma pilha (`_scene_stack`) para gerenciar as cenas carregadas. Isso permite um fluxo de cena intuitivo (ex: `push` para abrir um menu sobre o jogo, `pop` para retornar), otimizando o uso de memória ao liberar cenas da árvore (`queue_free`) quando não são mais necessárias.
        *   **Renderização em `SubViewport`:** Todas as cenas do jogo (menus, o mundo do jogo) são renderizadas *dentro* de um `SubViewport` filho do `SceneManager`. Isso é crucial para:
            *   **Desacoplamento de Resolução:** Permite que a resolução de renderização do jogo seja diferente da resolução da janela. Você pode renderizar o jogo a uma resolução menor (ex: 720p) para otimizar a performance (especialmente útil para pixel art ou jogos 3D em hardware mais fraco) e deixar a Godot escalar a textura do `SubViewport` para a resolução nativa do monitor do jogador (1080p, 4K), mantendo a UI principal (que estaria fora do `SubViewport`, em uma `CanvasLayer`) nítida na resolução nativa.
            *   **Efeitos de Pós-Processamento:** Facilita a aplicação de shaders de tela cheia e outros efeitos de pós-processamento ao jogo renderizado, sem afetar a UI.

### Singletons (Autoloads)

*   **`GlobalEvents` (Event Bus):**
    *   **Propósito:** O coração da comunicação desacoplada.
    *   **Eficiência:** Contém exclusivamente declarações de `signal`, atuando como um quadro de avisos central e passivo para eventos globais. Isso garante que os sistemas se comuniquem sem conhecer uns aos outros, promovendo um desacoplamento extremo, alta modularidade, testabilidade e escalabilidade.
*   **`GlobalMachine` (State Machine):**
    *   **Propósito:** Gerenciar o estado global do jogo.
    *   **Eficiência:** Implementa uma Máquina de Estados Finitos (FSM) robusta para centralizar a lógica de pausa e o fluxo geral do jogo. Isso evita lógica de estado espalhada e facilita a transição entre diferentes modos de jogo. Os estados definidos são:
        *   `MENU`: O jogador está no menu principal.
        *   `SETTINGS`: O jogador está no menu de opções.
        *   `LOADING`: O jogo está carregando uma cena/nível.
        *   `PLAYING`: O jogador está ativamente no jogo.
        *   `PLAYING_SAVING`: O jogo está salvando em segundo plano (ex: autosave), mas a jogabilidade continua. Este estado garante que apenas um "snapshot" dos dados seja salvo, evitando corrupção de dados.
        *   `PAUSED`: O jogo está pausado e o menu de pause está visível.
        *   `QUIT_CONFIRMATION`: A caixa de diálogo "Deseja sair?" está na tela.
        *   `SAVING_QUIT`: O jogo está salvando os dados explicitamente antes de fechar.
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
*   **Otimização de Performance:** Abordagens para otimização de CPU e GPU, incluindo multithreading.
*   **Multithreading:** Uso da classe `Thread` para executar tarefas pesadas em segundo plano, com comunicação segura via sinais e `call_deferred()`.
*   **Pixel Art Configuration:** Configurações específicas para manter a nitidez da pixel art.


**Solução Proposta (Adesão às Boas Práticas):**

A refatoração proposta visa corrigir esses problemas, alinhando o `SettingsMenu` com os pilares do repositório:

*   **Cada Controle, Seu Script:** Cada botão, slider e checkbox de configuração terá seu próprio script GDScript dedicado (`Scripts/UI/Settings/*/*.gd`).
*   **Encapsulamento da Lógica do Controle:** A lógica de população de opções, a conexão do sinal nativo do controle e a emissão do sinal *global* correspondente para o `GlobalEvents` serão encapsuladas dentro do script de cada controle individual.
*   **UI "Burra" no `SettingsMenu`:** O `settings_menu.gd` será simplificado para apenas gerenciar a visibilidade dos painéis de categoria e os botões de ação (Aplicar, Voltar). Ele não terá conhecimento direto dos controles internos.
*   **Comunicação Exclusiva via EventBus:** Os controles individuais se comunicarão diretamente com o `GlobalEvents`, e o `SettingsManager` ouvirá esses sinais. O `SettingsMenu` não atuará como um intermediário de lógica para cada controle.
*   **Flexibilidade de Layout:** Ao desacoplar a lógica dos controles do script do menu, o usuário terá total liberdade para reorganizar, adicionar ou remover elementos da UI no `settings_menu.tscn` sem precisar alterar o código GDScript do menu principal, facilitando a adaptação da interface.

## Sugestões para Atualizações Futuras

Para expandir a utilidade e a abrangência do template "BodyLess", as seguintes funcionalidades são sugeridas para futuras implementações, com foco em acessibilidade, suporte a dispositivos móveis e aprimoramento da experiência do usuário com gamepads:

### 1. UI/UX (Mobile & Gamepad)

*   **Controles e HUD para Celular:**
    *   **Objetivo:** Criar uma HUD touch-friendly com botões virtuais na tela.
    *   **Plano:**
        1.  Criar uma nova cena `Scenes/UI/mobile_hud.tscn` com nós `Control` (ex: `TouchScreenButton`, `TextureRect` para ícones).
        2.  Desenvolver um script para `mobile_hud.tscn` que gerencie a visibilidade e o feedback visual dos botões.
        3.  Integrar com o `InputManager` para que os botões virtuais emitam sinais específicos para o `GlobalEvents` (ex: `mobile_move_left_pressed`, `mobile_jump_released`).
*   **Menus Interativos via Gamepad:**
    *   **Objetivo:** Garantir que todos os menus (`main_menu`, `pause_menu`, `settings_menu`) sejam totalmente navegáveis e controláveis por gamepad.
    *   **Plano:**
        1.  Revisar as cenas de menu existentes para configurar corretamente as propriedades de foco (`focus_neighbor`, `focus_mode`) dos nós `Control`.
        2.  Aprimorar o `InputManager` para emitir sinais de navegação de UI (ex: `ui_up_pressed`, `ui_accept_pressed`) que os scripts dos menus escutarão para gerenciar o foco e a interação.
*   **HUD de Botões Interativos (Estilo Assassin's Creed: Black Flag):**
    *   **Objetivo:** Exibir ícones de botões do gamepad na HUD que acendem ao serem pressionados.
    *   **Plano:**
        1.  Criar uma nova cena `Scenes/UI/gamepad_hud.tscn` com `TextureRect`s para os ícones dos botões.
        2.  O script de `gamepad_hud.tscn` escutará sinais do `GlobalEvents` (emitidos pelo `InputManager` quando um botão do gamepad for pressionado/solto) para animar visualmente os ícones.

### 2. Sistemas Essenciais

*   **Sistema de Remapeamento de Inputs:**
    *   **Objetivo:** Permitir que o jogador personalize os mapeamentos de teclado/mouse/gamepad.
    *   **Plano:**
        1.  Adicionar uma nova seção no `SettingsMenu` dedicada ao remapeamento de inputs.
        2.  Implementar lógica no `SettingsManager` para salvar e carregar os mapeamentos personalizados usando o `InputMap` da Godot.
        3.  O `GlobalEvents` emitirá um sinal (ex: `input_map_changed`) quando os mapeamentos forem alterados, permitindo que outros sistemas reajam.
*   **Recursos de Acessibilidade:**
    *   **Objetivo:** Incluir opções para melhorar a experiência de jogo para diversos usuários, focando em aspectos visuais, auditivos e de controle.
    *   **Plano:**
        1.  **Opções Visuais:**
            *   **Modos para Daltônicos:** Suporte para diferentes tipos de daltonismo (Deuteranopia, Protanopia, Tritanopia) através de filtros de cores ou ajustes de paleta.
            *   **Contraste Elevado:** Opção para aumentar o contraste da interface para melhor legibilidade.
            *   **Tamanho da Fonte Ajustável:** Permitir que o jogador aumente ou diminua o tamanho do texto na UI.
            *   **Redução de Movimento/Flashes:** Opção para desativar ou reduzir efeitos visuais intensos como tremores de tela, flashes rápidos ou partículas excessivas para prevenir desconforto.
            *   **Legendas Personalizáveis:** Controle sobre tamanho, cor, fundo e nome do orador das legendas.
        2.  **Opções Auditivas:**
            *   **Controles de Volume Granulares:** Separação de volume para Música, Efeitos Sonoros (SFX), Diálogos e Ambiente.
            *   **Áudio Mono:** Opção para combinar todos os canais de áudio em um único canal.
            *   **Cues Visuais para Sons:** Exibir indicadores visuais na tela para sons importantes que ocorrem fora da visão do jogador (ex: inimigos se aproximando, alertas).
        3.  **Opções de Controle:**
            *   **Alternar vs. Segurar:** Opção para converter ações que exigem segurar um botão (ex: correr, mirar) para ações de alternância (pressionar uma vez para ativar, pressionar novamente para desativar).
            *   **Sensibilidade e Zona Morta Ajustáveis:** Para controles de joystick e mouse.
            *   **Alternativas para "Button Mashing":** Oferecer opções para substituir sequências rápidas de botões por um único toque ou segurar.

### 3. Visuais

*   **Partículas e Shaders:**
    *   **Objetivo:** Demonstrar o uso de sistemas de partículas e shaders.
    *   **Plano:**
        1.  Criar cenas de exemplo (`Scenes/Effects/example_particles.tscn`, `Scenes/Effects/example_shader.tscn`) que mostrem diferentes tipos de efeitos de partículas (GPUParticles2D/3D) e shaders (ShaderMaterial).
        2.  Considerar a criação de um `ShaderManager` simples para gerenciar shaders de pós-processamento ou efeitos globais, se aplicável.
>>>>>>> ee7bc34fd3e892534753d4af6c060df0e4bb91c5
