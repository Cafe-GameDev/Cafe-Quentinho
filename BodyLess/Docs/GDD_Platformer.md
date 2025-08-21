# Game Design Document (GDD) Específico: Modo Platformer (2D)

## 1. Visão Geral

Este documento detalha as mecânicas e elementos específicos do modo de jogo Platformer dentro do "Cafe-Quentinho Template". O modo Platformer foca em movimento preciso, pulos e interação com plataformas, ideal para jogos de plataforma clássicos ou com elementos de puzzle. Ele se integra à arquitetura "BodyLess" e utiliza os sistemas gerais do template (UI, inventário, save, etc.).

## 2. Mecânicas de Jogo

### 2.1. Movimento do Jogador

*   **Tipo:** Movimento horizontal (esquerda/direita) e pulo.
*   **Controles:** A/D (teclado) ou Left Stick (horizontal) para movimento, Espaço (teclado) ou Botão A (gamepad) para pular.
*   **Pulo:**
    *   **Altura Variável:** Pulo mais alto quanto mais tempo o botão é pressionado (até um limite).
    *   **Duplo Pulo (Opcional):** Capacidade de realizar um segundo pulo no ar.
    *   **Coyote Time:** Pequena janela de tempo após sair de uma plataforma onde o jogador ainda pode pular.
    *   **Jump Buffer:** Pequena janela de tempo antes de tocar o chão onde o input de pulo é armazenado e executado assim que o jogador aterrissa.
*   **Velocidade:** Definida por um atributo no `PlayerData` (ou `PlayerResource`).
*   **Colisão:** O jogador será um `CharacterBody2D` e interagirá com o ambiente via colisões e detecção de chão.

### 2.2. Combate

*   **Ataque Corpo a Corpo:** O jogador pode atacar inimigos próximos com armas corpo a corpo (ex: soco, espada).
    *   **Controle:** Botão esquerdo do mouse ou botão de ataque (gamepad).
    *   **Animação:** Animações de ataque para cada arma.
    *   **Hitbox:** `Area2D` para detecção de acerto.
*   **Ataque à Distância:** O jogador pode usar armas de longo alcance (ex: arco, pistola).
    *   **Controle:** Botão direito do mouse ou botão de mira/disparo (gamepad).
    *   **Projéteis:** Instanciação de cenas de projéteis (flechas, balas) que se movem e colidem com inimigos/ambiente.
*   **Dano:** Calculado com base no atributo de dano da arma e na defesa do inimigo. Exibição de texto flutuante de dano.
*   **Saúde:** Jogador e inimigos possuem um atributo de saúde. Ao chegar a zero, o personagem é derrotado.

### 2.3. Interação com Itens

*   **Coleta:** Jogador pode coletar itens no chão (ex: poções, armas, moedas) ao passar por cima ou interagir (tecla `E`).
*   **Inventário:** Itens coletados são adicionados ao inventário (`InventoryManager`).
*   **Uso de Itens:** Poções de cura, poções de buff, etc., podem ser usadas do inventário.

## 3. Elementos de Jogo

### 3.1. Jogador (`Player_Platformer.tscn`)

*   **Nó Raiz:** `CharacterBody2D`.
*   **Componentes Visuais:** `AnimatedSprite2D` para animações de movimento, pulo e ataque.
*   **Câmera:** `Camera2D` com `smoothing` e `limits` para seguir o jogador de forma suave e dentro dos limites do mapa, com foco vertical para plataformas.
*   **Script:** `player_platformer.gd` (gerencia movimento, pulo, input, estado, interação).

### 3.2. Inimigos (`Enemy_Platformer.tscn`)

*   **Nó Raiz:** `CharacterBody2D` ou `StaticBody2D`.
*   **Componentes Visuais:** `AnimatedSprite2D` para animações.
*   **Script:** `enemy_platformer.gd` (gerencia IA, saúde, dano, morte, loot).
*   **Exemplos de IA:**
    *   **Boneco de Treino:** Estático, apenas recebe dano.
    *   **Robô Patrulha:** Patrulha uma plataforma, virando ao chegar na borda ou encontrar um obstáculo.
    *   **Caçador:** Persegue o jogador ativamente, pulando plataformas e evitando quedas.

### 3.3. Itens

*   **Cenas de Itens (Exemplos):**
    *   `WeaponPickup_Platformer.tscn` (Area2D): Representa uma arma no chão que pode ser coletada.
    *   `HealingPotion_Platformer.tscn` (Area2D): Representa uma poção de cura no chão.
*   **Recursos de Dados (`Resource`s):** Conforme definido no GDD Geral, cada item terá um `Resource` (`ItemData`, `WeaponData`, `HealingPotionData`, `DamageBoostPotionData`) para seus atributos e chaves de tradução.

### 3.4. Armas

*   **Recursos de Dados (`Resource`s):** Conforme definido no GDD Geral (`WeaponData`).
*   **Implementação:** A lógica de ataque e uso de armas será gerenciada pelo script do jogador, utilizando os dados dos `WeaponData` resources.

## 4. Construção de Cenários

*   **TileMap:** O ambiente será construído usando `TileMap`s para criar plataformas, paredes, obstáculos e elementos decorativos.
*   **Colisões:** As colisões do `TileMap` serão configuradas para interagir com o `CharacterBody2D` do jogador e dos inimigos, permitindo detecção de chão e paredes.
*   **Plataformas Móveis:** Implementação de plataformas que se movem em padrões predefinidos.
*   **Pontos de Spawn:** `Marker2D`s serão usados para definir pontos de spawn de inimigos e itens no mapa.

## 5. Integração com Sistemas Gerais

*   **SaveSystem:** O estado do jogador (posição, vida, inventário, arma equipada) e o estado dos inimigos/itens no cenário serão salvos e carregados.
*   **InventoryManager:** Gerenciará a adição, remoção e uso de itens coletados.
*   **InputManager:** Traduzirá os inputs do jogador em ações de movimento e combate.
*   **HUD:** Exibirá a barra de vida, hotbar e outros elementos relevantes para o modo Platformer.
*   **I18N:** Todos os textos de UI, nomes de itens/armas/inimigos e descrições serão traduzíveis.
*   **TooltipManager:** Exibirá tooltips para itens no inventário ou elementos interativos no cenário.

## 6. Considerações Adicionais

*   **Áudio Espacial:** Efeitos sonoros de pulo, aterrissagem, inimigos, ataques e interações com o ambiente terão posicionamento 2D.
*   **Efeitos Visuais:** Partículas para pulo, aterrissagem, acertos, explosões, coleta de itens.
*   **Camera Shake:** Pequenos tremores de câmera em eventos de impacto (ex: jogador levando dano, explosões).
*   **Parallax Backgrounds:** Para criar profundidade visual nos cenários.

---

**Este GDD detalha o blueprint para o desenvolvimento do modo de jogo Platformer, garantindo que todas as mecânicas e elementos sejam implementados de forma consistente e integrada com a arquitetura "BodyLess".**
