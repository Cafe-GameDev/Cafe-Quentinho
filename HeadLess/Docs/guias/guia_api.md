# Guia de Conceitos: API (Application Programming Interface)

No contexto da Godot, a **API** é o conjunto completo de blocos de construção que a engine oferece para você criar seu jogo. São todas as classes, nós, funções, sinais e propriedades que você pode acessar via código.

## O que compõe a API da Godot?

*   **Nós:** `CharacterBody2D`, `Camera3D`, `AnimationPlayer`, etc. Cada nó é uma classe com suas próprias funções e propriedades.
*   **Recursos (Resources):** `Texture2D`, `AudioStream`, `Theme`, e todos os `Resources` customizados que criamos.
*   **Singletons Globais:** `Input`, `Engine`, `OS`, etc. São objetos sempre acessíveis que fornecem funcionalidades do motor.
*   **Tipos de Dados:** `Vector2`, `Color`, `Rect2`, `Dictionary`, etc.

## Interface vs. Implementação

A API é a **interface** pública que você usa. Você não precisa saber *como* a Godot desenha um `Sprite2D` na tela (a **implementação**), você só precisa saber que pode chamar a função `set_texture()` ou alterar a propriedade `position`.

*   **API Estável:** A documentação oficial da Godot descreve a API estável. Funções e propriedades listadas ali são seguras de usar e devem funcionar de forma consistente entre versões menores da engine.
*   **API Interna:** Funções ou propriedades com um underscore no início (ex: `_get_property_list()`) são consideradas internas. Evite usá-las, pois elas podem mudar ou ser removidas sem aviso em futuras atualizações.

## Language Identifier (Identificador de Linguagem)

Este é um conceito relacionado à documentação e tradução. É um código padronizado (ex: `en` para inglês, `pt_BR` para português do Brasil) que identifica um idioma. A Godot usa esses identificadores para gerenciar a localização do seu jogo.

Em resumo, a **documentação oficial da Godot é o manual da API da engine**. Aprender a navegar nela é a habilidade mais importante para um desenvolvedor Godot.
