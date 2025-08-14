# Planejamento de Autoloads Futuros

Este documento detalha a arquitetura e as responsabilidades dos futuros Singletons (Autoloads) a serem implementados no projeto. O objetivo é definir claramente os limites de cada sistema antes do desenvolvimento, garantindo uma base de código modular, escalável e fácil de manter.

A comunicação entre estes managers seguirá a regra de ouro da arquitetura:
- **Eventos Globais:** Comunicação que afeta o estado geral do jogo ou múltiplos sistemas desacoplados (ex: `missao_concluida`, `salvar_jogo`) passará pelo `GlobalEvents`.
- **Eventos Locais:** Comunicação específica de gameplay que não precisa ser global (ex: `dano_recebido`, `inimigo_morreu`) passará pelo futuro `LocalEvents`.

---

## 1. `LocalEvents`

- **Propósito Principal:** Servir como um "Barramento de Eventos" secundário, focado exclusivamente em eventos de gameplay.
- **Responsabilidades:**
    - Declarar sinais relacionados a interações diretas no jogo, como `dano_causado`, `vida_curada`, `inimigo_derrotado`, `item_coletado_no_mundo`.
    - Desafogar o `GlobalEvents` de sinais de alta frequência que não interessam a sistemas globais como o `GameManager` ou `SceneManager`.
- **Interação com Outros Sistemas:**
    - Entidades de gameplay (Player, Inimigos, Itens) emitirão sinais no `LocalEvents`.
    - Sistemas de gameplay (UI do jogador, `QuestManager`, `PlayerState`) ouvirão esses sinais para se atualizarem.
- **Exemplo de Uso:** Quando um inimigo morre, seu script emite `LocalEvents.inimigo_derrotado.emit(self)`. O `QuestManager` pode ouvir esse sinal para atualizar um objetivo de missão, e o `PlayerState` pode ouvir para conceder XP, mas o `GameManager` não é notificado, pois a morte de um único inimigo não altera o estado global do jogo.

---

## 2. `SaveManager`

- **Propósito Principal:** Orquestrar o processo de salvar e carregar o progresso do jogo.
- **Responsabilidades:**
    - Ouvir os sinais `salvar_jogo_requisitado` e `carregar_jogo_requisitado` do `GlobalEvents`.
    - Ao salvar, ele emitirá `coletar_dados_para_salvar` no `GlobalEvents`. Outros managers (`PlayerState`, `WorldManager`, `QuestManager`) responderão emitindo seus dados. O `SaveManager` agrupará tudo em um grande dicionário.
    - Serializar o dicionário de save (provavelmente para JSON) e escrevê-lo em um arquivo em `user://`.
    - Ao carregar, ele lerá o arquivo, desserializará os dados e emitirá `dados_do_jogo_carregados` com os dados específicos para cada sistema, para que eles possam restaurar seu estado.
- **Interação com Outros Sistemas:** Atua como um "maestro" do processo de persistência, comunicando-se com todos os managers que possuem dados a serem salvos.
- **Exemplo de Uso:** O jogador clica em "Salvar" no menu. A UI emite `salvar_jogo_requisitado`. O `SaveManager` ouve, inicia o processo de coleta de dados e salva o arquivo final.

---

## 3. `WorldManager`

- **Propósito Principal:** Gerenciar o estado físico e persistente do mundo do jogo.
- **Responsabilidades:**
    - Manter um registro de estados de objetos no mundo que podem mudar permanentemente (ex: `{"ponte_principal_consertada": true, "porta_castelo_aberta": false}`).
    - Ouvir sinais do `GlobalEvents` (como `missao_concluida`) para acionar mudanças no mundo físico (ativar/desativar nós, mudar sprites, etc.).
    - Fornecer seus dados de estado ao `SaveManager` quando solicitado.
    - Restaurar o estado físico do mundo ao receber dados do `SaveManager` no carregamento.
- **Interação com Outros Sistemas:** É o principal ouvinte para as consequências de alto nível do `QuestManager`.
- **Exemplo de Uso:** O `QuestManager` emite `missao_concluida("chave_do_castelo")`. O `WorldManager` ouve e chama uma função no nó da porta do castelo para destrancá-la.

---

## 4. `QuestManager`

- **Propósito Principal:** Rastrear o progresso do jogador em todas as missões.
- **Responsabilidades:**
    - Carregar todas as `QuestData` (Resources) do projeto.
    - Manter o estado de cada missão para o jogador.
    - Ouvir sinais do `LocalEvents` (como `inimigo_derrotado`) para atualizar objetivos.
    - Emitir sinais no `GlobalEvents` (como `missao_concluida`) quando o estado de uma missão principal muda.
    - Fornecer seus dados de estado (missões ativas e concluídas) ao `SaveManager`.
- **Interação com Outros Sistemas:** Ouve o `LocalEvents` para progresso e informa o `GlobalEvents` sobre o resultado.
- **Exemplo de Uso:** Ouve `LocalEvents.inimigo_derrotado` e, se o inimigo for um "goblin", incrementa o contador da missão "Mate 10 goblins".

---

## 5. `FadeManager`

- **Propósito Principal:** Controlar transições de tela suaves (fade-in/fade-out).
- **Responsabilidades:**
    - Controlar uma `CanvasLayer` com um `ColorRect` preto que fica sobre toda a tela.
    - Fornecer funções globais simples, como `FadeManager.fade_para_preto(duracao)` e `FadeManager.fade_do_preto(duracao)`.
    - Usar `Tweens` para animar a opacidade do `ColorRect`.
    - Emitir um sinal `fade_concluido` quando a transição termina.
- **Interação com Outros Sistemas:** Será usado principalmente pelo `SceneManager` para suavizar as transições de cena.
- **Exemplo de Uso:** `SceneManager` chama `await FadeManager.fade_para_preto(0.5)`, troca a cena e depois chama `await FadeManager.fade_do_preto(0.5)`.

---

## 6. `PlayerState`

- **Propósito Principal:** Ser o ponto de acesso global e único para os dados e o estado do jogador.
- **Responsabilidades:**
    - Manter uma referência ao nó do jogador atual na cena.
    - Armazenar os dados de estado do jogador: vida atual/máxima, mana, estamina, status (envenenado, etc.), inventário.
    - Fornecer funções para modificar esses dados (ex: `aplicar_dano(valor)`, `adicionar_item(item_data)`).
    - Ouvir `LocalEvents` para reagir a eventos de gameplay (ex: ouvir `item_coletado` para adicionar ao inventário).
    - Fornecer seus dados ao `SaveManager`.
- **Interação com Outros Sistemas:** Centraliza os dados do jogador, evitando que cada sistema (UI, inimigos) precise buscar o nó do jogador na árvore.
- **Exemplo de Uso:** Um script de inimigo, ao atacar, chamaria `PlayerState.aplicar_dano(10)` em vez de tentar encontrar o nó do jogador e chamar uma função nele.

---

## 7. `LootManager` (ou `ItemDatabase`)

- **Propósito Principal:** Gerenciar todos os itens do jogo e a lógica de geração de loot.
- **Responsabilidades:**
    - No início do jogo, carregar todos os `Resources` de itens (`ItemData`, `WeaponData`, etc.) em um dicionário para acesso rápido.
    - Fornecer uma função para obter um item por seu ID (ex: `LootManager.get_item_data("pocao_vida")`).
    - Conter a lógica para processar tabelas de loot (`LootTableData`). Uma função `LootManager.rolar_tabela(tabela)` receberia uma tabela e retornaria os itens gerados com base nos pesos e chances.
- **Interação com Outros Sistemas:** Usado por inimigos (ao morrerem), baús (ao serem abertos) e pelo `QuestManager` (para definir recompensas).
- **Exemplo de Uso:** Um inimigo morre e chama `LootManager.rolar_tabela(self.loot_table)`. O manager retorna um array de itens, e o script do inimigo instancia esses itens no mundo.

---

## 8. `PoolManager`

- **Propósito Principal:** Otimizar a performance gerenciando a reutilização de nós instanciados com frequência.
- **Responsabilidades:**
    - Manter "piscinas" (pools) de nós pré-instanciados e desativados (ex: balas, efeitos de partícula, inimigos comuns).
    - Fornecer uma função `get_instancia(nome_pool)` que retorna um nó da piscina (e o ativa).
    - Fornecer uma função `retornar_instancia(no)` que desativa o nó e o devolve à piscina para ser reutilizado, em vez de destruí-lo com `queue_free()`.
- **Interação com Outros Sistemas:** É um sistema de baixo nível. Scripts que criam muitos objetos (ex: arma do jogador) o utilizariam para obter e devolver instâncias.
- **Exemplo de Uso:** A arma do jogador, em vez de `load("res://bala.tscn").instantiate()`, chamaria `PoolManager.get_instancia("balas")`. A bala, ao colidir ou sair da tela, chamaria `PoolManager.retornar_instancia(self)`.

---

## 9. `UIManager`

- **Propósito Principal:** Orquestrar a lógica de alto nível da interface do usuário.
- **Responsabilidades:**
    - Gerenciar um "stack" ou fila de janelas e pop-ups para garantir que apenas uma janela modal esteja ativa por vez.
    - Controlar a exibição de elementos globais da UI, como notificações ("Missão Atualizada!"), dicas de interação ("Pressione E para abrir") e o cursor do mouse.
    - Agir como um intermediário para o HUD, ouvindo `LocalEvents` (como `PlayerState.vida_alterada`) e atualizando os elementos do HUD.
- **Interação com Outros Sistemas:** Ouve sinais de todos os outros sistemas para manter a UI sincronizada com o estado do jogo.
- **Exemplo de Uso:** O `QuestManager` emite `objetivo_atualizado`. O `UIManager` ouve e exibe uma notificação no canto da tela por 5 segundos.
