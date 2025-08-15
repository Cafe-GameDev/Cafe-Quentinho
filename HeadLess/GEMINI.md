# Regra Geral de Comunicação

- **Idioma:** Todas as interações do assistente com o usuário devem ser em **português** amenos que peçam explicitamente por outro idioma, caso isso aconteça, vc precisa editar esse gemini.md adicionando no topo dele a linha "O usuario solicitou um idioma diferente: $idioma".

executavel da godot: "C:\Users\bruno\Documents\Godot_v4.4.1-stable_win64.exe"

# Core Mandates

- **Fluxo de Interação Principal:** Proposta, Pergunta / Confirmação em Chat, Proponha novamente confirmando, Execute, Teste (executando "C:\Users\bruno\Documents\Godot_v4.4.1-stable_win64_console.exe").
- **Windows:** Você está em ambiente Windows, **NUNCA** tente usar comandos Linux / Unix / Mac aqui.
- **EventBus (GlobalEvents):** **NUNCA** ignore ou evite o uso do `GlobalEvents` (EventBus). Todas as comunicações entre Singletons, cenas e outros componentes devem ser planejadas e implementadas através da emissão e conexão de sinais no `GlobalEvents`. Antes de implementar qualquer comunicação, pergunte-se: "Como posso conectar isso ao EventBus?".
- **Debug Console:** Mantenha o Debug Console sempre atualizado com todos os sinais do `GlobalEvents`.
- **I18N:** Mantenha as traduções sempre atualizdas, sempre que for por um texto na tela, esse texto precisa vir de uma tradução.

# Arquitetura e Documentação do Projeto

Esta seção detalha a arquitetura dos sistemas centrais (Singletons/Autoloads) e das cenas principais do projeto.

## I. Arquitetura de Singletons (Autoloads)

O projeto é construído sobre uma arquitetura de Singletons desacoplados que se comunicam através de um "Barramento de Eventos" (Event Bus). Esta é a regra mais importante da nossa arquitetura.

### A Regra de Ouro: Comunicação via `GlobalEvents`

- **O que é?** `GlobalEvents` é um Singleton que atua como um quadro de avisos central. Ele não possui lógica, apenas uma lista de todos os sinais globais que podem ser emitidos no jogo.
- **Como funciona?**
    1.  Um sistema (ex: `InputManager`) emite um sinal no `GlobalEvents` para anunciar que algo aconteceu (ex: `pause_toggled`).
    2.  Outros sistemas (ex: `GameManager`) "escutam" esse sinal e reagem a ele.
- **Por que é crucial?** O `InputManager` não precisa saber que o `GameManager` existe, e vice-versa. Isso cria um **desacoplamento total**. Se removermos o `GameManager`, o `InputManager` continua funcionando sem erros.
- **Regra Inviolável:** **TODA** comunicação entre Singletons (Managers) **DEVE** ocorrer através de sinais no `GlobalEvents`. Uma chamada direta de um manager para outro (ex: `GameManager.alguma_funcao()`) é estritamente proibida, pois cria acoplamento e quebra a arquitetura.

### Comunicação Local vs. Global

- **`GlobalEvents`:** Usado para eventos que afetam o estado geral do jogo ou múltiplos sistemas (pausar, mudar de cena, salvar configurações).
- **`LocalEvents` (Futuro):** Será um segundo Event Bus, mas para eventos de gameplay que não precisam ser globais. Por exemplo, a interação entre um `Player` e um `Inimigo` (dano, morte do inimigo) emitiria sinais no `LocalEvents`. A UI de vida do jogador ouviria esses sinais, mas o `GameManager` não precisaria saber sobre cada golpe trocado.

---

## II. Documentação dos Singletons (Autoloads)

A ordem de execução dos Autoloads é definida em `project.godot`.

### 1. `GlobalEvents`
- **Arquivo:** `Singletons/Scripts/global_events.gd`
- **Propósito:** Atuar como o Barramento de Eventos central do jogo.
- **O que faz:**
    - Declara todos os sinais globais disponíveis no projeto.
    - Serve como a única fonte de verdade para a comunicação entre sistemas desacoplados.
- **O que NÃO faz:**
    - **Não contém nenhuma lógica.** É apenas uma lista de declarações de `signal`.
    - Não emite nem escuta seus próprios sinais. Ele é um intermediário passivo.