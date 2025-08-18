# Technical Design Document (TDD): Template Café Quentinho

Este documento detalha a arquitetura técnica e a implementação dos sistemas do template.

## 1. Arquitetura Central: O Padrão Event Bus

A espinha dorsal do template é o padrão **Event Bus** (Barramento de Eventos), implementado através do Singleton `GlobalEvents`.

*   **O Intermediário:** `GlobalEvents.gd` é um script que contém exclusivamente declarações de `signal`. Ele não possui nenhuma lógica. Sua única função é atuar como um quadro de avisos central e passivo.

*   **A Regra de Ouro:** **NENHUM** sistema (Manager) deve ter uma referência direta a outro. A comunicação é sempre indireta:
    1.  **Emissor:** Um sistema que precisa anunciar um evento (ex: `InputManager` ao detectar a tecla de pausa) emite o sinal correspondente no `GlobalEvents` (`GlobalEvents.pause_toggled.emit()`).
    2.  **Receptor:** Outros sistemas que se importam com esse evento (ex: `GameManager`) se conectam a este sinal em seu `_ready()` e reagem quando ele é emitido.

*   **Vantagens:**
    *   **Desacoplamento Extremo:** O `InputManager` não sabe que o `GameManager` existe. Podemos remover ou substituir o `GameManager` sem quebrar o `InputManager`.
    *   **Testabilidade:** Cada sistema pode ser testado de forma isolada, simulando emissões de sinais.
    *   **Escalabilidade:** Adicionar um novo sistema que reage a um evento existente (como um `AchievementManager` que ouve `inimigo_derrotado`) exige apenas conectar o novo sistema ao sinal, sem modificar os sistemas existentes.

## 2. Análise Detalhada dos Singletons (Autoloads)

A ordem de carregamento no `project.godot` é importante para garantir que as dependências de inicialização sejam resolvidas.

1.  **`SettingsManager`**
    *   **Responsabilidade:** Persistência de configurações.
    *   **Implementação:** Usa `JSON.stringify` e `JSON.parse_string` para salvar/carregar um dicionário de configurações em `user://settings.json`. A detecção de monitores e resoluções é feita na inicialização.
    *   **Fluxo:**
        1.  No `_ready`, carrega o arquivo `settings.json` ou cria um com valores padrão.
        2.  Aplica todas as configurações carregadas (`_apply_all_settings`).
        3.  Ouve sinais da UI (ex: `audio_setting_changed`) para atualizar seu dicionário `settings` interno em tempo real e aplicar a mudança imediatamente (ex: `AudioServer.set_bus_volume_db`).
        4.  Ouve o sinal `save_settings_requested` para escrever o estado atual do dicionário `settings` no arquivo.

2.  **`GlobalEvents`**
    *   **Responsabilidade:** Declarar todos os sinais globais. Carregado cedo para que outros managers possam se conectar a ele.

3.  **`GameManager`**
    *   **Responsabilidade:** Gerenciar o estado global do jogo.
    *   **Implementação:** Uma Máquina de Estados Finitos (FSM) simples usando um `enum GameState`.
    *   **Fluxo:**
        1.  Inicia no estado `MENU`.
        2.  Ouve `request_game_state_change` e `pause_toggled`.
        3.  A função `set_game_state` contém a lógica central: altera o estado, pausa/despausa a árvore de cenas (`get_tree().paused`) e emite o sinal `game_state_changed` para notificar outros sistemas.
        4.  Armazena o `_previous_game_state` para gerenciar menus de sobreposição (como o de configurações).

4.  **`AudioManager`**
    *   **Responsabilidade:** Carregar e reproduzir todo o áudio.
    *   **Implementação:**
        *   **Carregamento:** No `_ready`, usa `DirAccess` para varrer `res://Assets/Audio/`. A pasta `music` é tratada de forma especial. As outras pastas são usadas para criar chaves de SFX (ex: `interface_click`).
        *   **SFX:** Cria um pool de `AudioStreamPlayer`s para evitar que sons sejam interrompidos.
        *   **Música:** Usa um único `AudioStreamPlayer` e um `Timer` para gerenciar uma playlist que muda de categoria periodicamente.
    *   **Fluxo:** Ouve `play_sfx_by_key_requested` e `music_change_requested` para tocar os sons. Não decide *quando* tocar, apenas executa as solicitações.

5.  **`DebugConsole`**
    *   **Responsabilidade:** Fornecer feedback visual para depuração.
    *   **Implementação:** Uma `CanvasLayer` que se conecta a **TODOS** os sinais do `GlobalEvents`. Cada função de callback simplesmente chama `_log_signal()` com o nome do sinal e seus argumentos. A coluna da esquerda (`_update_debug_info`) busca informações de outros Singletons e do `Engine` a cada frame.

6.  **`InputManager`**
    *   **Responsabilidade:** Traduzir input bruto em intenções de jogo.
    *   **Implementação:** Usa `_unhandled_input` para garantir que a UI tenha prioridade para consumir eventos. Se uma ação global (`pause`, etc.) é pressionada, ele emite o sinal correspondente e consome o evento com `get_tree().get_root().set_input_as_handled()`.

## 3. Sistema de Cenas e UI

*   **`SceneManager`:**
    *   **Viewport:** O nó raiz é um `SubViewportContainer` que contém um `SubViewport`. Todas as cenas do jogo (`MainMenu`, `World`, etc.) são filhas deste `SubViewport`. Isso isola a renderização do jogo, permitindo escalar a resolução para performance (pixel art, etc.) sem afetar a UI principal.
    *   **Pilha de Cenas:** Gerencia um array `_scene_stack`. `_on_scene_push_requested` carrega uma nova cena, a adiciona ao `GameViewport` e à pilha. `_on_scene_pop_requested` remove a cena do topo da pilha e a libera (`queue_free`), mostrando a anterior.

*   **Cenas de UI (`MainMenu`, `PauseMenu`, `SettingsMenu`):**
    *   **Arquitetura Reativa:** Elas são "burras" por design. Sua única responsabilidade é:
        1.  Apresentar os botões.
        2.  Ao interagir, emitir um sinal de "requisição" para o `GlobalEvents` (ex: `request_game_state_change.emit(GameState.SETTINGS)`).
        3.  Ouvir o sinal `game_state_changed` para saber quando devem ficar visíveis ou não.
    *   **Exemplo de Fluxo (Abrir Opções):**
        1.  `MainMenu` -> `_on_options_button_pressed()` -> `GlobalEvents.request_game_state_change.emit(SETTINGS)`.
        2.  `GameManager` ouve o sinal -> `set_game_state(SETTINGS)` -> pausa o jogo e emite `GlobalEvents.game_state_changed.emit(SETTINGS)`.
        3.  `MainMenu` ouve o sinal -> `visible = false`.
        4.  `SettingsMenu` ouve o sinal -> `visible = true`.

## 4. Sistema de Internacionalização (I18N)

*   **Traduções:** Os arquivos de tradução (`.po`) estão em `I18N/` e são registrados em `project.godot`.
*   **Uso:** Nós de `Label` e `Button` na UI usam chaves de tradução (ex: `UI_NEW_GAME`) em sua propriedade `text`. A Godot as substitui automaticamente pelo texto do idioma ativo.
*   **Troca de Idioma:** O `SettingsMenu` emite `locale_setting_changed` com o código do idioma (ex: "en"). O `SettingsManager` ouve este sinal e chama `TranslationServer.set_locale(locale_code)`, que atualiza todos os textos da UI automaticamente.
