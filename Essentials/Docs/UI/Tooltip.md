# Tooltip

## Visão Geral

O Tooltip é um pequeno balão de texto informativo que aparece quando o usuário passa o mouse sobre um elemento interativo da interface do usuário (UI). Ele fornece uma breve descrição ou contexto sobre a função do elemento, melhorando a usabilidade e a experiência do jogador.

## Implementação no Projeto "BodyLess"

No projeto "BodyLess", o Tooltip é implementado de forma **desacoplada e reativa**, seguindo os princípios da arquitetura. Ele **não utiliza o sistema nativo de tooltips do Godot** devido às suas limitações de personalização e posicionamento. Em vez disso, emprega uma abordagem personalizada que oferece maior controle sobre a aparência, conteúdo e comportamento.

### Cena e Script

*   **Cena:** `Scenes/UI/Tooltip/Tooltip.tscn`
    *   É uma cena `PanelContainer` que contém um `RichTextLabel`.
    *   O `PanelContainer` tem `mouse_filter = 2` (`MOUSE_FILTER_IGNORE`) para não interceptar eventos de mouse.
    *   O `RichTextLabel` permite texto formatado (BBCode) e ajusta seu tamanho automaticamente (`fit_content = true`).
*   **Script:** `Scripts/UI/Tooltip/tooltip.gd`
    *   Estende `PanelContainer`.
    *   Possui a função `set_text(text_content: String)` que atualiza o texto do `RichTextLabel` e torna o Tooltip visível.
    *   No `_ready()`, o Tooltip é inicialmente escondido (`hide()`).
    *   A propriedade `custom_minimum_size` é ajustada dinamicamente para que o tooltip se adapte ao tamanho do texto.

### Comunicação e Gerenciamento

O Tooltip é gerenciado por um `TooltipManager` (que é um Autoload, embora a cena do Tooltip em si não seja) através do `GlobalEvents`.

1.  **Exibição:**
    *   Quando um nó da UI (ex: um `Button` ou `Control`) precisa exibir um Tooltip, ele **não interage diretamente** com a cena `Tooltip.tscn`.
    *   Em vez disso, ele emite o sinal `show_tooltip_requested` no `GlobalEvents`, passando um `Dictionary` com os dados necessários.
    *   **Sinal:** `GlobalEvents.show_tooltip_requested(tooltip_data: Dictionary)`
    *   **`tooltip_data` (Dictionary):**
        *   `"text"` (String, obrigatório): O conteúdo do texto do Tooltip (pode incluir BBCode).
        *   `"position"` (Vector2, opcional): A posição global onde o Tooltip deve ser exibido. Se omitido, o `TooltipManager` pode inferir a posição (ex: próximo ao cursor do mouse).
        *   `"duration"` (float, opcional): Duração em segundos para o Tooltip permanecer visível. Se omitido, o `TooltipManager` pode usar um padrão ou esperar por `hide_tooltip_requested`.
        *   `"source_node"` (Node, opcional): A referência ao nó que solicitou o tooltip, útil para posicionamento relativo ou para o `TooltipManager` rastrear qual tooltip está ativo.

2.  **Ocultação:**
    *   Quando o mouse sai do elemento da UI ou o Tooltip precisa ser escondido por outro motivo, o nó da UI (ou o `TooltipManager` após uma duração) emite o sinal `hide_tooltip_requested` no `GlobalEvents`.
    *   **Sinal:** `GlobalEvents.hide_tooltip_requested()`

3.  **`TooltipManager` (Autoload):**
    *   O `TooltipManager` (localizado em `Singletons/Scripts/tooltip_manager.gd` e configurado como Autoload) ouve os sinais `show_tooltip_requested` e `hide_tooltip_requested`.
    *   Ao receber `show_tooltip_requested`, ele:
        *   Instancia a cena `Tooltip.tscn`.
        *   Chama a função `set_text()` da instância do Tooltip com o texto fornecido no `tooltip_data`.
        *   Posiciona o Tooltip na `SceneTree` (geralmente como filho de uma `CanvasLayer` global para garantir que ele esteja sempre acima de outros elementos da UI) usando a posição fornecida ou calculada.
        *   Gerencia a duração, se especificada, usando um `Timer` para emitir `hide_tooltip_requested` automaticamente.
    *   Ao receber `hide_tooltip_requested`, ele esconde e libera a instância do Tooltip.

### Por que não é um Autoload (a cena do Tooltip)?

A cena `Tooltip.tscn` em si não é um Autoload porque ela representa um componente visual que pode ser instanciado e liberado dinamicamente conforme a necessidade. O gerenciamento de sua exibição e ocultação é centralizado no `TooltipManager` (que é um Autoload), garantindo que o Tooltip só exista na `SceneTree` quando for realmente necessário, otimizando o uso de recursos e mantendo o desacoplamento.

### Diferença em relação a Popover, Toast e CoachMark

*   **Tooltip:** Breve informação contextual ao passar o mouse. Desaparece rapidamente.
*   **Popover:** Janela contextual maior, geralmente com mais conteúdo e interatividade, que aparece sobre outros elementos da UI. Pode exigir uma ação do usuário para fechar.
*   **Toast:** Notificação temporária e não intrusiva que aparece e desaparece automaticamente após um curto período, geralmente para informar sobre uma ação concluída (ex: "Item coletado!").
*   **CoachMark:** Elemento de tutorial que destaca uma parte específica da UI e fornece instruções, geralmente com botões para "Próximo" ou "Pular" para guiar o usuário por uma sequência de passos.
