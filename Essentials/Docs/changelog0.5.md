# Changelog - Repo Café CLI - Versão 0.5 (Beta Inicial)

Esta versão 0.5 marca o lançamento da primeira fase beta do template "BodyLess", consolidando uma arquitetura robusta e modular para o desenvolvimento de jogos Godot. Este changelog detalha todas as funcionalidades e melhorias implementadas até o momento, servindo como a documentação inicial do projeto.

## 🚀 Novas Funcionalidades e Melhorias

### 1. Arquitetura Central (Padrão BodyLess)

O projeto é construído sobre o padrão arquitetural "BodyLess", que garante robustez, escalabilidade e facilidade de manutenção através dos seguintes pilares:

*   **Desacoplamento Absoluto (Event-Driven):** A comunicação entre os sistemas é feita **exclusivamente** através de um "Barramento de Eventos" (`GlobalEvents` para escopo global, `LocalEvents` para escopo de cena). Nenhum manager tem conhecimento direto sobre o outro, permitindo modificações e substituições com fluidez.
*   **Modularidade e Responsabilidade Única:** Cada sistema principal é um Singleton (Autoload) com uma responsabilidade **claramente definida**, resultando em código limpo e fácil de manter, promovendo uma abordagem plug-and-play.
*   **Orientado a Dados:** Há uma separação rigorosa entre lógica e dados. Incentiva-se o uso de `Resources` personalizados (`.tres`) para definir entidades e configurações, e **Dicionários (`Dictionary`)** para gerenciar e transportar o estado do jogo.
*   **Managers Reativos (Ouvintes):** Todos os Autoloads/Singletons são primariamente **ouvintes** do EventBus. Sua lógica é acionada em resposta a eventos, e eles **nunca são chamados diretamente**.
*   **UI Reativa:** As cenas de UI (menus, HUDs) são "burras" por design. Elas apenas apresentam informações, emitem sinais de "requisição" para o `GlobalEvents` e reagem a sinais de mudança de estado para controlar sua visibilidade.
*   **Persistência Desacoplada:** O `SaveSystem` (integrado ao `SettingsManager` nesta versão) é o **único** responsável por interagir com o sistema de arquivos. Outros sistemas apenas entregam ou recebem dicionários de dados para serem salvos ou carregados.
*   **Pronto para Produção:** Funcionalidades essenciais para um jogo completo já vêm pré-configuradas e otimizadas, oferecendo uma base sólida e testada.

### 2. Singletons (Autoloads) Implementados

Os seguintes Singletons (Autoloads) são a espinha dorsal do projeto:

*   **`GlobalEvents` (`global_events.gd`):**
    *   **Propósito:** O coração da comunicação desacoplada. Contém exclusivamente declarações de `signal`, atuando como um quadro de avisos central e passivo para eventos globais.
    *   **Sinais Declarados:**
        *   **Configurações (Settings):** `setting_changed`, `request_loading_settings_changed`, `loading_settings_changed`, `request_saving_settings_changed`, `request_reset_settings_changed`, `settings_data_save_requested`.
        *   **Idioma (Language):** `language_changed`, `request_loading_language_changed`, `loading_language_changed`, `request_saving_language_changed`, `request_reset_language_changed`, `language_data_save_requested`.
        *   **Áudio:** `play_sfx_by_key_requested`, `music_change_requested`, `music_track_changed`.
        *   **Estado do Jogo (Game State):** `game_state_updated`, `request_game_state_change`, `return_to_previous_state_requested`.
        *   **Gerenciamento de Cena:** `scene_updated`, `scene_push_requested`, `scene_pop_requested`, `request_game_selection_scene`.
        *   **Requisições de UI:** `show_ui_requested`, `hide_ui_requested`, `show_quit_confirmation_requested`, `hide_quit_confirmation_requested`, `quit_confirmed`, `quit_cancelled`, `save_settings_requested`, `show_tooltip_requested`, `hide_tooltip_requested`.
        *   **Popover:** `show_popover_requested`, `hide_popover_requested`, `popover_button_pressed`.
        *   **Toast:** `show_toast_requested`.
        *   **Tutorial/Coach Mark:** `start_tutorial_requested`, `coach_mark_next_requested`, `coach_mark_skip_requested`, `tutorial_finished`.
        *   **Depuração:** `debug_log_requested`, `debug_console_toggled`.
        *   **SaveSystem:** `request_save_game`, `game_saved`, `request_load_game`, `game_loaded`.
        *   **Coleta de Dados "Ao Vivo":** `request_live_settings_data`, `live_settings_data_provided`, `request_live_language_data`, `live_language_data_provided`.
        
        *   **InventoryManager:** `item_added`, `item_removed`, `item_used`.
        *   **LootSystem:** `character_defeated`, `item_spawned`.
        *   **FloatingTextManager:** `show_floating_text_requested`.
        *   **QuestSystem:** `quest_updated`.
        *   **Intenção de Input (Unificados):** `input_action_triggered`.

*   **`SettingsManager` (`settings_manager.gd`):**
    *   **Propósito:** Gerenciar o estado das configurações do jogo (áudio, vídeo e idioma). Ele aplica as configurações e reage a mudanças, e agora também lida com o salvamento e carregamento.
    *   **Estrutura de Configurações:** `DEFAULT_SETTINGS` reestruturado para usar dicionários aninhados (`"audio": {...}`, `"video": {...}`).
    *   **Lógica de Save/Load/Reset:** Implementada e funcional para todas as configurações, utilizando `res://settings.json` para persistência.
    *   **Comunicação:** Ouve e emite os sinais de configurações do `GlobalEvents`.
    *   **Detecção de Monitores:** Inclui lógica para detectar monitores e resoluções comuns.
    *   **Aplicação de Configurações:** Métodos para aplicar volumes de áudio, modo de janela, resolução, VSync, escala da UI, etc.

*   **`GameManager` (`game_manager.gd`):**
    *   **Propósito:** Gerencia os estados globais do jogo (MENU, PLAYING, PAUSED, SETTINGS, QUIT_CONFIRMATION), centralizando a lógica de fluxo e determinando o que pode acontecer em cada momento.
    *   **Estados:** Define um `enum GameState` para os estados possíveis.
    *   **Transições:** Reage a sinais de "intenção" do `GlobalEvents` (ex: `request_game_state_change`, `return_to_previous_state_requested`, `quit_confirmed`, `quit_cancelled`, `input_action_triggered`) para transicionar entre os estados.
    *   **Controle de Pausa:** Gerencia diretamente `get_tree().paused` para pausar ou despausar o jogo.
    *   **Comunicação:** Emite `GlobalEvents.game_state_updated` para notificar outros sistemas sobre mudanças de estado.

*   **`AudioManager` (Cena `audio_manager.tscn` com script `audio_manager.gd`):**
    *   **Propósito:** Centralizar o carregamento, organização e reprodução de música e efeitos sonoros (SFX).
    *   **Funcionamento:** Carrega dinamicamente arquivos de áudio, categoriza-os em bibliotecas de SFX e música, e utiliza um pool de `AudioStreamPlayer` para SFX.
    *   **Comunicação:** Ouve `play_sfx_by_key_requested`, `music_change_requested`, `setting_changed` e `loading_settings_changed` do `GlobalEvents`. Emite `music_track_changed`.
    *   **Controle de Volume:** Reage a mudanças de volume de áudio (Master, Música, SFX) do `SettingsManager`.

*   **`DebugConsole` (Cena `debug_console.tscn` com script `debug_console.gd`):**
    *   **Propósito:** Fornecer feedback visual para depuração em tempo real, ouvindo todos os sinais do `GlobalEvents` e exibindo um log formatado.

*   **`SceneManager` (Cena `scene_manager.tscn`):**
    *   **Propósito:** Gerenciar o carregamento, descarregamento e transições de cenas de forma eficiente e controlada usando um sistema de pilha (`push`/`pop`).

*   **Outros Singletons (Existentes, mas com implementação a ser revisada/detalhada):**
    *   `InventoryManager`
    *   `PopoverManager`
    *   `ToastManager`
    *   `TooltipManager`
    *   `TutorialManager`
    *   `LocalEvents`
    *   `LocalMachine`
    *   `GlobalMachine`

### 3. Sistema de UI Reativo

*   **Princípio:** Cenas de UI são "burras" por design, focando em apresentação e interação via `GlobalEvents`.
*   **Cenas de UI Implementadas:**
    *   `main_menu.tscn`
    *   `pause_menu.tscn`
    *   `options_menu.tscn` (`options_menu.gd` gerencia a navegação e ações de "Voltar" e "Aplicar").
    *   `quit_confirmation_dialog.tscn`
    *   `video_settings.tscn` (com scripts para `monitor`, `window`, `resolution`, `aspect`, `dynamic_render`, `upscaling_quality`, `frame_rate`, `max_frame`, `v_sync`, `gamma_correction`, `contrast`, `brightness`, `shaders`, `effects_quality`, `colorblind`, `ui_scale`).
    *   `audio_settings.tscn` (com scripts para `master`, `music`, `sfx`).
    *   `language_settings.tscn` (com script `language_options.gd`).
    

### 4. Internacionalização (I18N)

*   **Estrutura:** Utiliza arquivos `.po` localizados em `I18N/`.
*   **Idioma Fonte:** Inglês (`en_US.po`) é a base para todas as novas chaves de tradução.
*   **Fluxo de Tradução:** Prioriza `pt_BR.po`, seguido por `pt_PT.po` e outras variantes, sempre usando `en_US.po` como referência.
*   **Boas Práticas:** Strings nunca hardcoded, chaves descritivas (`contexto.funcao.acao`), fallback seguro e compatibilidade com l10n.



### 6. Outros Componentes Essenciais

*   **`SceneControl` (Cena Principal):**
    *   Atua como o maestro que orquestra a experiência do usuário, gerenciando a visibilidade das interfaces de usuário e o carregamento/descarregamento das cenas de jogo.
    *   Reage a estados da `GlobalMachine` e gerencia configurações de vídeo (resolução, modo de janela, FPS, VSync, etc.).
    *   Contém nós cruciais como `GameViewportContainer`, `GameViewport`, `CanvasLayer`, `MainMenu`, `OptionsMenu`, `PauseMenu`, `QuitConfirmationDialog`, `ColorblindFilter` e `CanvasModulate`.

## 🐛 Correções e Refatorações Recentes

*   **Correção de Save/Load de Configurações:**
    *   Reestruturação completa do `DEFAULT_SETTINGS` no `settings_manager.gd` para usar dicionários aninhados, garantindo a consistência dos dados salvos.
    *   Ajuste da lógica de mesclagem em `_load_settings_from_file` para priorizar a estrutura correta e evitar chaves duplicadas no `settings.json`.
    *   O salvamento das configurações agora é funcional e persistente.
*   **Movimentação de Ações de Input:**
    *   As ações `pause`, `music_change` e `toggle_console` foram removidas do `project.godot` e agora são gerenciadas diretamente pelo sistema de InputMap nativo do Godot, centralizando o controle de inputs.
*   **Correção de Erros de Tipo:**
    *   Resolvido o erro "Trying to assign value of type 'Dictionary' to a variable of type 'Vector2i'" em `Scripts/UI/Settings/Video/resolution.gd` através da conversão explícita do dicionário de resolução para `Vector2i`.
*   **Correção de Avisos de Linter:**
    *   Resolvidos avisos `UNUSED_PARAMETER` (renomeando parâmetros não utilizados com `_`) e `SHADOWED_VARIABLE_BASE_CLASS` (renomeando variáveis locais para evitar conflitos) em vários scripts de UI.
*   **Remoção de `InputManager` Obsoleto:** O script `Singletons/Scripts/input_manager.gd` foi marcado para remoção (ou ignorado, devido a problemas de permissão), pois suas responsabilidades foram transferidas para o `SettingsManager`.
*   **Depuração Aprimorada:** Adicionados `print` statements estratégicos em `GlobalEvents` e `SettingsManager` para auxiliar na depuração da ordem de inicialização e fluxo de sinais.

## 🗓️ Próximos Passos (Roadmap para v0.6)

O desenvolvimento continua com foco nas seguintes áreas:

1.  **Implementação Completa de Tooltips, Toasts e Popovers:**
    *   **Passo 1:** Definir a estrutura de dados para Tooltips, Toasts e Popovers (provavelmente dicionários).
    *   **Passo 2:** Criar ou revisar as cenas de UI (`.tscn`) para cada um desses elementos.
    *   **Passo 3:** Implementar os scripts (`.gd`) para gerenciar a exibição, ocultação e comportamento de cada um (ouvindo `GlobalEvents`).
    *   **Passo 4:** Integrar a lógica de exibição e ocultação com o `SceneControl` ou um novo Manager dedicado, se necessário.
    *   **Passo 5:** Atualizar o sistema de i18n para incluir chaves de tradução para todos os textos de Tooltips, Toasts e Popovers.

2.  **Navegação por Teclado e Gamepad nos Menus:**
    *   **Passo 1:** Pesquisar e analisar as melhores práticas para navegação de UI com teclado e gamepad no Godot (foco em `Control` nodes e `focus`).
    *   **Passo 2:** Desenvolver um "Input Handler" genérico para menus que interprete inputs de joystick esquerdo/d-pad para navegação de foco e joystick direito como "mouse livre" (controlando um cursor virtual ou similar).
    *   **Passo 3:** Integrar este handler com as cenas de UI existentes (`options_menu`, `main_menu`, etc.).
    *   **Passo 4:** Testar exaustivamente a navegação em todos os menus.

3.  **Revisão e Garantia de Configurações de Vídeo Funcionais:**
    *   **Passo 1:** Realizar testes abrangentes em todas as configurações de vídeo (resolução, modo de janela, VSync, etc.) para garantir que cada uma funcione como esperado em diferentes cenários.
    *   **Passo 2:** Implementar feedback visual ou logs adicionais para confirmar a aplicação correta de cada configuração.



5.  **Documentação Aprofundada:**
    *   **Passo 1:** Criar ou atualizar arquivos Markdown (`.md`) para cada sistema (ex: `Docs/Managers/SettingsManager.md`, `Docs/UI/OptionsMenu.md`) detalhando sua API, uso e princípios de design.
    *   **Passo 2:** Adicionar diagramas Mermaid para visualizar a arquitetura e o fluxo de dados entre os sistemas.
