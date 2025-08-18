# Testes

Testes são uma parte crucial do desenvolvimento de software, garantindo a qualidade, a estabilidade e a manutenibilidade do código. Em projetos Godot, a prática de testes é facilitada por frameworks dedicados.

### GUT (Godot Unit Test)

O template "Repo Café" já vem com o framework de testes **GUT (Godot Unit Test)** pré-instalado e configurado. GUT é o framework de testes unitários mais popular para Godot, permitindo escrever e executar testes diretamente no editor.

#### 1. O que é GUT?

GUT é um framework de testes unitários para Godot, escrito em GDScript, que permite testar unidades de código (funções, classes) de forma isolada. Ele ajuda a verificar se partes específicas do seu jogo funcionam como esperado, prevenindo bugs e regressões.

#### 2. Localização dos Testes

Por convenção, os arquivos de teste são armazenados na pasta `Tests/` na raiz do seu projeto. Esta organização facilita a localização e execução dos testes.

#### 3. Como Escrever Testes

Os testes são escritos em GDScript. Cada script de teste deve herdar de `res://addons/gut/test/gut_test.gd`. Dentro desses scripts, você define funções de teste que começam com `test_`.

**Exemplo de Estrutura de Teste:**

```gdscript
# Tests/test_player.gd
extends GutTest

# Variáveis que podem ser inicializadas antes de cada teste
var player_scene = preload("res://Scenes/player.tscn")
var player_instance

# Função chamada antes de cada teste
func before_each():
    player_instance = player_scene.instantiate()
    add_child(player_instance) # Adiciona o nó à árvore de cenas para testes
    await get_tree().process_frame # Espera um frame para _ready() ser chamado

# Função chamada depois de cada teste
func after_each():
    player_instance.queue_free() # Libera o nó da memória

# Exemplo de teste: verifica a vida inicial do jogador
func test_player_initial_health_is_correct():
    assert_eq(player_instance.current_health, player_instance.max_health, "A vida inicial deve ser igual à vida máxima.")

# Exemplo de teste: verifica se o jogador sofre dano
func test_player_takes_damage():
    var initial_health = player_instance.current_health
    player_instance.take_damage(10)
    assert_eq(player_instance.current_health, initial_health - 10, "A vida do jogador deve ser reduzida.")

# Exemplo de teste: verifica se um sinal é emitido
func test_health_changed_signal_is_emitted():
    var signals = watch_signals(player_instance) # Começa a observar os sinais do player
    player_instance.take_damage(5)
    assert_signal_emitted(signals, "health_changed", [player_instance.current_health, player_instance.max_health])
```

#### 4. Execução dos Testes

Os testes podem ser executados através do plugin GUT no editor Godot, que oferece uma interface gráfica para rodar todos os testes ou testes específicos, e visualizar os resultados. Isso permite um feedback rápido sobre a saúde do seu código.

### Por que Testar?

*   **Prevenção de Bugs:** Ajuda a encontrar erros cedo no ciclo de desenvolvimento.
*   **Refatoração Segura:** Permite fazer grandes mudanças no código com confiança, sabendo que os testes alertarão se algo quebrar.
*   **Documentação Viva:** Os testes servem como exemplos de como seu código deve ser usado.
*   **Qualidade de Código:** Incentiva a escrita de código mais modular e testável.
