# Template "BodyLess" - Café Quentinho

O "BodyLess" é um kit de desenvolvimento e template de fundação "sem corpo" para a Godot Engine. Seu propósito não é ser um jogo, mas sim fornecer uma arquitetura de sistemas essenciais, robusta e escalável, que sirva como o ponto de partida definitivo para novos projetos. Ele foi concebido para resolver o problema comum de desenvolvedores que negligenciam ou adiam a implementação de sistemas cruciais, permitindo que as equipes de desenvolvimento foquem no que realmente importa: a criação da lógica e conteúdo do jogo (o "corpo").

Ele serve como base para outros templates do ecossistema "Café Quentinho", como o `TopDown` e o `Platformer`, e também é projetado para ser facilmente acoplado a projetos já existentes.

## Pilares da Arquitetura

A filosofia do template se baseia em quatro pilares fundamentais:

*   **Desacoplamento Total (Event-Driven):** A comunicação entre os sistemas principais é feita exclusivamente através de um "Barramento de Eventos" (`GlobalEvents`). Nenhum manager tem conhecimento direto sobre o outro, permitindo modificações e substituições sem quebrar o projeto.
*   **Modularidade e Responsabilidade Única:** Cada sistema principal é um Singleton (Autoload) com uma responsabilidade claramente definida, resultando em código limpo e fácil de manter.
*   **Orientado a Dados:** Separação entre lógica e dados, incentivando o uso de `Resources` e Dicionários para gerenciar o estado do jogo.
*   **Pronto para Produção:** Funcionalidades essenciais para um jogo completo já vêm pré-configuradas.

## Funcionalidades Principais

O template oferece os seguintes sistemas pré-configurados, com foco em eficiência e boas práticas:

### Singletons (Autoloads)

*   **`GlobalEvents` (Event Bus):**
    *   **Propósito:** O coração da comunicação desacoplada. Contém exclusivamente declarações de `signal`, atuando como um quadro de avisos central e passivo para eventos globais.
*   **`SceneManager`:**
    *   **Propósito:** Gerenciar o carregamento, descarregamento e transições de cenas de forma eficiente e controlada usando um sistema de pilha (`push`/`pop`).
*   **`AudioManager`:**
    *   **Propósito:** Centralizar o carregamento e a reprodução de música e efeitos sonoros (SFX).
    *   **Eficiência:** Carrega sons dinamicamente de pastas, os categoriza automaticamente e usa um pool de players para SFX, evitando que sons se cortem.
*   **`SettingsManager`:**
    *   **Propósito:** Gerenciar o estado das configurações do jogo (áudio, vídeo, etc.) em um dicionário. Ele aplica as configurações e reage a mudanças, mas não lida com salvamento/carregamento.
*   **`SaveSystem`:**
    *   **Propósito:** Único responsável por interagir com o sistema de arquivos. Ele salva e carrega dicionários de dados (como as configurações do `SettingsManager`) em formato JSON no diretório `user://`.
*   **`InputManager`:**
    *   **Propósito:** Traduzir input bruto (teclado, controle) em sinais de "intenção" para o `GlobalEvents`, desacoplando a entrada física da ação do jogo.
*   **`DebugConsole`:**
    *   **Propósito:** Fornecer feedback visual para depuração em tempo real, ouvindo todos os sinais do `GlobalEvents` e exibindo um log formatado.

### Sistema de UI Reativo

*   Cenas de UI (ex: `main_menu`, `pause_menu`, `settings_menu`) são "burras" por design. Elas apenas apresentam botões, emitem sinais de "requisição" para o `GlobalEvents` (ex: `scene_push_requested`) e reagem a sinais de mudança de estado para controlar sua visibilidade.

### Internacionalização (I18N)

*   Estrutura completa para tradução usando arquivos `.po`. Os textos na UI são definidos por chaves (ex: `UI_NEW_GAME`) diretamente no editor, permitindo que o `TranslationServer` do Godot os traduza automaticamente.

## Sugestões para Atualizações Futuras

*   **UI/UX (Mobile & Gamepad):** Adicionar HUDs para touch e gamepad, e garantir navegação completa dos menus via controle.
*   **Sistemas Essenciais:** Implementar remapeamento de inputs e um conjunto robusto de opções de acessibilidade (modos para daltônicos, legendas personalizáveis, etc.).
*   **Visuais:** Adicionar exemplos de partículas e shaders para demonstrar efeitos visuais.
