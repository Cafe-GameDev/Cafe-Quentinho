# Audio Design Document (ADD): Template Café Quentinho

Este documento detalha a filosofia, arquitetura e o modo de uso do sistema de áudio do template.

## 1. Filosofia: "Plug-and-Play"

O sistema de áudio foi projetado para ser **"plug-and-play"**. A principal meta é abstrair a complexidade de carregamento, categorização e reprodução de sons. O desenvolvedor deve ser capaz de adicionar, remover ou alterar arquivos de áudio no projeto com o mínimo de esforço e sem a necessidade de modificar código, permitindo que o foco permaneça no design de som e na sua implementação no gameplay.

## 2. `AudioManager`: O Coração do Sistema

O `AudioManager` é um Singleton que centraliza toda a funcionalidade de áudio. Sua operação é baseada em algumas lógicas chave:

*   **Carregamento Dinâmico:** Ao iniciar o jogo (`_ready`), o `AudioManager` não utiliza caminhos de arquivo fixos. Em vez disso, ele varre recursivamente o diretório `res://Assets/Audio/` usando `DirAccess`. Isso o torna extremamente robusto; qualquer arquivo de áudio adicionado nas pastas corretas é automaticamente detectado e integrado ao sistema.

*   **Categorização Automática por Pastas:** A estrutura de pastas dentro de `Assets/Audio/` dita como os sons são categorizados:
    *   **Música:** Qualquer subpasta encontrada diretamente dentro de `Assets/Audio/music/` é tratada como uma **playlist**. O nome da pasta se torna a chave da playlist. Por exemplo, um arquivo em `res://Assets/Audio/music/peaceful/song1.ogg` será parte da playlist `peaceful`.
    *   **Efeitos Sonoros (SFX):** Qualquer outra subpasta em `Assets/Audio/` é tratada como uma categoria de SFX. A chave para tocar um som é uma combinação do nome da pasta pai e da subpasta, em minúsculas. Por exemplo, um arquivo em `res://Assets/Audio/interface/click/sound.wav` será parte da categoria `interface_click`.

*   **Reprodução de Música:**
    *   Utiliza um `AudioStreamPlayer` dedicado, garantindo que apenas uma faixa de música toque por vez.
    *   Gerencia uma playlist contínua. Quando uma música termina, o sinal `finished` do player é usado para tocar outra faixa aleatória da *mesma* playlist, criando um ambiente sonoro coeso.
    *   Para evitar repetição, um `Timer` (`MusicChangeTimer`) troca para uma playlist completamente nova a cada 5 minutos (300s), garantindo variedade sonora ao longo de uma sessão de jogo.

*   **Reprodução de SFX:**
    *   Para lidar com múltiplos sons simultâneos (tiros, impactos, cliques de UI) sem que um som corte o outro, o `AudioManager` cria um **pool** de `AudioStreamPlayer`s (15 por padrão).
    *   Quando uma solicitação para tocar um SFX é recebida (`play_random_sfx`), ele procura um player livre no pool e o utiliza. Isso garante que múltiplos efeitos sonoros possam ser ouvidos ao mesmo tempo de forma clara.

## 3. Como Usar o Sistema (Guia para Desenvolvedores)

### Adicionar Novas Músicas

1.  Crie uma nova pasta dentro de `Assets/Audio/music/`. O nome da pasta será o nome da sua playlist (ex: `boss_battle`).
2.  Coloque seus arquivos de música (preferencialmente no formato `.ogg` para compressão) dentro desta nova pasta.
3.  **Pronto.** O `AudioManager` irá encontrar os arquivos e adicioná-los à rotação de playlists automaticamente.

### Adicionar Novos Efeitos Sonoros

1.  Crie uma pasta de categoria em `Assets/Audio/` se ela ainda não existir (ex: `player`).
2.  Dentro da pasta `player`, crie uma subpasta para o tipo de som (ex: `jump`).
3.  Coloque um ou mais arquivos de som (`.ogg` ou `.wav`) dentro da subpasta `jump`.
4.  Para tocar um som de pulo aleatório em qualquer lugar do seu código, emita o sinal global:
    ```gdscript
    GlobalEvents.play_sfx_by_key_requested.emit("player_jump")
    ```
    A chave (`player_jump`) é derivada automaticamente da estrutura de pastas (`player/jump`).

## 4. Barramentos de Áudio (Audio Buses)

O template já vem com 3 barramentos de áudio configurados no arquivo `default_bus_layout.tres`: `Master`, `Music`, e `SFX`.

*   O `AudioManager` atribui automaticamente o `AudioStreamPlayer` de música ao bus `Music` e todos os players de SFX ao bus `SFX`.
*   Isso permite que o `SettingsManager` e a UI de configurações controlem os volumes de música e efeitos de forma independente e global, sem precisar de nenhuma configuração adicional.
