# Toast

## Visão Geral

Um Toast é uma notificação temporária e não intrusiva que aparece na tela por um curto período e desaparece automaticamente. Ele é usado para fornecer feedback rápido ao usuário sobre ações concluídas, eventos importantes ou mensagens de status, sem interromper o fluxo do jogo.

## Implementação no Projeto "BodyLess"

No projeto "BodyLess", o Toast é implementado de forma **desacoplada e animada**, seguindo os princípios da arquitetura. Ele é projetado para ser leve e eficientemente gerenciado, com animações de entrada e saída.

### Cena e Script

*   **Cena:** `Scenes/UI/Components/Toast.tscn`
    *   É uma cena `PanelContainer` que contém um `Label` para a mensagem e um `AnimationPlayer`.
    *   O `PanelContainer` tem `mouse_filter = 2` (`MOUSE_FILTER_IGNORE`) para não interceptar eventos de mouse.
    *   O `AnimationPlayer` contém uma animação `fade_in_out` que controla a opacidade do Toast, fazendo-o aparecer e desaparecer suavemente.
*   **Script:** `Scripts/UI/Components/Toast.gd`
    *   Estende `PanelContainer`.
    *   Possui a função `show_toast(message: String, type: String = "info")` que define o texto da mensagem, ajusta a cor de fundo do painel com base no `type` (info, success, error, etc.), torna o Toast visível e inicia a animação `fade_in_out`.
    *   Conecta-se ao sinal `animation_finished` do `AnimationPlayer` para, após a animação `fade_in_out` ser concluída, esconder o Toast e liberá-lo da memória (`queue_free()`).

### Comunicação e Gerenciamento

O Toast é gerenciado por um `ToastManager` (que é um Autoload) através do `GlobalEvents`.

1.  **Exibição:**
    *   Qualquer parte da lógica do jogo que precise exibir uma notificação Toast emite o sinal `show_toast_requested` no `GlobalEvents`, passando um `Dictionary` com os dados da mensagem.
    *   **Sinal:** `GlobalEvents.show_toast_requested(toast_data: Dictionary)`
    *   **`toast_data` (Dictionary):**
        *   `"message"` (String, obrigatório): O texto da mensagem do Toast.
        *   `"type"` (String, opcional): O tipo de Toast (ex: "info", "success", "error"). Usado para estilização (cor de fundo).
        *   `"duration"` (float, opcional): A duração total do Toast em segundos. Se omitido, a duração da animação padrão será usada.

2.  **`ToastManager` (Autoload):**
    *   O `ToastManager` (localizado em `Singletons/Scripts/toast_manager.gd` e configurado como Autoload) ouve o sinal `show_toast_requested`.
    *   Ao receber `show_toast_requested`, ele:
        *   Instancia a cena `Toast.tscn`.
        *   Chama a função `show_toast()` da instância do Toast com os dados fornecidos no `toast_data`.
        *   Posiciona o Toast na `SceneTree` (geralmente em uma `CanvasLayer` global, em um canto da tela, como o inferior central) e o torna visível.
        *   Pode gerenciar uma fila de Toasts para que eles apareçam sequencialmente ou empilhados, se múltiplas notificações forem disparadas rapidamente.

### Por que não é um Autoload (a cena do Toast)?

A cena `Toast.tscn` em si não é um Autoload porque ela representa um componente visual temporário que é instanciado, exibido e liberado dinamicamente. O `ToastManager` (que é um Autoload) é responsável por gerenciar a criação, exibição e destruição das instâncias do Toast, garantindo que eles só existam na `SceneTree` quando necessário e sejam automaticamente removidos, otimizando o uso de recursos e mantendo o desacoplamento.

### Diferença em relação a Tooltip, Popover e CoachMark

*   **Toast:** Notificação temporária e não intrusiva que aparece e desaparece automaticamente após um curto período, geralmente para informar sobre uma ação concluída (ex: "Item coletado!").
*   **Tooltip:** Breve informação contextual ao passar o mouse. Desaparece rapidamente.
*   **Popover:** Janela contextual maior, geralmente com mais conteúdo e interatividade, que aparece sobre outros elementos da UI. Pode exigir uma ação do usuário para fechar.
*   **CoachMark:** Elemento de tutorial que destaca uma parte específica da UI e fornece instruções, geralmente com botões para "Próximo" ou "Pular" para guiar o usuário por uma sequência de passos.
