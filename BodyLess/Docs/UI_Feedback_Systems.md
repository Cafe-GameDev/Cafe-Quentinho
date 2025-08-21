# Documentação de Sistemas de Feedback de UI

Este documento detalha a implementação e o uso dos sistemas de feedback visual e interativo da Interface de Usuário (UI) no "Cafe-Quentinho Template". Esses sistemas são projetados para serem modulares, desacoplados e se comunicarem via EventBus, garantindo uma experiência de usuário consistente e informativa.

## 1. Visão Geral

Os sistemas de feedback de UI fornecem informações contextuais e não-intrusivas ao jogador, melhorando a clareza e a imersão. Eles incluem:

*   **Tooltips:** Dicas de ferramenta que aparecem ao passar o mouse sobre elementos interativos.
*   **Popovers:** Diálogos contextuais que exigem uma interação do usuário (ex: confirmações, detalhes de itens).
*   **Toasts/Snackbars:** Mensagens temporárias e não-intrusivas que aparecem e desaparecem automaticamente.
*   **Coach Marks:** Guias visuais passo a passo para introduzir novas funcionalidades ou interfaces.

Cada um desses sistemas é gerenciado por um Autoload (Manager) dedicado e utiliza cenas base para sua representação visual.

## 2. Tooltips (Dicas de Ferramenta)

### 2.1. Propósito

Fornecer informações adicionais sobre elementos da UI (botões, sliders, ícones) ou itens do inventário quando o jogador interage com eles (ex: passa o mouse por cima).

### 2.2. Implementação

*   **Cena Base:** `BodyLess/Scenes/UI/Components/Tooltip.tscn`
    *   **Nó Raiz:** `PanelContainer` (para o fundo e estilo).
    *   **Filhos:** Um `Label` para exibir o texto da dica.
    *   **Estilo:** Pode usar um `StyleBoxFlat` para um fundo arredondado e sombra.
*   **Script da Cena:** `BodyLess/Scripts/UI/Components/Tooltip.gd`
    *   Função `set_text(text_key: String, optional_args: Dictionary)`: Atualiza o texto do `Label` usando `tr(text_key)` e formata com `optional_args` se necessário.
    *   Função `set_position(position: Vector2)`: Posiciona o tooltip na tela (geralmente próximo ao cursor ou ao elemento).
    *   Pode incluir uma animação simples de fade-in/out.
*   **Manager (Autoload):** `BodyLess/Autoloads/tooltip_manager.gd`
    *   **Responsabilidade:** Instanciar, exibir, posicionar e ocultar a cena `Tooltip.tscn`.
    *   **Sinais que ouve:**
        *   `GlobalEvents.show_tooltip_requested(text_key: String, position: Vector2, optional_args: Dictionary = {})`: Recebe a chave de tradução do texto, a posição desejada e argumentos opcionais para formatação.
        *   `GlobalEvents.hide_tooltip_requested()`: Oculta o tooltip.
    *   **Lógica:** Mantém uma referência à instância do tooltip. Ao receber `show_tooltip_requested`, atualiza o texto e a posição, e o torna visível. Ao receber `hide_tooltip_requested`, o torna invisível.

### 2.3. Uso

Elementos de UI que precisam de tooltips (ex: botões de configurações, slots de inventário) devem:

1.  Conectar-se aos sinais `mouse_entered` e `mouse_exited`.
2.  No `_on_mouse_entered()`, emitir `GlobalEvents.show_tooltip_requested(tr("TOOLTIP_MY_ELEMENT_TITLE"), get_global_mouse_position())` (ou a posição do próprio nó).
3.  No `_on_mouse_exited()`, emitir `GlobalEvents.hide_tooltip_requested()`.

### 2.4. Chaves de Tradução (I18N)

*   `TOOLTIP_ELEMENT_NAME_TITLE`
*   `TOOLTIP_ELEMENT_NAME_DESC`

## 3. Popovers

### 3.1. Propósito

Exibir diálogos modais ou contextuais que exigem uma ação do usuário (ex: "Tem certeza que deseja usar este item?", "Detalhes do Item"). Eles bloqueiam a interação com o resto da UI até serem fechados.

### 3.2. Implementação

*   **Cena Base:** `BodyLess/Scenes/UI/Components/Popover.tscn`
    *   **Nó Raiz:** `PopupPanel` (para o comportamento modal e fundo).
    *   **Filhos:** Um `VBoxContainer` para organizar o conteúdo (Label para título/mensagem, `TextureRect` para ícone, `HBoxContainer` para botões).
*   **Script da Cena:** `BodyLess/Scripts/UI/Components/Popover.gd`
    *   Função `setup_popover(content_data: Dictionary)`: Recebe um dicionário com `title_key`, `message_key`, `icon_path`, `buttons: Array[Dictionary]` (com `text_key`, `action_id`).
    *   Conecta os botões a um sinal interno que, por sua vez, emite `GlobalEvents.popover_button_pressed(action_id)`.
*   **Manager (Autoload):** `BodyLess/Autoloads/popover_manager.gd`
    *   **Responsabilidade:** Instanciar e gerenciar a cena `Popover.tscn`.
    *   **Sinais que ouve:**
        *   `GlobalEvents.show_popover_requested(content_data: Dictionary, parent_node: Node = null)`: `content_data` descreve o conteúdo, `parent_node` é opcional para posicionamento relativo.
        *   `GlobalEvents.hide_popover_requested()`: Oculta o popover.
    *   **Lógica:** Ao receber `show_popover_requested`, instancia a cena, configura seu conteúdo e a exibe. Lida com o fechamento (ex: ao clicar fora ou pressionar ESC).

### 3.3. Uso

Qualquer sistema que precise de uma confirmação ou exibir detalhes contextuais pode emitir:

*   `GlobalEvents.show_popover_requested({"title_key": "POPOVER_CONFIRM_USE_ITEM_TITLE", "message_key": "POPOVER_CONFIRM_USE_ITEM_MESSAGE", "buttons": [{"text_key": "UI_YES", "action_id": "confirm_use"}, {"text_key": "UI_NO", "action_id": "cancel_use"}]})`

O sistema que emitiu a requisição deve ouvir `GlobalEvents.popover_button_pressed` para reagir à ação do usuário.

### 3.4. Chaves de Tradução (I18N)

*   `POPOVER_CONFIRM_USE_ITEM_TITLE`
*   `POPOVER_CONFIRM_USE_ITEM_MESSAGE`

## 4. Toasts / Snackbars

### 4.1. Propósito

Fornecer feedback rápido e não-intrusivo sobre ações do usuário ou eventos do jogo (ex: "Item Coletado", "Configurações Salvas", "Erro ao Salvar"). Eles aparecem por um curto período e desaparecem automaticamente.

### 4.2. Implementação

*   **Cena Base:** `BodyLess/Scenes/UI/Components/Toast.tscn`
    *   **Nó Raiz:** `PanelContainer`.
    *   **Filhos:** `Label` para a mensagem, opcionalmente `TextureRect` para um ícone (sucesso, erro, info).
    *   **Animação:** `AnimationPlayer` para fade-in/out e/ou slide-up/down.
*   **Script da Cena:** `BodyLess/Scripts/UI/Components/Toast.gd`
    *   Função `setup_toast(message_key: String, type: String, optional_args: Dictionary = {})`: Configura o texto, o estilo (baseado no tipo) e inicia a animação.
*   **Manager (Autoload):** `BodyLess/Autoloads/toast_manager.gd`
    *   **Responsabilidade:** Gerenciar uma fila de toasts para exibi-los sequencialmente.
    *   **Sinais que ouve:** `GlobalEvents.show_toast_requested(message_key: String, type: String = "info", optional_args: Dictionary = {})`.
    *   **Lógica:** Adiciona a requisição a uma fila. Quando um toast termina, exibe o próximo da fila.

### 4.3. Uso

Qualquer sistema que precise notificar o jogador de forma não-intrusiva pode emitir:

*   `GlobalEvents.show_toast_requested("TOAST_SETTINGS_SAVED_MESSAGE", "success")`
*   `GlobalEvents.show_toast_requested("TOAST_ITEM_COLLECTED_MESSAGE", "info", {"item_name": tr("ITEM_HEALING_POTION_NAME")})`

### 4.4. Chaves de Tradução (I18N)

*   `TOAST_SETTINGS_SAVED_TITLE`
*   `TOAST_SETTINGS_SAVED_MESSAGE`
*   `TOAST_ITEM_COLLECTED_TITLE`
*   `TOAST_ITEM_COLLECTED_MESSAGE`
*   `TOAST_ERROR_SAVE_FAILED_TITLE`
*   `TOAST_ERROR_SAVE_FAILED_MESSAGE`

## 5. Coach Marks (Tour Guiado)

### 5.1. Propósito

Guiar novos jogadores através de funcionalidades essenciais do jogo ou de menus complexos, destacando elementos da UI e fornecendo instruções passo a passo.

### 5.2. Implementação

*   **Cena Base:** `BodyLess/Scenes/UI/Components/CoachMark.tscn`
    *   **Nó Raiz:** `CanvasLayer` (para garantir que esteja acima de tudo).
    *   **Filhos:** `PanelContainer` para o texto/botões, `TextureRect` ou `Light2D` para destaque, `Line2D` para setas.
    *   **Animação:** `AnimationPlayer` para transições entre passos.
*   **Script da Cena:** `BodyLess/Scripts/UI/Components/CoachMark.gd`
    *   Função `setup_step(step_data: Dictionary)`: Configura o texto, a posição do destaque, a seta, etc.
    *   Botões "Próximo" e "Pular Tutorial" que emitem `GlobalEvents.coach_mark_next_requested` e `GlobalEvents.coach_mark_skip_requested`.
*   **Manager (Autoload):** `BodyLess/Autoloads/tutorial_manager.gd`
    *   **Responsabilidade:** Orquestrar a sequência de passos do tutorial, carregar dados dos passos (de um `Resource` ou `JSON`).
    *   **Sinais que ouve:**
        *   `GlobalEvents.start_tutorial_requested(tutorial_id: String)`: Inicia um tutorial específico.
        *   `GlobalEvents.coach_mark_next_requested()`: Avança para o próximo passo.
        *   `GlobalEvents.coach_mark_skip_requested()`: Pula o tutorial inteiro.
    *   **Sinais que emite:** `GlobalEvents.tutorial_finished()`.
    *   **Lógica:** Mantém o estado atual do tutorial (passo atual). Ao receber `start_tutorial_requested`, carrega os dados e exibe o primeiro passo. Ao receber `coach_mark_next_requested`, avança para o próximo passo ou finaliza o tutorial.

### 5.3. Uso

O `GlobalMachine` pode emitir `GlobalEvents.start_tutorial_requested("first_game_tutorial")` na primeira vez que o jogo é iniciado ou quando uma nova funcionalidade é desbloqueada.

### 5.4. Chaves de Tradução (I18N)

*   `COACH_MARK_WELCOME_TITLE`
*   `COACH_MARK_WELCOME_MESSAGE`
*   `COACH_MARK_MOVEMENT_TITLE`
*   `COACH_MARK_MOVEMENT_MESSAGE`
*   `COACH_MARK_PAUSE_TITLE`
*   `COACH_MARK_PAUSE_MESSAGE`
*   `COACH_MARK_INVENTORY_TITLE`
*   `COACH_MARK_INVENTORY_MESSAGE`
*   `COACH_MARK_SKIP_BUTTON`
*   `COACH_MARK_NEXT_BUTTON`

---

**Estes sistemas de feedback de UI são cruciais para a usabilidade e a experiência do jogador, fornecendo informações de forma clara, concisa e não-intrusiva, sempre seguindo os princípios de desacoplamento da arquitetura "BodyLess".**
