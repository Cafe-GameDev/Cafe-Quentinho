# Popover

## Visão Geral

Um Popover é uma janela contextual que aparece sobre outros elementos da interface do usuário (UI), geralmente contendo mais conteúdo e interatividade do que um Tooltip. Ele é usado para exibir informações adicionais, opções ou formulários de forma não intrusiva, sem a necessidade de navegar para uma nova tela.

## Implementação no Projeto "BodyLess"

No projeto "BodyLess", o Popover é implementado de forma **desacoplada e dinâmica**, seguindo os princípios da arquitetura. Ele permite a exibição de conteúdo variado e interativo, sendo gerenciado por um Manager dedicado.

### Cena e Script

*   **Cena:** `Scenes/UI/Components/Popover.tscn`
    *   É uma cena `PanelContainer` que contém um `VBoxContainer`.
    *   O `PanelContainer` tem `mouse_filter = 2` (`MOUSE_FILTER_IGNORE`) para não interceptar eventos de mouse, permitindo que o usuário interaja com o conteúdo do popover.
*   **Script:** `Scripts/UI/Components/Popover.gd`
    *   Estende `PanelContainer`.
    *   Possui a função `setup_popover(content_data: Dictionary)` que limpa o conteúdo anterior e adiciona novos elementos (Label para título, Label para mensagem, Button para ação) dinamicamente com base no `content_data`.
    *   Os botões criados dinamicamente se conectam a uma função que emite o sinal `popover_button_pressed` no `GlobalEvents`.
    *   Possui a função `hide_popover()` para esconder o Popover.

### Comunicação e Gerenciamento

O Popover é gerenciado por um `PopoverManager` (que é um Autoload) através do `GlobalEvents`.

1.  **Exibição:**
    *   Quando um nó da UI ou qualquer parte da lógica do jogo precisa exibir um Popover, ele emite o sinal `show_popover_requested` no `GlobalEvents`, passando um `Dictionary` com os dados do conteúdo e, opcionalmente, o nó pai para posicionamento.
    *   **Sinal:** `GlobalEvents.show_popover_requested(content_data: Dictionary, parent_node: Node)`
    *   **`content_data` (Dictionary):**
        *   `"title"` (String, opcional): Título do Popover.
        *   `"message"` (String, opcional): Mensagem principal do Popover.
        *   `"button_text"` (String, opcional): Texto para um botão interativo dentro do Popover.
        *   `"button_action"` (String, opcional): Uma string que será emitida no sinal `popover_button_pressed` quando o botão for clicado, permitindo que o `PopoverManager` ou outros sistemas reajam à ação.
    *   **`parent_node` (Node, opcional):** O nó ao qual o Popover deve ser anexado ou em relação ao qual deve ser posicionado. Se omitido, o `PopoverManager` pode usar um padrão (ex: centro da tela).

2.  **Ocultação:**
    *   O Popover pode ser escondido de várias maneiras:
        *   Clicando em um botão dentro do próprio Popover (que emite `popover_button_pressed` e chama `hide_popover()`).
        *   Emitindo o sinal `hide_popover_requested` no `GlobalEvents` de qualquer parte do código.
    *   **Sinal:** `GlobalEvents.hide_popover_requested()`

3.  **`PopoverManager` (Autoload):**
    *   O `PopoverManager` (localizado em `Singletons/Scripts/popover_manager.gd` e configurado como Autoload) ouve os sinais `show_popover_requested` e `hide_popover_requested`.
    *   Ao receber `show_popover_requested`, ele:
        *   Instancia a cena `Popover.tscn`.
        *   Chama a função `setup_popover()` da instância do Popover com os dados fornecidos no `content_data`.
        *   Posiciona o Popover na `SceneTree` (geralmente como filho de uma `CanvasLayer` global) e o torna visível.
    *   Ao receber `hide_popover_requested`, ele esconde e libera a instância do Popover.
    *   Ele também ouve `popover_button_pressed` para reagir a ações específicas do usuário dentro do Popover.

### Por que não é um Autoload (a cena do Popover)?

A cena `Popover.tscn` em si não é um Autoload porque ela representa um componente visual que pode ser instanciado e liberado dinamicamente. O `PopoverManager` (que é um Autoload) é responsável por gerenciar a criação, exibição e destruição das instâncias do Popover, garantindo que eles só existam na `SceneTree` quando necessário, otimizando o uso de recursos e mantendo o desacoplamento.

### Diferença em relação a Tooltip, Toast e CoachMark

*   **Popover:** Janela contextual maior, geralmente com mais conteúdo e interatividade, que aparece sobre outros elementos da UI. Pode exigir uma ação do usuário para fechar.
*   **Tooltip:** Breve informação contextual ao passar o mouse. Desaparece rapidamente.
*   **Toast:** Notificação temporária e não intrusiva que aparece e desaparece automaticamente após um curto período, geralmente para informar sobre uma ação concluída (ex: "Item coletado!").
*   **CoachMark:** Elemento de tutorial que destaca uma parte específica da UI e fornece instruções, geralmente com botões para "Próximo" ou "Pular" para guiar o usuário por uma sequência de passos.
