# Guia de Padrões: Sistema de Inventário

Um sistema de inventário robusto na Godot geralmente combina `Resources` para os dados e nós de `Control` para a interface.

## A Arquitetura de Dados (Resources)

A melhor abordagem é separar os dados dos itens da sua representação visual.

1.  **`ItemData` (ou `LootItemData`):** Um `Resource` que define as propriedades estáticas de um item: nome, descrição, ícone, se é empilhável, etc. Cada item do seu jogo (Maçã, Espada de Ferro) será um arquivo `.tres` deste tipo.

2.  **`SlotData`:** Um `Resource` opcional, mas útil, que representa um espaço no inventário. Ele contém uma referência ao `ItemData` e a `quantidade` daquele item no slot.

3.  **`InventoryData`:** Um `Resource` que representa um inventário completo. Ele contém um array de `SlotData` e talvez outras propriedades, como a `capacidade` máxima.

**Vantagem:** Com esta estrutura, um game designer pode criar e balancear itens e inventários inteiros (`player_inventory.tres`, `chest_inventory.tres`) diretamente no editor, sem tocar em código.

## A Lógica da Interface (Nós de UI)

A interface do inventário é construída com nós de `Control`.

*   **Cena do Slot (`Slot.tscn`):** Crie uma cena separada para um único slot de inventário. Geralmente contém:
    *   Um `Panel` ou `Button` como raiz.
    *   Um `TextureRect` para mostrar o ícone do item.
    *   Um `Label` para mostrar a quantidade.

*   **Cena do Inventário (`InventoryUI.tscn`):**
    *   Um `Panel` como janela principal.
    *   Um `GridContainer` para organizar os slots automaticamente.

## O Fluxo de Funcionamento

1.  **Inicialização:** O script da `InventoryUI` lê um `InventoryData` (ex: `player_inventory.tres`).
2.  **População:** Ele percorre o array de `SlotData` no `Resource`. Para cada um, ele instancia a `Slot.tscn`, a adiciona como filha do `GridContainer`, e passa os dados do item para o script do slot.
3.  **Atualização Visual:** O script do slot usa os dados recebidos para atualizar seu `TextureRect` e `Label`.
4.  **Interação:** Quando um slot é clicado, seu script emite um **sinal** (ex: `slot_clicado(slot_index)`). O script principal da `InventoryUI` ouve esse sinal e executa a lógica (usar item, equipar, etc.), modificando o `InventoryData` original.
5.  **Sincronização:** Após qualquer mudança nos dados, a UI é atualizada para refletir o novo estado do `InventoryData`.

Este padrão de **Dados (Resource) -> Lógica -> UI (Sinais)** garante que seu sistema seja desacoplado, escalável e fácil de manter.
