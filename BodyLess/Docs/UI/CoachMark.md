# CoachMark

## Visão Geral

Um CoachMark é um elemento de tutorial que tem como objetivo guiar o usuário através de uma sequência de passos, destacando partes específicas da interface do usuário (UI) e fornecendo instruções contextuais. Ele é fundamental para introduzir novas funcionalidades, explicar mecânicas de jogo ou orientar o jogador em momentos cruciais, garantindo que ele compreenda como interagir com o ambiente.

## Implementação no Projeto "BodyLess"

No projeto "BodyLess", o CoachMark é implementado de forma **desacoplada e sequencial**, seguindo os princípios da arquitetura. Ele é projetado para ser um componente reutilizável que pode ser configurado para diferentes etapas de tutorial e gerenciado por um Manager dedicado.

### Cena e Script

*   **Cena:** `Scenes/UI/Components/CoachMark.tscn`
    *   É uma cena `PanelContainer` que contém um `VBoxContainer`.
    *   O `VBoxContainer` possui um `Label` para exibir o texto da instrução e um `HBoxContainer` com dois `Button`s: "Próximo" (`NextButton`) e "Pular" (`SkipButton`).
*   **Script:** `Scripts/UI/Components/CoachMark.gd`
    *   Estende `PanelContainer`.
    *   Possui a função `setup_coach_mark(text: String, show_skip: bool = true)` que define o texto da instrução, controla a visibilidade do botão "Pular" e torna o CoachMark visível.
    *   Possui a função `hide_coach_mark()` para esconder o CoachMark.
    *   Os botões "Próximo" e "Pular" emitem os sinais `coach_mark_next_requested` e `coach_mark_skip_requested` respectivamente no `GlobalEvents` quando pressionados.

### Comunicação e Gerenciamento

O CoachMark é gerenciado por um `TutorialManager` (que é um Autoload) através do `GlobalEvents`.

1.  **Início do Tutorial:**
    *   Para iniciar uma sequência de CoachMarks (um tutorial), qualquer parte da lógica do jogo emite o sinal `start_tutorial_requested` no `GlobalEvents`, passando um `Dictionary` com os dados do tutorial.
    *   **Sinal:** `GlobalEvents.start_tutorial_requested(tutorial_data: Dictionary)`
    *   **`tutorial_data` (Dictionary):**
        *   `"name"` (String, obrigatório): Um identificador único para o tutorial (ex: "intro_tutorial").
        *   `"steps"` (Array, obrigatório): Uma lista de dicionários, onde cada dicionário representa um passo do CoachMark, contendo o texto, o nó da UI a ser destacado, etc.

2.  **Exibição de um CoachMark:**
    *   O `TutorialManager` (Autoload) ouve `start_tutorial_requested` e gerencia a sequência de passos.
    *   Para cada passo, ele instancia a cena `CoachMark.tscn` e chama `setup_coach_mark()` com o texto e a visibilidade do botão "Pular" apropriados.
    *   Ele também pode posicionar o CoachMark e, opcionalmente, destacar o elemento da UI relevante para o passo atual.

3.  **Navegação:**
    *   Quando o usuário clica no botão "Próximo" do CoachMark, o sinal `coach_mark_next_requested` é emitido no `GlobalEvents`.
    *   Quando o usuário clica no botão "Pular", o sinal `coach_mark_skip_requested` é emitido no `GlobalEvents`.
    *   **Sinais:** `GlobalEvents.coach_mark_next_requested()` e `GlobalEvents.coach_mark_skip_requested()`

4.  **Fim do Tutorial:**
    *   Quando todos os passos do tutorial são concluídos ou o usuário decide pular, o `TutorialManager` emite o sinal `tutorial_finished` no `GlobalEvents`.
    *   **Sinal:** `GlobalEvents.tutorial_finished()`

### Por que não é um Autoload (a cena do CoachMark)?

A cena `CoachMark.tscn` em si não é um Autoload porque ela representa um componente visual que é instanciado e liberado dinamicamente como parte de uma sequência de tutorial. O `TutorialManager` (que é um Autoload) é responsável por gerenciar a criação, exibição, navegação e destruição das instâncias do CoachMark, garantindo que eles só existam na `SceneTree` quando necessário e sejam controlados de forma centralizada, otimizando o uso de recursos e mantendo o desacoplamento.

### Diferença em relação a Tooltip, Popover e Toast

*   **CoachMark:** Elemento de tutorial que destaca uma parte específica da UI e fornece instruções, geralmente com botões para "Próximo" ou "Pular" para guiar o usuário por uma sequência de passos.
*   **Tooltip:** Breve informação contextual ao passar o mouse. Desaparece rapidamente.
*   **Popover:** Janela contextual maior, geralmente com mais conteúdo e interatividade, que aparece sobre outros elementos da UI. Pode exigir uma ação do usuário para fechar.
*   **Toast:** Notificação temporária e não intrusiva que aparece e desaparece automaticamente após um curto período, geralmente para informar sobre uma ação concluída (ex: "Item coletado!").
