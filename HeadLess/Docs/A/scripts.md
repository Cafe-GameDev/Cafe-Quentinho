# Scripts

Na Godot Engine, os **Scripts** são a forma de adicionar comportamento e lógica aos seus Nós. Eles são o "cérebro" por trás das suas cenas, permitindo que você defina como os objetos se movem, interagem, respondem a eventos e muito mais.

## 1. O Papel dos Scripts

*   **Extensão de Nós:** Um script é anexado a um Nó e estende suas funcionalidades. Ele herda todas as propriedades e métodos do Nó ao qual está conectado.
*   **Lógica de Jogo:** É onde você escreve as regras do seu jogo, a inteligência artificial dos inimigos, o controle do jogador, a interface do usuário, etc.
*   **GDScript:** A linguagem de script nativa e oficial da Godot. Possui uma sintaxe similar ao Python, sendo projetada para ser fácil de aprender e usar no desenvolvimento de jogos.

## 2. Anexando Scripts

Para anexar um script a um Nó:

1.  Selecione o Nó na árvore de cenas.
2.  Clique no ícone "Anexar Script" (parece um pergaminho com um sinal de mais) na barra de ferramentas do painel "Cena".
3.  Na janela que se abre, você pode criar um novo script ou carregar um existente. Defina o caminho e o nome do arquivo.

## 3. Funções de Ciclo de Vida (Callbacks)

Scripts possuem funções especiais que são chamadas automaticamente pela Godot em momentos específicos do ciclo de vida de um Nó. As mais comuns são:

*   **`_ready()`:**
    *   **Quando é chamada:** Uma vez, quando o Nó e todos os seus filhos já entraram na árvore de cenas e estão prontos.
    *   **Uso:** Ideal para inicializações, como obter referências a outros nós (`@onready var player = $Player`), configurar variáveis iniciais ou conectar sinais.

*   **`_process(delta)`:**
    *   **Quando é chamada:** A cada frame, após o `_physics_process`. A frequência depende do framerate do jogo.
    *   **Uso:** Para lógica que precisa ser atualizada a cada frame, como movimento baseado em input, animações, ou qualquer coisa que não seja diretamente ligada à física. `delta` é o tempo decorrido desde o último frame.

*   **`_physics_process(delta)`:**
    *   **Quando é chamada:** A cada frame de física, com uma frequência fixa (padrão: 60 vezes por segundo, configurável em `Project Settings -> Physics -> Common -> Physics Fps`).
    *   **Uso:** Para lógica relacionada à física, como movimento de `CharacterBody2D`, `RigidBody2D`, ou qualquer cálculo que precise ser consistente independentemente do framerate do jogador. `delta` é o tempo fixo entre os frames de física.

## 4. Recursos Essenciais em GDScript

*   **`class_name`:**
    *   **Uso:** Permite registrar um script como uma classe global, acessível de qualquer lugar do seu projeto sem a necessidade de `preload()` ou `load()`. Também permite que você crie `Resources` customizados a partir desse script.
    *   **Exemplo:** `class_name PlayerController`

*   **`@export`:**
    *   **Uso:** Permite expor variáveis do seu script no Inspector do editor Godot. Isso facilita a configuração de propriedades de um Nó diretamente no editor, sem precisar editar o código.
    *   **Exemplo:** `@export var speed: float = 100.0`

## 5. Boas Práticas de Estilo e Organização

*   **Nomenclatura:** Use `PascalCase` para nomes de classes (`PlayerController.gd`) e `snake_case` para variáveis e funções (`player_speed`, `move_player()`).
*   **Comentários:** Use comentários para explicar o *porquê* de uma decisão de código, não apenas o *quê* o código faz. Use `#` para comentários de linha única e `"""Docstring"""` para documentar funções e classes.
*   **Organização:** Mantenha seus scripts organizados em pastas lógicas (ex: `Scripts/Player`, `Scripts/Enemies`, `Scripts/UI`).
*   **Desacoplamento:** Utilize Sinais e Singletons (AutoLoads) para promover a comunicação desacoplada entre os nós, tornando seu código mais modular e fácil de manter.

Dominar os scripts é o coração do desenvolvimento de jogos na Godot, permitindo que você dê vida às suas ideias e crie experiências interativas.
