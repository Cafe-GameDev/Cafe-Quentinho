# Sistema de Crafting

Um sistema de **Crafting** (criação de itens) na Godot se beneficia muito da filosofia da engine de "tudo é um recurso" e do gerenciamento de dados com `Resources`. Isso permite que você defina suas receitas e itens de forma modular e amigável para designers.

### Plano Conceitual para Implementar um Sistema de Crafting:

1.  **Definição de Itens (Resources):**
    *   Crie um script que herde de `Resource` (ex: `ItemData.gd`). Este script definirá as propriedades básicas de qualquer item no seu jogo (nome, descrição, ícone, etc.).
    *   Para cada item, crie um arquivo `.tres` (ex: `sword.tres`, `wood.tres`, `iron_ore.tres`) usando o `ItemData.gd` como base e preencha suas propriedades no editor.

2.  **Definição de Receitas de Crafting (Resources):**
    *   Crie um novo script que herde de `Resource` (ex: `CraftingRecipe.gd`).
    *   Este script terá propriedades para:
        *   O item resultante da receita (referência a um `ItemData.tres`).
        *   Uma lista de ingredientes necessários (pode ser um `Array` de `Dictionary`s, onde cada dicionário contém uma referência a um `ItemData.tres` e a quantidade necessária).
        *   A quantidade do item resultante (se a receita produzir mais de um).
    *   Para cada receita, crie um arquivo `.tres` (ex: `wooden_sword_recipe.tres`) e configure-o com os itens e quantidades necessárias.

3.  **Sistema de Inventário:**
    *   Você precisará de um sistema de inventário para armazenar os itens do jogador (ingredientes e itens criados). Isso pode ser um `Array` ou `Dictionary` que mapeia `ItemData` para quantidades.

4.  **Lógica de Crafting (Singleton/Manager):**
    *   Crie um Singleton (AutoLoad) chamado `CraftingManager`.
    *   Este manager será responsável por:
        *   Carregar todas as `CraftingRecipe.tres` disponíveis no jogo (você pode ter uma pasta `res://Resources/CraftingRecipes/` e carregá-las via código).
        *   Ter uma função `can_craft(recipe: CraftingRecipe, inventory: Dictionary)` que verifica se o jogador possui todos os ingredientes necessários no inventário.
        *   Ter uma função `craft_item(recipe: CraftingRecipe, inventory: Dictionary)` que, se `can_craft` for verdadeiro, remove os ingredientes do inventário e adiciona o item resultante.
        *   Emitir sinais como `item_crafted` ou `crafting_failed`.

5.  **Interface de Usuário (UI):**
    *   Crie uma cena de UI para o sistema de crafting.
    *   Ela pode exibir uma lista de receitas disponíveis.
    *   Ao selecionar uma receita, ela mostra os ingredientes necessários e o item resultante.
    *   Um botão "Craft" que, ao ser clicado, chama a função `craft_item` no `CraftingManager`.
    *   A UI se conectaria aos sinais do `CraftingManager` para atualizar a exibição do inventário e das receitas.

### Exemplo Simplificado de `ItemData.gd`:

```gdscript
# res://Scripts/Resources/ItemData.gd
class_name ItemData
extends Resource

@export var id: String = ""
@export var item_name: String = "Novo Item"
@export var description: String = ""
@export var icon: Texture2D
@export var stackable: bool = true
@export var max_stack_size: int = 99
```

### Exemplo Simplificado de `CraftingRecipe.gd`:

```gdscript
# res://Scripts/Resources/CraftingRecipe.gd
class_name CraftingRecipe
extends Resource

@export var result_item: ItemData # Referência ao ItemData do item que será criado
@export var result_quantity: int = 1

# Array de dicionários para os ingredientes: [{"item": ItemData, "quantity": int}]
@export var ingredients: Array[Dictionary] = []

func _init():
    # Define o tipo de exportação para o array de ingredientes no editor
    # Isso ajuda o editor a entender que 'item' deve ser um ItemData
    # Nota: Isso é mais complexo de configurar diretamente no editor para tipos aninhados.
    # Uma alternativa é criar um Resource para o ingrediente também.
    pass
```
