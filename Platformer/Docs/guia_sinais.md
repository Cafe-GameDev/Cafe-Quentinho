# Guia de Padrões: Sinais (Signals)

Sinais são a implementação do padrão "Observer" na Godot. É um sistema de mensagens que permite que um nó emita um "aviso" quando um evento específico ocorre, e outros nós podem "ouvir" e reagir a esse aviso sem que haja uma conexão direta entre eles.

## Por que usar Sinais?

O principal benefício é o **desacoplamento**. O nó que emite o sinal (o emissor) não precisa saber nada sobre os nós que o recebem (os receptores).

**Exemplo:** Um jogador não precisa saber sobre a interface (UI). Quando o jogador perde vida, ele simplesmente emite um sinal `vida_alterada(nova_vida)`. A UI, por sua vez, se conecta a esse sinal e atualiza a barra de vida quando o recebe. Se você remover a UI, o jogador continua funcionando sem erros.

## Como Conectar Sinais

### Pelo Editor
1.  Selecione um nó na árvore de cenas.
2.  Vá para a aba "Nó" (ao lado do Inspector).
3.  Dê um duplo-clique no sinal que deseja usar (ex: `pressed` de um `Button`).
4.  Na janela que abrir, selecione o nó que receberá o sinal e o método que será chamado.

### Por Código
Use o método `connect()` do sinal.

```gdscript
func _ready():
    # Conecta o sinal "pressed" do nó Button ao método "_on_button_pressed" deste script.
    $Button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
    print("O botão foi pressionado!")
```

## Criando Sinais Personalizados

Você pode criar seus próprios sinais em qualquer script.

```gdscript
class_name Player extends CharacterBody2D

# 1. Declare o sinal
signal vida_alterada(valor_atual)

var vida = 100

func sofrer_dano(dano):
    vida -= dano
    # 2. Emita o sinal quando o evento ocorrer
    vida_alterada.emit(vida)
```

---

## Tópicos Avançados

### 1. Conectando com Parâmetros Adicionais (`bind`)

Às vezes, você quer que a função receptora receba mais informações do que o sinal envia por padrão. O método `bind()` permite "pré-configurar" argumentos.

**Exemplo:** Vários botões de um inventário podem se conectar à mesma função, mas cada um precisa dizer qual item ele representa.

```gdscript
# Suponha que você tenha botões para "Maçã", "Escudo", "Poção"
func _ready():
    $BotaoMaca.pressed.connect(_on_item_button_pressed.bind("maçã"))
    $BotaoEscudo.pressed.connect(_on_item_button_pressed.bind("escudo"))
    $BotaoPocao.pressed.connect(_on_item_button_pressed.bind("poção"))

# A função receptora receberá o argumento "item_nome" que foi passado no bind.
func _on_item_button_pressed(item_nome: String):
    print("Botão do item", item_nome, "foi pressionado!")
```

### 2. Aguardando um Sinal com `await`

Você pode pausar a execução de uma função até que um sinal seja emitido. Isso é extremamente útil para criar sequências de eventos e timers sem travar o jogo.

**Exemplo:** Esperar 1 segundo.

```gdscript
func minha_funcao_assincrona():
    print("Começou")
    # Pausa a execução DESTA FUNÇÃO até que o timer emita o sinal "timeout"
    await get_tree().create_timer(1.0).timeout
    print("Terminou depois de 1 segundo")
```
**Exemplo:** Esperar por um sinal personalizado.
```gdscript
func esperar_pela_morte_do_jogador():
    print("Esperando o jogador morrer...")
    await GlobalEvents.jogador_morreu
    print("O jogador morreu. Fim de jogo.")
```

### 3. Desconectando Sinais (`disconnect`)

Assim como você conecta, você pode desconectar um sinal. Isso é útil para conexões temporárias ou para evitar que um sinal seja recebido por um objeto que está prestes a ser removido.

```gdscript
func _ready():
    $Button.pressed.connect(_on_button_pressed)

func desativar_botao():
    # Impede que _on_button_pressed seja chamado novamente
    $Button.pressed.disconnect(_on_button_pressed)
```

### 4. Sinais vs. Chamadas de Função Diretas

| Característica | Sinais (`sinal.emit()`) | Chamada Direta (`$No.funcao()`) |
| :--- | :--- | :--- |
| **Acoplamento** | **Baixo.** O emissor não conhece o receptor. | **Alto.** O chamador precisa de uma referência direta ao nó e sabe da existência da função. |
| **Flexibilidade** | **Alta.** Múltiplos nós podem ouvir o mesmo sinal. Fácil de adicionar/remover ouvintes. | **Baixa.** A conexão é de um para um. Mudar a lógica exige mudar o código do chamador. |
| **Performance** | **Ligeiramente mais lento.** Há uma pequena sobrecarga para emitir e rotear o sinal. | **Mais rápido.** É uma chamada de função direta. |
| **Legibilidade** | Pode ser mais difícil de rastrear quem está ouvindo um sinal. | O fluxo do código é explícito e fácil de seguir. |
| **Quando Usar** | Para comunicação entre árvores de cena diferentes (ex: Jogador -> UI). Para eventos que podem ter múltiplos interessados. **É a abordagem preferida na maioria dos casos.** | Para comunicação entre nós muito próximos e fortemente relacionados (ex: um pai chamando uma função em um filho). Para otimizações de performance em código crítico. |