# Repo Café CLI

Bem-vindo ao Repo Café CLI, seu **parceiro de desenvolvimento colaborativo** para o ecossistema Godot. Prepare sua xícara, porque a jornada do código será deliciosa!

O Repo Café CLI transforma o Gemini em um copiloto que tem acesso direto e total ao seu ambiente de desenvolvimento. Em vez de você precisar copiar e colar código para obter ajuda, o Repo Café CLI já tem acesso a todo o seu projeto, incluindo scripts, cenas e a arquitetura geral do seu jogo.

Ele é, em essência, o Gemini para desenvolvedores Godot, e o melhor de tudo: **roda diretamente no seu celular via Termux!**

## Comandos da Ferramenta

O Repo Café CLI vem com um conjunto de comandos para agilizar seu desenvolvimento:

-   `repo-cafe`:
    -   **Função:** Inicia a sessão de chat com o assistente.
    -   **Uso:** `repo-cafe`

-   `cafe-new [template] <nome-do-projeto>`:
    -   **Função:** Te serve um novo "Café Quentinho" (um projeto Godot com base nos templates do Café).
    -   **Argumentos:**
        -   `template` (opcional): Especifique `platformer` ou `topdown`. Se não especificar, o template `bodyless` (apenas com sistemas essenciais) será usado.
    -   **Exemplos de Uso:**
        -   `cafe-new meu-projeto` (usa o template bodyless)
        -   `cafe-new platformer meu-jogo-plataforma`
        -   `cafe-new topdown meu-jogo-topdown`

-   `repo-cafe-update`:
    -   **Função:** Atualiza a ferramenta `repo-cafe` para a versão mais recente. O processo de atualização também garante que sua cópia local do repo-cafe esteja sincronizada com a versão da ferramenta.
    -   **Uso:** `repo-cafe-update`

-   `repo-update`:
    -   **Função:** Atualiza especificamente o repositório de conhecimento. É ideal para obter o conteúdo mais recente, que pode ser atualizado com mais frequência do que a ferramenta em si.
    -   **Uso:** `repo-update`

-   `cafe-rename`:
    -   **Função:** Renomeia arquivos e pastas recursivamente para um formato limpo e consistente, ideal para Godot e sistemas de controle de versão. Preserva maiúsculas/minúsculas e hífens, mas troca espaços por `_` e remove acentos/caracteres especiais.
    -   **Uso:** `cafe-rename --source <caminho-opcional>`

## Como Funciona?

O Repo Café CLI é um wrapper inteligente para o `gemini-cli` do Google. Ele utiliza o repositório [Repo Café](https://github.com/Café-GameDev/repo-cafe) — um curso completo de Godot em formato de texto — como uma base de conhecimento fixa. É o nosso grão especial, sempre moído na hora para o seu projeto, garantindo um aroma único em cada linha de código.

## A Filosofia "BodyLess" (Sem Corpo)

O Repo Café CLI não apenas ajuda a escrever código; ele segue e implementa uma filosofia de arquitetura robusta chamada **"BodyLess"**. O nome reflete o princípio central: **desacoplamento total**. Os sistemas são projetados para não terem "corpos" ou referências diretas uns aos outros. Em vez disso, eles se comunicam de forma indireta, criando um código mais limpo, modular e escalável.

### Os Pilares da Arquitetura

1.  **EventBus (O Quadro de Avisos):** Um Autoload/Singleton que funciona como um quadro de avisos central. Em vez de um objeto chamar uma função em outro, ele simplesmente "publica um aviso" (emite um sinal) no EventBus.
2.  **Dicionários (Os Mensageiros):** Toda a comunicação através do EventBus é feita com Dicionários. Eles são os contêineres de dados universais que carregam a informação de um sistema para o outro, sem criar dependências.
3.  **Resources (Os Contêineres de Dados):** Usamos `Resources` personalizados (`.tres`) para definir os "o quês" do nosso jogo (ex: dados de uma arma, stats de um inimigo), separando completamente os dados do comportamento.
4.  **Managers Ouvintes (Autoloads Reativos):** Nossos sistemas globais (Autoloads) não são chamados diretamente. Eles são projetados para **ouvir** os "avisos" no EventBus e reagir a eles.

### A Estrutura Padrão de Autoloads

A arquitetura "BodyLess" se manifesta em uma estrutura clara de Autoloads (Singletons), divididos em dois domínios:

#### Sistemas Globais
Gerenciam o estado geral do jogo e a comunicação entre sistemas.

-   **GlobalEvents:** O coração da comunicação. Todos os sistemas globais se comunicam através dele.
-   **GlobalMachine:** Controla a máquina de estados global (ex: `MENU`, `JOGANDO`, `PAUSADO`).
-   **SaveSystem:** Ouve os pedidos de salvar/carregar e orquestra a persistência de dados.
-   **SettingsManager:** Gerencia as configurações do jogador (áudio, vídeo, controles).
-   **InputManager:** Centraliza o gerenciamento de input, especialmente para remapeamento de teclas.
-   **AudioManager:** Gerencia a reprodução de música e efeitos sonoros.
-   **DebugConsole:** Um console de depuração para testes em tempo de execução.

#### Sistemas Locais
Gerenciam o estado *dentro* de uma cena de jogo (uma fase, um nível). Eles são persistentes, mas focados no gameplay imediato.

-   **LocalEvents:** Um EventBus para comunicação interna da cena (ex: um puzzle que abre uma porta na mesma fase).
-   **LocalMachine:** Controla a máquina de estados da cena (ex: `EXPLORANDO`, `COMBATE`, `CUTSCENE`).

**A Regra de Ouro:** A comunicação entre os domínios Global e Local é estritamente separada. `LocalEvents` é um sistema fechado, usado apenas para comunicação *dentro* de uma mesma cena (ex: um puzzle abrindo uma porta próxima). Ele **nunca** deve ser usado como uma "escada" para o `GlobalEvents`.

Se um nó dentro da cena, como o Player, precisa de uma ação global (ex: notificar sua morte para que a `GlobalMachine` possa mudar o estado do jogo), ele deve emitir o sinal **diretamente no `GlobalEvents`**. A responsabilidade de escolher o canal correto (Local ou Global) é sempre do emissor original do evento.

### A Estrutura da Cena Principal: SceneControl e Viewport

Além da comunicação, a arquitetura "BodyLess" define uma estrutura de cena robusta para gerenciar o jogo, a UI e o dimensionamento da tela. A cena principal do jogo, chamada `SceneControl.tscn`, não é um Autoload, mas sim a primeira cena que o Godot carrega.

Sua estrutura é a seguinte:
-   **`SceneControl` (Node - O Maestro):** O nó raiz. Seu script é responsável por orquestrar quais cenas estão ativas, realizando as transições (carregando e descarregando fases) em resposta a eventos do `GlobalEvents`.
    -   **`ViewportContainer` > `SubViewport` (O Palco do Jogo):** Este contêiner especial abriga o "mundo" do jogo. Todas as cenas de gameplay (fases, níveis) e suas HUDs específicas são instanciadas aqui dentro. O uso de um `SubViewport` é crucial, pois ele desacopla a resolução do jogo da resolução da janela, permitindo:
        -   **Pixel-perfect scaling:** Renderizar um jogo de pixel art em baixa resolução e escalá-lo perfeitamente para telas HD/4K sem borrões.
        -   **Efeitos de post-processing:** Aplicar shaders e efeitos visuais à tela inteira do jogo sem afetar os menus.
    -   **`CanvasLayer` (A Interface Global):** Este layer flutua *acima* do `Viewport` do jogo. Ele é o lar de todas as interfaces que não fazem parte do mundo do jogo, como:
        -   Menu Principal / Tela de Título
        -   Menu de Pause
        -   Menu de Configurações
        -   Pop-ups globais (Ex: "Sair do jogo?", "Salvar alterações?")

Essa separação garante que a UI global nunca interfira com a câmera ou a resolução do jogo, e que o `SceneControl` atue como um verdadeiro controlador de entrada e saída de cenas.

### Exemplo de Fluxo (Salvando Configurações)
1.  O jogador clica no botão "Salvar". O botão emite um sinal `request_save_settings` no `GlobalEvents`.
2.  O `SettingsManager` ouve este sinal, coleta seus dados em um Dicionário e emite `save_settings_data({"audio": ...})` no `GlobalEvents`.
3.  O `SaveSystem` ouve `save_settings_data`, salva os dados em disco e emite `settings_saved_successfully`.
4.  A UI ouve o sinal de sucesso e mostra uma notificação.

O resultado é um código robusto e desacoplado, nossa receita para um projeto tão confiável quanto um bom café.

## Instalação

Para instalar o Repo Café CLI, você precisa ter o [Node.js](https://nodejs.org/) (que inclui o NPM) instalado em seu sistema.

Com o Node.js pronto, abra seu terminal e execute o seguinte comando:

```bash
npm install -g repo-cafe
```

E pronto! Seu café está coado e pronto para ser saboreado, seja um espresso rápido ou um coado demorado.

## Como Usar

Após a instalação, simplesmente abra um novo terminal e execute:

```bash
repo-cafe
```

É só dar um gole e começar a codificar, sentindo a Cafeína do desenvolvimento fluir!

## Recursos Adicionais

-   **Análise de Mídia**: O Gemini pode "ver" e analisar arquivos de imagem e áudio do seu projeto. Ele tem um olfato apurado para os detalhes, como um sommelier de café, identificando cada nuance do seu projeto.

## Modo de Operação de Conteúdo (NSFW)

Para garantir total liberdade criativa em projetos destinados a um público adulto, o Repo Café CLI possui um modo de operação explícito (NSFW). É a sua dose extra de Cafeína para a criatividade sem limites, como um café duplo para as ideias mais ousadas.

-   **Modo Padrão (SFW):** Por padrão, o assistente opera com as políticas de segurança de conteúdo do Google, evitando temas sensíveis.
-   **Modo Explícito (NSFW):** Se um arquivo chamado `NSFW` (sem extensão) for detectado na raiz do seu projeto, as restrições de conteúdo são suspensas. Isso permite que o assistente colabore na criação de diálogos com linguagem explícita, descrições de violência e outros temas maduros, respeitando a visão criativa do seu projeto.

Se você solicitar um conteúdo que seria bloqueado, o próprio assistente oferecerá a criação do arquivo `NSFW` para ativar o modo explícito.