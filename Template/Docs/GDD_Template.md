# Game Design Document (GDD): Template de Fundação "Café Quentinho"

## 1. Visão do Projeto

O "Café Quentinho" é um **template de fundação "sem cabeça"** para a Godot Engine. Seu propósito não é ser um jogo, mas sim fornecer uma arquitetura de sistemas essenciais, robusta e escalável, que sirva como o ponto de partida definitivo para novos projetos. Ele é projetado para que os desenvolvedores possam focar na criação da lógica e conteúdo de gameplay, enquanto os sistemas de gerenciamento (estado, cenas, áudio, configurações, etc.) já estão pré-configurados e otimizados, seguindo as melhores práticas de desenvolvimento.

## 2. Pilares da Arquitetura

A filosofia do template se baseia em quatro pilares fundamentais:

*   **Desacoplamento Total (Event-Driven):** A comunicação entre os sistemas principais é feita exclusivamente através de um "Barramento de Eventos" (`GlobalEvents`). Um sistema emite um sinal para anunciar que algo aconteceu, e outros sistemas reagem a esse sinal. Nenhum manager tem conhecimento direto sobre o outro, o que permite que sejam modificados, substituídos ou removidos sem quebrar o projeto.

*   **Modularidade e Responsabilidade Única:** Cada sistema principal é um Singleton (Autoload) com uma responsabilidade claramente definida. O `GameManager` só cuida do estado, o `SceneManager` só cuida das cenas, o `AudioManager` só cuida do áudio. Isso torna o código mais limpo, fácil de entender e de manter.

*   **Orientado a Dados:** A arquitetura incentiva a separação entre lógica e dados. O `AudioManager` carrega sons dinamicamente a partir de uma estrutura de pastas, e o `SettingsManager` salva e carrega as configurações de um arquivo externo. Isso permite que designers e outros membros da equipe possam alterar conteúdos e configurações sem precisar editar código.

*   **Pronto para Produção:** O template já vem com funcionalidades que todo jogo completo precisa:
    *   Menus principal e de pausa.
    *   Sistema de configurações de vídeo, áudio e idioma.
    *   Sistema de internacionalização (I18N) pronto para uso.
    *   Um console de depuração poderoso para monitorar o estado do jogo em tempo real.

## 3. Funcionalidades Principais

O template oferece os seguintes sistemas pré-configurados:

*   **`GameManager`:** Uma Máquina de Estados Finitos (FSM) que gerencia o estado global do jogo (`MENU`, `PLAYING`, `PAUSED`, `SETTINGS`, `QUIT_CONFIRMATION`). Ele centraliza a lógica de pausa e fluxo geral do jogo.

*   **`SceneManager`:** Um gerenciador de cenas sofisticado que utiliza um sistema de pilha (`push`/`pop`) para carregar e descarregar cenas. Ele renderiza o jogo dentro de um `SubViewport`, permitindo controle de resolução e efeitos de pós-processamento de forma otimizada.

*   **`AudioManager`:** Um sistema de áudio dinâmico que carrega todos os arquivos de `Assets/Audio` e os categoriza automaticamente em bibliotecas de música e efeitos sonoros (SFX) com base na estrutura de pastas. Inclui um pool de players para SFX (evitando cortes de som) e um sistema de playlist para as músicas.

*   **`SettingsManager`:** Gerencia a persistência de configurações do jogo. Salva e carrega dados de vídeo (monitor, modo de janela, resolução), áudio (volumes) e idioma em um arquivo `settings.json` no diretório do usuário (`user://`).

*   **`InputManager`:** Captura inputs globais (como "pausar" ou "abrir console") e os traduz em sinais de "intenção" no `GlobalEvents`. Ele desacopla a tecla pressionada da ação que ela executa.

*   **Sistema de UI Reativo:** As cenas de UI (`main_menu`, `pause_menu`, etc.) são projetadas para serem "burras". Elas não contêm lógica de jogo; apenas emitem solicitações ao `GlobalEvents` e reagem a sinais de mudança de estado emitidos pelo `GameManager` para se mostrarem ou esconderem.

*   **Internacionalização (I18N):** Estrutura completa para tradução usando arquivos `.po` e o `TranslationServer` da Godot. Adicionar novos idiomas e traduzir a UI é um processo simples e direto.

*   **`DebugConsole`:** Uma ferramenta de depuração essencial que se conecta a **todos** os sinais do `GlobalEvents` e exibe um log formatado em tempo real. Permite visualizar o fluxo de eventos do jogo, o estado atual dos sistemas e informações da máquina, acelerando drasticamente o processo de desenvolvimento e depuração.
