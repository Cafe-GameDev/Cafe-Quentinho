# Regra Geral de Comunicação

- **Idioma:** Todas as interações do assistente com o usuário devem ser em **português** amenos que peçam explicitamente por outro idioma, caso isso aconteça, vc precisa editar esse gemini.md adicionando no topo dele a linha "O usuario solicitou um idioma diferente: $idioma".

executavel da godot: "C:\Users\bruno\Documents\Godot_v4.4.1-stable_win64.exe"

# Core Mandates

- **Fluxo de Interação Principal:** Proposta, Pergunta / Confirmação em Chat, Proponha novamente confirmando, Execute, Teste (executando "C:\Users\bruno\Documents\Godot_v4.4.1-stable_win64_console.exe").
- **Windows:** Você está em ambiente Windows, **NUNCA** tente usar comandos Linux / Unix / Mac aqui.
- **EventBus (GlobalEvents):** **NUNCA** ignore ou evite o uso do `GlobalEvents` (EventBus). Todas as comunicações entre Singletons, cenas e outros componentes devem ser planejadas e implementadas através da emissão e conexão de sinais no `GlobalEvents`. Antes de implementar qualquer comunicação, pergunte-se: "Como posso conectar isso ao EventBus?".
- **Debug Console:** Mantenha o Debug Console sempre atualizado com todos os sinais do `GlobalEvents`.

# Arquitetura e Documentação do Projeto

Esta seção detalha a arquitetura dos sistemas centrais (Singletons/Autoloads) e das cenas principais do projeto.

## I. Arquitetura de Singletons (Autoloads)

O projeto é construído sobre uma arquitetura de Singletons desacoplados que se comunicam através de um "Barramento de Eventos" (Event Bus). Esta é a regra mais importante da nossa arquitetura.

### A Regra de Ouro: Comunicação via `GlobalEvents`

- **O que é?** `GlobalEvents` é um Singleton que atua como um quadro de avisos central. Ele não possui lógica, apenas uma lista de todos os sinais globais que podem ser emitidos no jogo.
- **Como funciona?**
    1.  Um sistema (ex: `InputManager`) emite um sinal no `GlobalEvents` para anunciar que algo aconteceu (ex: `pause_toggled`).
    2.  Outros sistemas (ex: `GameManager`) "escutam" esse sinal e reagem a ele.
- **Por que é crucial?** O `InputManager` não precisa saber que o `GameManager` existe, e vice-versa. Isso cria um **desacoplamento total**. Se removermos o `GameManager`, o `InputManager` continua funcionando sem erros.
- **Regra Inviolável:** **TODA** comunicação entre Singletons (Managers) **DEVE** ocorrer através de sinais no `GlobalEvents`. Uma chamada direta de um manager para outro (ex: `GameManager.alguma_funcao()`) é estritamente proibida, pois cria acoplamento e quebra a arquitetura.

### Comunicação Local vs. Global

- **`GlobalEvents`:** Usado para eventos que afetam o estado geral do jogo ou múltiplos sistemas (pausar, mudar de cena, salvar configurações).
- **`LocalEvents` (Futuro):** Será um segundo Event Bus, mas para eventos de gameplay que não precisam ser globais. Por exemplo, a interação entre um `Player` e um `Inimigo` (dano, morte do inimigo) emitiria sinais no `LocalEvents`. A UI de vida do jogador ouviria esses sinais, mas o `GameManager` não precisaria saber sobre cada golpe trocado.

---

## II. Documentação dos Singletons (Autoloads)

A ordem de execução dos Autoloads é definida em `project.godot`.

### 1. `GlobalEvents`
- **Arquivo:** `Singletons/Scripts/global_events.gd`
- **Propósito:** Atuar como o Barramento de Eventos central do jogo.
- **O que faz:**
    - Declara todos os sinais globais disponíveis no projeto.
    - Serve como a única fonte de verdade para a comunicação entre sistemas desacoplados.
- **O que NÃO faz:**
    - **Não contém nenhuma lógica.** É apenas uma lista de declarações de `signal`.
    - Não emite nem escuta seus próprios sinais. Ele é um intermediário passivo.

### 2. `InputManager`
- **Arquivo:** `Singletons/Scripts/input_manager.gd`
- **Propósito:** Capturar a entrada bruta do jogador (teclado, controle) e traduzi-la em "sinais de intenção".
- **O que faz:**
    - No `_unhandled_input`, verifica se ações de input globais (como "pause", "toggle_console") foram pressionadas.
    - Emite os sinais correspondentes no `GlobalEvents` (ex: `GlobalEvents.pause_toggled.emit()`).
- **O que NÃO faz:**
    - **Não implementa a lógica do que acontece quando uma tecla é pressionada.** Ele apenas anuncia a intenção. A decisão do que fazer com essa intenção é responsabilidade de outros sistemas (como o `GameManager`).
    - Não gerencia inputs de gameplay específicos de um personagem (como "mover_esquerda" ou "pular"). Isso deve ser tratado diretamente no script do personagem.

### 3. `GameManager`
- **Arquivo:** `Singletons/Scripts/game_manager.gd`
- **Propósito:** Gerenciar o estado global do jogo usando uma Máquina de Estados Finitos (FSM).
- **O que faz:**
    - Mantém o estado atual do jogo (ex: `MENU`, `PLAYING`, `PAUSED`).
    - Ouve os sinais de intenção do `InputManager` (via `GlobalEvents`) e de outros sistemas para transitar entre os estados.
    - Ao mudar de estado, executa a lógica central associada (ex: pausar/despausar a árvore de cenas com `get_tree().paused`).
    - Emite um sinal `GlobalEvents.game_state_changed` para que outros sistemas (principalmente a UI) possam reagir à mudança de estado.
- **O que NÃO faz:**
    - Não gerencia a lógica de cenas específicas (como carregar/descarregar). Isso é responsabilidade do `SceneManager`.
    - Não controla diretamente os nós da UI. Ele apenas informa à UI sobre a mudança de estado através de sinais, e a UI decide como se apresentar.

### 4. `SceneManager`
- **Arquivo:** `Singletons/Scenes/scene_manager.tscn` e `Singletons/Scripts/scene_manager.gd`
- **Propósito:** Gerenciar o carregamento, descarregamento e transições de cenas.
- **O que faz:**
    - Mantém uma "pilha de cenas" (`_scene_stack`) para gerenciar as cenas ativas.
    - Ouve os sinais `scene_push_requested` e `scene_pop_requested` do `GlobalEvents`.
    - `Push`: Carrega uma nova cena, a adiciona ao `GameViewport`, e a coloca no topo da pilha, escondendo a anterior.
    - `Pop`: Remove a cena do topo da pilha, libera-a da memória (`queue_free`) e mostra a cena anterior.
    - Contém o `SubViewport` principal onde as cenas do jogo são renderizadas.
- **O que NÃO faz:**
    - Não decide *quando* uma cena deve mudar. Ele apenas executa as solicitações que recebe via `GlobalEvents` (geralmente emitidas pela UI ou pelo `GameManager`).

### 5. `AudioManager`
- **Arquivo:** `Singletons/Scenes/audio_manager.tscn` e `Singletons/Scripts/audio_manager.gd`
- **Propósito:** Centralizar todo o gerenciamento de áudio.
- **O que faz:**
    - Carrega todos os arquivos de áudio da pasta `Assets/Audio` no início do jogo.
    - Organiza os sons em duas bibliotecas: `_music_library` e `_sfx_library`, com base na estrutura de pastas.
    - Gerencia um pool de `AudioStreamPlayer`s para tocar múltiplos SFX simultaneamente sem cortes.
    - Gerencia uma playlist de música, tocando faixas aleatórias de uma categoria e trocando de categoria periodicamente.
    - Ouve o sinal `play_sfx_by_key_requested` do `GlobalEvents` para tocar efeitos sonoros.
- **O que NÃO faz:**
    - Não decide *quando* um som deve tocar. Ele apenas responde às solicitações que recebe. A lógica de "tocar som de passo quando o jogador andar" está no script do jogador, que emite o sinal para o `AudioManager`.

### 6. `SettingsManager`
- **Arquivo:** `Singletons/Scripts/settings_manager.gd`
- **Propósito:** Lidar com a persistência (salvar e carregar) das configurações do jogo.
- **O que faz:**
    - Salva e carrega as configurações em um arquivo `settings.json` no diretório `user://`.
    - Mantém um dicionário `settings` com o estado atual das configurações.
    - Ouve sinais do `GlobalEvents` (ex: `audio_setting_changed`) para atualizar seu dicionário interno.
    - Ouve `save_settings_requested` para escrever as configurações no arquivo.
    - Ouve `load_settings_requested` para ler as configurações do arquivo e aplicá-las.
    - Aplica as configurações no jogo (ex: ajustando o volume nos `AudioBuses`, mudando o modo de tela no `DisplayServer`).
- **O que NÃO faz:**
    - Não possui interface gráfica. Ele é um sistema de backend que serve a UI de configurações (`settings_menu.gd`).
    - Não gerencia o estado do jogo, apenas as configurações persistentes.

### 7. `DebugConsole`
- **Arquivo:** `Singletons/Scenes/debug_console.tscn` e `Singletons/Scripts/debug_console.gd`
- **Propósito:** Fornecer um feedback visual em tempo real de todos os eventos que passam pelo `GlobalEvents`.
- **O que faz:**
    - É uma `CanvasLayer` que fica sobre todo o jogo.
    - Conecta-se a **todos** os sinais do `GlobalEvents`.
    - Quando um sinal é recebido, ele formata uma mensagem com o nome do sinal e seus argumentos e a exibe em um `RichTextLabel`.
    - Sua visibilidade é controlada pelo sinal `debug_console_toggled`.
- **O que NÃO faz:**
    - Não interfere com a lógica do jogo. É um observador passivo, essencial para depuração.

---

## III. Documentação das Cenas e Scripts de UI

As cenas de UI são responsáveis por apresentar informações ao jogador e capturar suas interações, traduzindo-as em sinais para os sistemas de gerenciamento.

### 1. `main_menu.tscn` / `main_menu.gd`
- **Propósito:** A tela principal do jogo, o primeiro ponto de interação do jogador.
- **O que faz:**
    - Apresenta as opções: "Novo Jogo", "Opções", "Sair".
    - Ouve os cliques nos botões e emite os sinais apropriados no `GlobalEvents` (ex: `request_game_state_change`, `scene_push_requested`).
    - Ouve o sinal `game_state_changed` do `GlobalEvents` para saber quando deve estar visível (apenas no estado `MENU`).
- **O que NÃO faz:**
    - Não implementa a lógica de iniciar um jogo ou abrir o menu de opções. Ele apenas **solicita** essas ações ao `GameManager` e `SceneManager` através de sinais.

### 2. `pause_menu.tscn` / `pause_menu.gd`
- **Propósito:** Fornecer opções ao jogador quando o jogo está pausado.
- **O que faz:**
    - Apresenta as opções: "Continuar", "Opções", "Sair".
    - Seu `process_mode` é `PROCESS_MODE_ALWAYS` para que funcione com o jogo pausado.
    - Assim como o menu principal, emite sinais para o `GlobalEvents` para solicitar ações.
    - Ouve o sinal `game_state_changed` para se tornar visível apenas no estado `PAUSED`.
- **O que NÃO faz:**
    - Não pausa o jogo. O `GameManager` é quem pausa o jogo; o menu de pausa apenas reage a essa mudança de estado.

### 3. `settings_menu.tscn` / `settings_menu.gd`
- **Propósito:** Permitir que o jogador visualize и modifique as configurações do jogo.
- **O que faz:**
    - Apresenta os controles de UI (sliders, checkboxes) para as configurações.
    - Ao ser carregado, ouve o sinal `settings_loaded` do `GlobalEvents` para popular os controles com os dados atuais do `SettingsManager`.
    - Quando um controle é alterado pelo jogador (ex: um slider é movido), ele emite um sinal no `GlobalEvents` (ex: `audio_setting_changed`) para notificar o `SettingsManager` da mudança pendente.
    - O botão "Aplicar" emite `save_settings_requested`.
    - O botão "Voltar" emite `load_settings_requested` (para reverter mudanças não salvas) e `return_to_previous_state_requested`.
- **O que NÃO faz:**
    - Não salva nem carrega as configurações diretamente. Ele é uma interface que se comunica com o `SettingsManager` via `GlobalEvents`.

### 4. `quit_confirmation_dialog.tscn` / `quit_confirmation_dialog.gd`
- **Propósito:** Apresentar um diálogo de confirmação para evitar que o jogador saia do jogo acidentalmente.
- **O que faz:**
    - Ouve os sinais `show_quit_confirmation_requested` e `hide_quit_confirmation_requested` para controlar sua visibilidade.
    - O botão "Sim" emite o sinal `quit_confirmed`.
    - O botão "Não" emite o sinal `quit_cancelled`.
- **O que NÃO faz:**
    - Não fecha o jogo. Ele apenas informa a decisão do jogador ao `GameManager` através de sinais.

---

## IV. Futuros Autoloads

A seguir, uma lista de Singletons planejados para futuras expansões da arquitetura:

-   `LocalEvents`
-   `SaveManager`
-   `WorldManager`
-   `QuestManager`
-   `FadeManager`
-   `PlayerState`
-   `LootManager`
-   `PoolManager`
-   `UIManager`
