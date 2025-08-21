# Game Design Document (GDD) Específico: Modo 3D

## 1. Visão Geral

Este documento detalha as mecânicas e elementos específicos do modo de jogo 3D dentro do "Cafe-Quentinho Template". O modo 3D oferece um ambiente tridimensional completo, com suporte a duas perspectivas de câmera principais: Primeira Pessoa e Terceira Pessoa. É ideal para jogos de aventura, RPGs, shooters ou exploração em 3D. Ele se integra à arquitetura "BodyLess" e utiliza os sistemas gerais do template (UI, inventário, save, etc.).

## 2. Mecânicas de Jogo

### 2.1. Movimento do Jogador

*   **Tipo:** Movimento livre em 3D (frente, trás, strafe esquerda/direita).
*   **Controles:** WASD (teclado) ou Left Stick (gamepad) para movimento.
*   **Corrida (`Sprint`):** Pressionar `Ctrl` (teclado) ou Left Stick (gamepad) para correr, aumentando a velocidade de movimento temporariamente.
*   **Agachar (`Crouch`):** Pressionar `Shift` (teclado) ou Botão B (gamepad) para agachar, reduzindo a altura do jogador e a velocidade de movimento.
*   **Velocidade:** Definida por atributos no `PlayerData` (ou `PlayerResource`) para caminhada, corrida e agachamento.
*   **Colisão:** O jogador será um `CharacterBody3D` e interagirá com o ambiente via colisões.

### 2.2. Perspectivas de Câmera

*   **Primeira Pessoa:**
    *   **Controle:** Rotação da câmera controlada pelo movimento do mouse (eixo X e Y) ou Right Stick (gamepad).
    *   **Imersão:** Foco na visão do jogador, ideal para shooters e jogos de exploração imersivos.
*   **Terceira Pessoa:**
    *   **Controle:** Câmera segue o jogador, com rotação controlada pelo movimento do mouse (eixo X e Y) ou Right Stick (gamepad) para orbitar o jogador.
    *   **Visibilidade:** Permite ver o modelo do personagem, ideal para RPGs de ação e jogos de aventura.
*   **Transição:** Possibilidade de transição suave entre as perspectivas (se aplicável, via sinal).

### 2.3. Combate

*   **Ataque Corpo a Corpo:** O jogador pode atacar inimigos próximos com armas corpo a corpo (ex: soco, espada).
    *   **Controle:** Botão esquerdo do mouse ou botão de ataque (gamepad).
    *   **Animação:** Animações de ataque para cada arma.
    *   **Hitbox:** `Area3D` para detecção de acerto.
*   **Ataque à Distância:** O jogador pode usar armas de longo alcance (ex: arco, pistola).
    *   **Controle:** Botão direito do mouse ou botão de mira/disparo (gamepad).
    *   **Projéteis:** Instanciação de cenas de projéteis (flechas, balas) que se movem e colidem com inimigos/ambiente.
*   **Recarga:** Pressionar `R` (teclado) ou Botão X (gamepad) para recarregar a arma equipada.
*   **Habilidade Especial:** Pressionar `Q` (teclado) ou Botão Y (gamepad) para ativar uma habilidade especial (se houver).
*   **Dano:** Calculado com base no atributo de dano da arma e na defesa do inimigo. Exibição de texto flutuante de dano.
*   **Saúde:** Jogador e inimigos possuem um atributo de saúde. Ao chegar a zero, o personagem é derrotado.

### 2.4. Interação com Itens

*   **Coleta:** Jogador pode coletar itens no chão (ex: poções, armas, moedas) ao passar por cima ou interagir (tecla `E`).
*   **Inventário:** Itens coletados são adicionados ao inventário (`InventoryManager`).
*   **Uso de Itens:** Poções de cura, poções de buff, etc., podem ser usadas do inventário.

## 3. Elementos de Jogo

### 3.1. Jogador (`Player_3D.tscn`)

*   **Nó Raiz:** `CharacterBody3D`.
*   **Componentes Visuais:** `MeshInstance3D` para o modelo 3D do personagem, `AnimationPlayer` ou `AnimationTree` para animações.
*   **Câmera:** `Camera3D` como filho do jogador (primeira pessoa) ou como um nó separado seguindo o jogador (terceira pessoa).
*   **Scripts:**
    *   `player_3d_first_person.gd` (gerencia movimento, input, câmera em primeira pessoa).
    *   `player_3d_third_person.gd` (gerencia movimento, input, câmera em terceira pessoa).
    *   Um script base `player_3d.gd` pode ser usado para lógica comum.

### 3.2. Inimigos (`Enemy_3D.tscn`)

*   **Nó Raiz:** `CharacterBody3D` ou `StaticBody3D`.
*   **Componentes Visuais:** `MeshInstance3D` para o modelo 3D, `AnimationPlayer` para animações.
*   **Script:** `enemy_3d.gd` (gerencia IA, saúde, dano, morte, loot).
*   **Exemplos de IA:**
    *   **Boneco de Treino:** Estático, apenas recebe dano.
    *   **Robô Patrulha:** Segue um caminho predefinido (waypoints 3D) ou patrulha uma área.
    *   **Caçador:** Persegue o jogador ativamente, navegando pelo ambiente 3D.

### 3.3. Itens

*   **Cenas de Itens (Exemplos):**
    *   `WeaponPickup_3D.tscn` (Area3D): Representa uma arma no chão que pode ser coletada.
    *   `HealingPotion_3D.tscn` (Area3D): Representa uma poção de cura no chão.
*   **Recursos de Dados (`Resource`s):** Conforme definido no GDD Geral, cada item terá um `Resource` (`ItemData`, `WeaponData`, `HealingPotionData`, `DamageBoostPotionData`) para seus atributos e chaves de tradução.

### 3.4. Armas

*   **Recursos de Dados (`Resource`s):** Conforme definido no GDD Geral (`WeaponData`).
*   **Implementação:** A lógica de ataque, recarga e uso de armas será gerenciada pelo script do jogador, utilizando os dados dos `WeaponData` resources. Modelos 3D para armas.

## 4. Construção de Cenários

*   **MeshInstance3D / StaticBody3D:** O ambiente será construído usando modelos 3D (meshes) e colisões estáticas.
*   **NavigationMesh:** Para IA de inimigos, um `NavigationMesh` será gerado para permitir que os inimigos naveguem pelo ambiente.
*   **Iluminação:** Configuração de luzes (DirectionalLight3D, OmniLight3D, SpotLight3D) para criar a atmosfera do cenário.
*   **Pontos de Spawn:** `Marker3D`s serão usados para definir pontos de spawn de inimigos e itens no mapa.

## 5. Integração com Sistemas Gerais

*   **SaveSystem:** O estado do jogador (posição, rotação, vida, inventário, arma equipada, perspectiva de câmera) e o estado dos inimigos/itens no cenário serão salvos e carregados.
*   **InventoryManager:** Gerenciará a adição, remoção e uso de itens coletados.
*   **InputManager:** Traduzirá os inputs do jogador em ações de movimento e combate.
*   **HUD:** Exibirá a barra de vida, hotbar e outros elementos relevantes para o modo 3D.
*   **I18N:** Todos os textos de UI, nomes de itens/armas/inimigos e descrições serão traduzíveis.
*   **TooltipManager:** Exibirá tooltips para itens no inventário ou elementos interativos no cenário.

## 6. Considerações Adicionais

*   **Áudio Espacial:** Efeitos sonoros de passos, inimigos, ataques e interações com o ambiente terão posicionamento 3D.
*   **Efeitos Visuais:** Partículas para acertos, explosões, coleta de itens, efeitos de habilidade.
*   **Camera Shake:** Tremores de câmera em eventos de impacto (ex: jogador levando dano, explosões).
*   **Post-Processing:** Efeitos de pós-processamento (bloom, SSAO, etc.) para melhorar a qualidade visual.
*   **FSR (FidelityFX Super Resolution):** Implementação para otimização de desempenho visual.

---

**Este GDD detalha o blueprint para o desenvolvimento do modo de jogo 3D, garantindo que todas as mecânicas e elementos sejam implementados de forma consistente e integrada com a arquitetura "BodyLess".**
