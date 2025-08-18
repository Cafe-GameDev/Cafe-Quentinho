# Guia de Padrões: Sistema de Save e Load

Salvar e carregar o progresso é uma função essencial. A Godot oferece a classe `FileAccess` para interagir diretamente com arquivos.

## Onde Salvar: `user://`

Você **sempre** deve salvar os dados do jogador no diretório `user://`. Este é um caminho especial que a Godot garante que será gravável em qualquer plataforma (Windows, Linux, Android, etc.). O diretório `res://` do seu projeto se torna somente leitura após a exportação.

## Estrutura dos Dados

A forma mais comum e flexível de organizar os dados para salvar é usando um **Dicionário (Dictionary)**.

```gdscript
var save_data = {
    "player_name": "Aventureiro",
    "score": 1200,
    "position": player.global_position,
    "inventory": player_inventory_resource
}
```

## Salvando o Jogo

O processo é: abrir um arquivo, escrever os dados e fechar.

```gdscript
const SAVE_PATH = "user://savegame.dat"

func save_game():
    # Abre o arquivo para escrita. Se não existir, será criado.
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file:
        # Agrupa os dados que você quer salvar
        var save_data = {"score": 100, "level": 2}
        # Salva o dicionário no arquivo. store_var lida com a serialização.
        file.store_var(save_data)
        # O arquivo é fechado automaticamente quando a variável 'file' sai de escopo.
```

## Carregando o Jogo

O processo inverso: verificar se o arquivo existe, abrir, ler e aplicar os dados.

```gdscript
func load_game():
    # É crucial verificar se o arquivo existe antes de tentar ler.
    if not FileAccess.file_exists(SAVE_PATH):
        return

    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file:
        # get_var desserializa os dados que foram salvos com store_var
        var loaded_data = file.get_var()
        if loaded_data:
            # Aplica os dados carregados às variáveis do seu jogo
            self.score = loaded_data.get("score", 0)
            self.level = loaded_data.get("level", 1)
```

## Boas Práticas

*   **`SaveManager` Singleton:** Crie um script AutoLoad para centralizar toda a sua lógica de save e load.
*   **JSON como Alternativa:** Para um formato de save legível por humanos, você pode converter seu dicionário para uma string JSON com `JSON.stringify()` e salvá-la com `file.store_string()`.
*   **Criptografia:** Para dificultar a edição dos saves pelos jogadores, use `FileAccess.open_encrypted_with_pass()` para uma camada simples de segurança.
