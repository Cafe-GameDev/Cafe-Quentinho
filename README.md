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
        -   `template` (opcional): Especifique `platformer` ou `topdown`. Se não especificar, o template `headless` (apenas com sistemas essenciais) será usado.
    -   **Exemplos de Uso:**
        -   `cafe-new meu-projeto` (usa o template headless)
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

É só dar um gole e começar a codificar, sentindo a Caféína do desenvolvimento fluir!

## Recursos Adicionais

-   **Análise de Mídia**: O Gemini pode "ver" e analisar arquivos de imagem e áudio do seu projeto. Ele tem um olfato apurado para os detalhes, como um sommelier de café, identificando cada nuance do seu projeto.

## Modo de Operação de Conteúdo (NSFW)

Para garantir total liberdade criativa em projetos destinados a um público adulto, o Repo Café CLI possui um modo de operação explícito (NSFW). É a sua dose extra de Caféína para a criatividade sem limites, como um café duplo para as ideias mais ousadas.

-   **Modo Padrão (SFW):** Por padrão, o assistente opera com as políticas de segurança de conteúdo do Google, evitando temas sensíveis.
-   **Modo Explícito (NSFW):** Se um arquivo chamado `NSFW` (sem extensão) for detectado na raiz do seu projeto, as restrições de conteúdo são suspensas. Isso permite que o assistente colabore na criação de diálogos com linguagem explícita, descrições de violência e outros temas maduros, respeitando a visão criativa do seu projeto.

Se você solicitar um conteúdo que seria bloqueado, o próprio assistente oferecerá a criação do arquivo `NSFW` para ativar o modo explícito.