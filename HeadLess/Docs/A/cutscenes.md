# Cutscenes

Em Godot, **Cutscenes** são sequências não interativas que avançam a narrativa, apresentam informações ou criam momentos dramáticos no jogo. Elas são geralmente implementadas como cenas separadas que orquestram uma série de eventos visuais, sonoros e, por vezes, interativos.

### 1. Cenas Dedicadas (`.tscn`)

*   **Organização:** Crie uma cena Godot separada para cada cutscene (ex: `res://Scenes/Cutscenes/intro_cutscene.tscn`). Isso ajuda a organizar o projeto e permite que a cutscene seja reutilizável ou facilmente modificável sem afetar outras partes do jogo.
*   **Conteúdo:** Esta cena pode conter todos os elementos necessários: personagens, câmeras, fundos, elementos de UI (como caixas de diálogo ou legendas), efeitos visuais, etc.

### 2. Nó `AnimationPlayer` (Orquestração Central)

O `AnimationPlayer` é o coração da sua cutscene. Ele permite animar qualquer propriedade de qualquer nó na árvore de cenas, chamar funções, reproduzir áudios e até mesmo ativar/desativar nós. É uma ferramenta extremamente poderosa para criar cinemáticas e animações detalhadas.

*   **Animação de Propriedades:** Anime a posição, rotação, escala de personagens, a opacidade de elementos de UI, a cor de luzes, etc.
*   **Chamadas de Método (Method Call Tracks):** Use para disparar eventos específicos em pontos da cutscene, como:
    *   Iniciar um diálogo.
    *   Mudar a expressão de um personagem.
    *   Carregar uma nova cena após a cutscene.
    *   Tocar um efeito sonoro específico.
*   **Áudio (Audio Playback Tracks):** Adicione faixas de áudio diretamente no `AnimationPlayer` para sincronizar música, efeitos sonoros e dublagens com os eventos visuais.
*   **Câmeras:** Anime a propriedade `current` de um nó `Camera2D` ou `Camera3D` para controlar qual câmera está ativa em diferentes momentos da cutscene, permitindo cortes e movimentos de câmera dinâmicos.

### 3. Elementos Visuais e de Áudio

*   **Personagens e Cenários:** Instancie suas cenas de personagem e cenário dentro da cena da cutscene. Você pode animar seus `Sprite2D` (para 2D) ou `MeshInstance3D` (para 3D) e seus respectivos `AnimationPlayer` internos (se tiverem animações próprias) através do `AnimationPlayer` principal da cutscene.
*   **UI/Diálogo:** Utilize nós de `Control` (como `Label`, `TextureRect`, `Panel`) para criar caixas de diálogo, legendas ou outros elementos de interface que apareçam durante a cutscene. Anime a visibilidade, posição e conteúdo desses nós.
*   **Áudio:** Além das faixas de áudio no `AnimationPlayer`, você pode usar nós `AudioStreamPlayer`, `AudioStreamPlayer2D` ou `AudioStreamPlayer3D` para sons que precisam de mais controle ou que são posicionais. Utilize os **Barramentos de Áudio (Audio Buses)** para controlar o volume de diferentes categorias de som.

### 4. Scripting (GDScript)

Para lógicas mais complexas que não podem ser facilmente animadas, anexe um script à cena da cutscene.

*   **Gerenciamento de Fluxo:** Use o script para gerenciar o fluxo da cutscene (ex: pular a cutscene se o jogador pressionar um botão).
*   **Interação com Singletons:** Carregar dados dinamicamente ou interagir com Singletons (AutoLoads) do jogo (ex: `SaveManager`, `SceneManager`).
*   **Sincronização:** Conectar-se a sinais do `AnimationPlayer` (ex: `animation_finished`) para disparar ações quando uma animação termina.
*   **Assincronia:** Utilizar `await` para esperar por eventos ou tempos específicos, como `await get_tree().create_timer(2.0).timeout` para pausas.

### 5. Transições e Fluxo

Após a cutscene, você geralmente precisará transitar de volta para o gameplay ou para outra cena. Use o `SceneManager` (se você tiver um Singleton para isso) ou `get_tree().change_scene_to_file()` no script da cutscene. Considere adicionar fades ou outras transições visuais para suavizar a passagem.

### Exemplo Básico de Fluxo:

1.  Crie uma nova cena (ex: `res://Scenes/Cutscenes/intro_cutscene.tscn`).
2.  Adicione um nó `Node` raiz e renomeie-o para `IntroCutscene`.
3.  Adicione um nó `AnimationPlayer` como filho de `IntroCutscene`.
4.  Adicione os elementos visuais e de áudio que você precisa.
5.  No `AnimationPlayer`, crie uma nova animação (ex: "Intro").
6.  Adicione faixas de animação para as propriedades dos nós, faixas de áudio e faixas de chamada de método.
7.  No final da animação, adicione uma chamada de método para uma função no script da cena que carregará a próxima cena do jogo.
8.  No seu script principal do jogo, quando for a hora de iniciar a cutscene, instancie a cena `intro_cutscene.tscn` e adicione-a à árvore de cenas, então chame `get_node("IntroCutscene/AnimationPlayer").play("Intro")`.
