# Compilação de Pesquisas: Padrões e Tecnologias do Template

Este documento é uma compilação de pesquisas realizadas sobre os principais conceitos, padrões de arquitetura e tecnologias utilizadas e relacionadas a este template Godot. O objetivo é servir como uma base de conhecimento interna, explicando o "porquê" por trás das decisões de design e como expandir o projeto.

## Sumário

1.  [Arquitetura e Padrões de Código](#1-arquitetura-e-padrões-de-código)
    *   [O Padrão Event Bus](#o-padrão-event-bus-globalevents)
    *   [Singletons (Autoloads)](#singletons-autoloads)
2.  [Renderização e Tela](#2-renderização-e-tela)
    *   [Viewports e SubViewports](#viewports-e-subviewports)
    *   [Gerenciamento de Resolução, Janela e VSync](#gerenciamento-de-resolução-janela-e-vsync)
    *   [Upscaling com FSR (FidelityFX Super Resolution)](#upscaling-com-fsr-fidelityfx-super-resolution)
3.  [Sistemas Essenciais](#3-sistemas-essenciais)
    *   [Sistema de Configurações (Settings)](#sistema-de-configurações-settings)
    *   [Sistema de Áudio: Volumes e `linear_to_db`](#sistema-de-áudio-volumes-e-linear_to_db)
    *   [Internacionalização (I18N)](#internacionalização-i18n)
    *   [Salvamento na Nuvem (Cloud Save)](#salvamento-na-nuvem-cloud-save)
4.  [Multiplayer](#4-multiplayer)
    *   [API de Alto Nível da Godot](#api-de-alto-nível-da-godot)
5.  [Publicação e Exportação](#5-publicação-e-exportação)
    *   [Publicando na Steam (Steamworks)](#publicando-na-steam-steamworks)
    *   [Exportando para Desktop (Windows/Linux)](#exportando-para-desktop-windowslinux)
    *   [Exportando para Web (HTML5)](#exportando-para-web-html5)
    *   [Exportando para Xbox](#exportando-para-xbox)

---

## 1. Arquitetura e Padrões de Código

### O Padrão Event Bus (GlobalEvents)

O **Event Bus** é um padrão de design de software que permite a comunicação entre diferentes componentes de um sistema de forma desacoplada. Em vez de componentes se chamarem diretamente, eles se comunicam através de um "barramento" central que transmite eventos.

**Implementação no Template:**
*   **O Barramento:** É o Singleton `GlobalEvents`, que contém apenas uma lista de declarações de `signal`.
*   **Emissores:** Qualquer nó que precisa anunciar uma ocorrência (ex: `InputManager` detectando a tecla "pause") emite o sinal apropriado no `GlobalEvents`.
*   **Ouvintes:** Sistemas que precisam reagir a esses eventos (ex: `GameManager`) se conectam a esses sinais e executam sua lógica quando o evento é emitido.

**Vantagens:**
*   **Desacoplamento:** O emissor não precisa saber quem está ouvindo, e vice-versa. Isso torna o código extremamente modular e fácil de manter.
*   **Escalabilidade:** Adicionar um novo sistema que reage a um evento existente não requer nenhuma modificação nos sistemas já existentes.
*   **Clareza:** O `GlobalEvents.gd` serve como uma documentação viva de todos os eventos globais que podem ocorrer no jogo.

### Singletons (Autoloads)

Singletons são scripts que a Godot carrega automaticamente no início do jogo, garantindo que exista apenas uma instância deles, acessível globalmente.

**Melhores Práticas Implementadas:**
*   **Responsabilidade Única:** Cada Singleton tem um propósito claro e definido (`AudioManager` para áudio, `SceneManager` para cenas, etc.), evitando a criação de um "super-singleton" que faz tudo.
*   **Comunicação via Event Bus:** Conforme descrito acima, os Singletons não se comunicam diretamente, mas através do `GlobalEvents`. Isso evita o acoplamento forte, que é uma armadilha comum no uso de Singletons.
*   **Ordem de Carregamento:** A ordem no `project.godot` é configurada para que `GlobalEvents` seja carregado primeiro, permitindo que os outros managers se conectem a ele durante sua própria inicialização.

---

## 2. Renderização e Tela

### Viewports e SubViewports

Um `Viewport` é essencialmente uma tela. A janela do jogo é o `Viewport` raiz. O nó `SubViewport` permite criar "telas dentro da tela", renderizando uma parte do jogo para uma textura.

**Implementação no Template:**
*   O `SceneManager` contém um `SubViewportContainer` com um `SubViewport` filho. Todas as cenas do jogo (menus, o mundo do jogo) são renderizadas dentro deste `SubViewport`.
*   **Vantagem:** Isso desacopla a resolução de renderização do jogo da resolução da janela. Você pode renderizar o jogo a 720p para melhor performance e deixar a Godot escalar a textura do `SubViewport` para a resolução nativa do monitor do jogador (1080p, 4K), mantendo a UI (que estaria fora do SubViewport, em uma `CanvasLayer`) nítida na resolução nativa.

**Casos de Uso Comuns para `SubViewport`:**
*   Mini-mapas.
*   Modelos 3D em interfaces 2D (ex: tela de inventário).
*   Câmeras de segurança ou espelhos.
*   Multiplayer em tela dividida (split-screen).

### Gerenciamento de Resolução, Janela e VSync

Essas configurações são controladas principalmente pelo `DisplayServer`.

*   **Modo de Janela:** `DisplayServer.window_set_mode()` pode alternar entre `WINDOWED`, `FULLSCREEN`, e `BORDERLESS_WINDOWED`.
*   **Resolução:** `get_window().set_size()` altera o tamanho da janela. Para tela cheia, isso altera a resolução do monitor.
*   **VSync (Sincronização Vertical):** `DisplayServer.window_set_vsync_mode()` controla se o jogo deve sincronizar sua taxa de quadros com a do monitor para evitar "screen tearing". As opções são `VSYNC_ENABLED` e `VSYNC_DISABLED`.

**Implementação no Template:** O `SettingsManager` ouve os sinais da UI de configurações e chama essas funções do `DisplayServer` para aplicar as mudanças em tempo real.

### Upscaling com FSR (FidelityFX Super Resolution)

FSR é uma tecnologia da AMD que renderiza a cena 3D em uma resolução menor e depois usa um algoritmo de upscaling inteligente para reconstruí-la na resolução final, resultando em um grande ganho de performance.

*   **Suporte na Godot 4:** Godot 4 suporta FSR 1.0 e FSR 2.2.
*   **Como Funciona:** Ele é ativado nas Configurações do Projeto (`Rendering > Scaling 3D`) e funciona ajustando a propriedade `scaling_3d_scale` do `Viewport`. Um valor de `0.75` significa que a cena 3D é renderizada a 75% da resolução, e o FSR cuida do upscaling para 100%.
*   **Implementação:** Um menu de configurações pode facilmente expor opções de qualidade (Performance, Equilibrado, Qualidade) que simplesmente alteram o valor de `get_viewport().scaling_3d_scale`.

---

## 3. Sistemas Essenciais

### Sistema de Configurações (Settings)

Um sistema de configurações robusto salva as preferências do jogador entre as sessões.

**Implementação no Template:**
*   O `SettingsManager` usa `JSON.stringify` para converter um dicionário de configurações em texto.
*   O arquivo é salvo em `user://settings.json`. O diretório `user://` é a localização padrão da Godot para dados de usuário, garantindo compatibilidade entre plataformas.
*   Ao iniciar, o manager carrega este arquivo. Se não existir, cria um com valores padrão. As configurações são então aplicadas imediatamente.

### Sistema de Áudio: Volumes e `linear_to_db`

O controle de volume em áudio digital não é linear.

*   **O Problema:** A percepção humana de volume é logarítmica. Um slider de UI que altera o volume de forma linear (de 0.0 a 1.0) resultará em uma experiência onde a maior parte da mudança de volume acontece no início do slider.
*   **A Solução:** O `AudioServer` da Godot trabalha com decibéis (dB), uma escala logarítmica. A função `linear_to_db(value)` converte o valor linear de um slider para decibéis. A função inversa, `db_to_linear(db)`, também existe.
*   **Implementação no Template:** O `SettingsManager` sempre usa `linear_to_db` ao receber um valor de um slider de volume antes de passá-lo para `AudioServer.set_bus_volume_db()`.

### Internacionalização (I18N)

É o processo de preparar o jogo para ser traduzido.

**Implementação no Template:**
*   **Arquivos `.po`:** O texto é armazenado em arquivos de tradução (um para cada idioma) na pasta `I18N/`.
*   **Chaves de Tradução:** Em vez de texto literal, os nós de UI (`Label`, `Button`) usam chaves (ex: `UI_MAIN_MENU_TITLE`).
*   **`TranslationServer`:** O `SettingsManager`, ao receber o sinal `locale_setting_changed`, chama `TranslationServer.set_locale("pt_BR")`, e a Godot atualiza todos os textos automaticamente.
*   **Textos em Código:** A função `tr("CHAVE")` é usada para obter textos traduzidos em scripts.

### Salvamento na Nuvem (Cloud Save)

A Godot não possui uma solução nativa, exigindo integração com serviços externos.

*   **Steam Cloud:** A abordagem mais comum para jogos na Steam. O SDK da Steam (integrado via GodotSteam) permite sincronizar arquivos da pasta `user://` com os servidores da Steam. O `SaveManager` salvaria o jogo localmente e depois usaria a API do Steam para enviar o arquivo.
*   **Backend Customizado:** Para jogos cross-platform, é necessário criar um servidor próprio (API) que recebe os dados de save via `HTTPRequest` e os armazena em um banco de dados. Esta abordagem exige autenticação de usuário.
*   **Resolução de Conflitos:** A prática padrão, crucial para uma boa experiência, é salvar um timestamp (data e hora) a cada save. Ao iniciar o jogo, o sistema compara o timestamp do save local com o da nuvem e, se forem diferentes, pergunta ao jogador qual versão ele deseja manter.

---

## 4. Multiplayer

### API de Alto Nível da Godot

A Godot 4 simplificou muito o desenvolvimento de jogos em rede.

*   **`MultiplayerAPI` e `MultiplayerPeer`:** O `ENetMultiplayerPeer` é usado para criar um servidor (`create_server`) ou um cliente (`create_client`).
*   **RPCs (Remote Procedure Calls):** Funções marcadas com a anotação `@rpc` podem ser chamadas em outras instâncias do jogo pela rede. É a principal forma de comunicação para eventos (ex: um jogador atirou).
*   **`MultiplayerSpawner` e `MultiplayerSynchronizer`:** Nós essenciais para automatizar a sincronização. O `Spawner` instancia cenas (como jogadores) em todos os clientes quando o servidor o faz. O `Synchronizer` sincroniza automaticamente propriedades (como `position`, `rotation`) de um nó, reduzindo drasticamente a necessidade de código de rede manual.

---

## 5. Publicação e Exportação

### Publicando na Steam (Steamworks)

Requer o uso do SDK do Steamworks, geralmente integrado via o plugin **GodotSteam**.

1.  **Configuração:** É preciso ser um parceiro Steamworks, baixar o SDK e o plugin GodotSteam.
2.  **Inicialização:** O código deve inicializar a API do Steam no início do jogo. Um arquivo `steam_appid.txt` é necessário para testes locais.
3.  **Integração:** O plugin expõe o Singleton `Steam`, que permite usar funções da API para conquistas, leaderboards, Cloud Save, etc.
4.  **Upload:** O build do jogo não é enviado por um site, mas sim através de uma ferramenta de linha de comando chamada **SteamPipe**, usando scripts de configuração (`.vdf`).

### Exportando para Desktop (Windows/Linux)

Este é o processo mais direto. Requer os **templates de exportação** correspondentes à versão da Godot. Na janela de exportação, cria-se um preset para cada plataforma e configura-se o ícone e as informações da versão. Para a versão final, a opção "Exportar com Debug" deve ser desmarcada.

### Exportando para Web (HTML5)

Também usa templates de exportação. O ponto crucial na Godot 4 é habilitar as opções de `Cross-Origin-Isolation` no preset de exportação para que o multithreading funcione nos navegadores. O jogo exportado precisa ser servido por um servidor web para ser testado, não pode ser aberto diretamente do arquivo.

### Exportando para Xbox

**Não é possível fazer isso com a versão pública da Godot.** Devido a NDAs e SDKs proprietários, a publicação para consoles (Xbox, PlayStation, Nintendo) exige:
1.  Ser aprovado como desenvolvedor registrado na plataforma (ex: programa **ID@Xbox**).
2.  Trabalhar com uma **empresa de portabilidade** parceira da Godot (como a W4 Games), que fornecerá uma versão licenciada da engine com os templates de exportação para console e auxiliará no processo de certificação técnica (TRCs).
