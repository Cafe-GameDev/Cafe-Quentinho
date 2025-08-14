# Guia de Padrões: Tweens

Um `Tween` é um objeto que anima uma ou mais propriedades de um nó ao longo do tempo, de forma procedural. É a ferramenta ideal para animações que não são pré-definidas, como mover a UI, fazer um personagem seguir o mouse, ou interpolar a posição da câmera.

## Como Criar um Tween (Godot 4+)

Em Godot 4, `Tweens` são criados diretamente por código, sem a necessidade de um nó na cena.

```gdscript
func animar_sprite():
    # Cria um novo tween. Ele será executado automaticamente.
    var tween = create_tween()

    # Anima a propriedade "scale" do nó $Sprite2D para o valor Vector2(2, 2)
    # A animação durará 1.0 segundo.
    tween.tween_property($Sprite2D, "scale", Vector2(2, 2), 1.0)

    # Também anima a propriedade "modulate" para a cor vermelha.
    # Por padrão, as animações acontecem em sequência.
    tween.tween_property($Sprite2D, "modulate", Color.RED, 1.0)
```

## Animações em Paralelo

Para que múltiplas animações ocorram ao mesmo tempo, use `parallel()`.

```gdscript
var tween = create_tween()
# As duas animações abaixo começarão ao mesmo tempo.
tween.parallel().tween_property($Sprite, "scale", Vector2.ZERO, 0.5)
tween.parallel().tween_property($Sprite, "rotation", TAU, 0.5)
```

## Funções de Suavização (Easing) e Transição

Para dar mais vida às animações, você pode definir como elas aceleram e desaceleram.

```gdscript
var tween = create_tween()
tween.tween_property($Sprite, "position:y", 200, 1.0) \
     .set_trans(Tween.TRANS_ELASTIC) \ # Tipo de transição (ex: elástica, pulo)
     .set_ease(Tween.EASE_OUT)       # Curva de suavização (acelera no início, desacelera no fim, etc.)
```

## Chamando Funções (Callbacks)

`Tweens` também podem chamar funções, o que é útil para sincronizar lógica com o fim de uma animação.

```gdscript
var tween = create_tween()
tween.tween_property(...) 
tween.tween_callback(queue_free) # Chama a função queue_free() ao final da animação.
```

