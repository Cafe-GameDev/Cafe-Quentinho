# AutoLoads (Singletons)

Na Godot Engine, os **AutoLoads**, também conhecidos como **Singletons**, são nós ou scripts que são carregados automaticamente no início do jogo e adicionados à árvore de cenas como filhos do nó raiz. Eles são acessíveis globalmente de qualquer lugar do seu código, tornando-os ideais para gerenciar funcionalidades que precisam estar sempre disponíveis e persistir entre as cenas.

Pense neles como os "ingredientes essenciais" do seu café: sempre à mão, prontos para serem usados em qualquer receita.

#### Como Criar um AutoLoad

Criar um AutoLoad na Godot é um processo simples:

1.  **Crie um Script (ou Cena):**
    *   Você pode criar um script GDScript (ou C#) que conterá a lógica do seu Singleton. Por exemplo, `AudioManager.gd` para gerenciar o áudio, ou `GameManager.gd` para a lógica geral do jogo.
    *   Alternativamente, você pode criar uma cena (`.tscn`) que contenha um nó raiz (por exemplo, um `Node` simples) e anexar um script a ele. Isso é útil se o seu Singleton precisar de outros nós filhos (como `AudioStreamPlayer` para um gerenciador de áudio).

2.  **Adicione-o aos AutoLoads do Projeto:**
    *   Vá em **Projeto > Configurações do Projeto...** (Project > Project Settings...).
    *   Na aba **AutoLoad** (ou Singletons, dependendo da versão da Godot), clique no botão **"Adicionar"** (Add).
    *   Navegue até o seu script (`.gd`, `.cs`) ou cena (`.tscn`) e selecione-o.
    *   A Godot sugerirá um nome para o AutoLoad (geralmente o nome do arquivo sem a extensão). Você pode renomeá-lo aqui. Este será o nome que você usará para acessá-lo globalmente.
    *   Certifique-se de que a opção **"Habilitar"** (Enable) esteja marcada.

Após adicionar, o AutoLoad aparecerá na lista. Ele será carregado automaticamente quando o jogo iniciar.

#### Quando Usar AutoLoads

AutoLoads são extremamente úteis para funcionalidades que se encaixam nos seguintes cenários:

*   **Gerenciamento de Estado Global:** Para armazenar e gerenciar dados que precisam ser acessados e modificados por várias partes do jogo, como pontuação, inventário do jogador, configurações do jogo, etc.
*   **Sistemas de Áudio:** Um `AudioManager` Singleton pode controlar o volume da música, efeitos sonoros, pausar/retomar o áudio, e gerenciar barramentos de áudio.
*   **Gerenciamento de Cenas:** Um `SceneManager` pode lidar com transições entre cenas, carregamento assíncrono, e efeitos de fade-in/fade-out.
*   **Sistemas de Save/Load:** Um `SaveManager` pode ser responsável por salvar e carregar o progresso do jogador, criptografar dados, e gerenciar múltiplos slots de save.
*   **Entrada de Dados (Input):** Embora a Godot tenha um sistema de input robusto, um Singleton pode centralizar a lógica de input customizada ou de remapeamento de teclas.
*   **Utilitários Globais:** Funções de utilidade que não se encaixam em nenhum nó específico, como funções matemáticas complexas, formatação de texto, ou gerenciamento de tempo.
*   **Depuração e Ferramentas de Desenvolvimento:** Um Singleton de depuração pode coletar logs, exibir informações na tela ou fornecer comandos de console para testes.

#### Exemplos de Uso

**1. GameManager (Gerenciador de Jogo)**

Um `GameManager.gd` pode ser usado para controlar o estado geral do jogo (menu, jogando, pausado, game over), a pontuação, e outras variáveis globais.

```gdscript
# Scripts/GameManager.gd
extends Node

var score: int = 0
var game_state: String = "menu" # "menu", "playing", "paused", "game_over"

func add_score(amount: int):
    score += amount
    print("Pontuação: ", score)

func set_game_state(new_state: String):
    game_state = new_state
    print("Estado do jogo: ", game_state)

func _ready():
    print("GameManager carregado!")
```

Para acessá-lo de qualquer outro script:

```gdscript
# Em outro script, por exemplo, um inimigo que dá pontos
extends CharacterBody2D

func _on_hit():
    # Adiciona 100 pontos ao GameManager
    GameManager.add_score(100)
    queue_free() # Destrói o inimigo
```

**2. AudioManager (Gerenciador de Áudio)**

Um `AudioManager.gd` pode gerenciar a reprodução de sons e músicas, e controlar os volumes dos barramentos de áudio.

```gdscript
# Scripts/AudioManager.gd
extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SfxPlayer

func play_music(music_path: String):
    music_player.stream = load(music_path)
    music_player.play()

func play_sfx(sfx_path: String):
    sfx_player.stream = load(sfx_path)
    sfx_player.play()

func set_music_volume(volume_db: float):
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_db)

func set_sfx_volume(volume_db: float):
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume_db)

func _ready():
    # Certifique-se de que os barramentos "Music" e "SFX" existam nas configurações de áudio do projeto
    print("AudioManager carregado!")
```

Para usar o `AudioManager`:

```gdscript
# Em um script de botão de menu
extends Button

func _on_pressed():
    AudioManager.play_sfx("res://Assets/Sounds/button_click.ogg")
    AudioManager.play_music("res://Assets/Music/game_theme.ogg")
```

#### Vantagens dos AutoLoads

*   **Acesso Global:** Não há necessidade de passar referências entre nós ou usar `get_node()` com caminhos complexos.
*   **Persistência:** Eles não são removidos quando as cenas são trocadas, mantendo seu estado e dados.
*   **Centralização:** Permitem agrupar lógicas relacionadas em um único local, facilitando a manutenção e a organização do código.
*   **Inicialização Automática:** São carregados e prontos para uso desde o início do jogo.

#### Considerações

*   **Uso Moderado:** Embora poderosos, o uso excessivo de Singletons pode levar a um código menos modular e mais difícil de testar, pois criam dependências globais. Use-os para funcionalidades verdadeiramente globais.
*   **Ordem de Carregamento:** A ordem em que os AutoLoads são listados nas configurações do projeto determina a ordem em que são inicializados. Isso pode ser importante se um AutoLoad depender de outro.

Espero que esta explicação detalhada ajude você a entender e utilizar os AutoLoads de forma eficaz em seus projetos Godot! Se tiver mais alguma dúvida, é só perguntar.
