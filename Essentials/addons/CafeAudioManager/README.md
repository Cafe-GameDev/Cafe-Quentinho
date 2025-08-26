# CafeAudioManager Plugin para Godot Engine

## Índice

*   [Português](#português)
	*   [Visão Geral](#visão-geral-pt)
	*   [Sinais (EventBus de Áudio)](#sinais-eventbus-de-áudio-pt)
	*   [Configuração](#configuração-pt)
	*   [Biblioteca de Áudio Nativa](#biblioteca-de-áudio-nativa-pt)
	*   [Instalação e Uso](#instalação-e-uso-pt)
*   [English](#english)
	*   [Overview](#overview-en)
	*   [Signals (Audio EventBus)](#signals-audio-eventbus-en)
	*   [Configuration](#configuration-en)
	*   [Native Audio Library](#native-audio-library-en)
	*   [Installation and Usage](#installation-and-usage-en)
*   [Español](#español)
	*   [Visión General](#visión-general-es)
	*   [Señales (EventBus de Audio)](#señales-eventbus-de-audio-es)
	*   [Configuración](#configuración-es)
	*   [Biblioteca de Audio Nativa](#biblioteca-de-audio-nativa-es)
	*   [Instalación y Uso](#instalación-y-uso-es)

---

<a name="português"></a>
## Português

Este plugin substitui o sistema de áudio padrão do template "Café Essentials - Godot Brew Kit", oferecendo uma solução robusta e desacoplada para gerenciamento de música e efeitos sonoros (SFX) em seus projetos Godot. Ele atua como um EventBus dedicado para áudio, garantindo que a comunicação de áudio seja centralizada e fácil de gerenciar.

<a name="visão-geral-pt"></a>
### Visão Geral

O `CafeAudioManager` é projetado para simplificar a integração de áudio em seus jogos, fornecendo:

*   **Carregamento Dinâmico:** Carrega automaticamente arquivos de áudio de diretórios configuráveis, categorizando-os em bibliotecas de SFX e música.
*   **Pool de SFX Players:** Utiliza um pool configurável de `AudioStreamPlayer` para reproduzir SFX, evitando cortes de som e otimizando a performance.
*   **Gestão de Música:** Gerencia playlists de música, permitindo a reprodução aleatória de faixas dentro de uma categoria e a transição automática ou manual entre elas.
*   **Controle de Volume:** Permite o controle de volume para buses de áudio (Master, Música, SFX) de forma desacoplada.
*   **Compatibilidade:** Projetado para ser compatível com builds exportados, utilizando um `AudioManifest` gerado para referenciar recursos de áudio.

**Limitações:** Este AudioManager é projetado exclusivamente para áudio mono, sem suporte para efeitos de áudio posicional 2D ou 3D.

<a name="sinais-eventbus-de-áudio-pt"></a>
### Sinais (EventBus de Áudio)

O `CafeAudioManager` atua como seu próprio EventBus para áudio, emitindo e ouvindo os seguintes sinais:

#### Sinais Emitidos

*   `music_track_changed(music_key: String)`: Emitido quando uma nova faixa de música começa a tocar.
*   `volume_changed(bus_name: String, linear_volume: float)`: Emitido quando o volume de um bus de áudio é alterado.

#### Sinais Ouvidos

*   `play_sfx_requested(sfx_key: String, bus: String, manager_node: Node = null)`: Solicita a reprodução de um efeito sonoro.
	*   `sfx_key`: A chave do SFX a ser reproduzido (definida no `AudioManifest`).
	*   `bus`: O nome do bus de áudio (ex: "SFX"). Padrão: "SFX".
	*   `manager_node`: (Opcional, para v2.0) O nó `CafeAudioPlayer2D/3D` que deve gerenciar a reprodução posicional do áudio. Se `null`, o `CafeAudioManager` gerencia.
*   `play_music_requested(music_key: String, manager_node: Node = null)`: Solicita a reprodução de uma faixa de música ou playlist.
	*   `music_key`: A chave da música/playlist a ser reproduzida (definida no `AudioManifest`).
	*   `manager_node`: (Opcional, para v2.0) O nó `CafeAudioPlayer2D/3D` que deve gerenciar a reprodução posicional do áudio. Se `null`, o `CafeAudioManager` gerencia.
*   `volume_changed(bus_name: String, linear_volume: float)`: Ouve seu próprio sinal para aplicar as mudanças de volume.

<a name="configuração-pt"></a>
### Configuração

#### `AudioManifest`

O plugin utiliza um `AudioManifest` (um recurso `.tres`) para gerenciar as referências aos arquivos de áudio. Este manifest é **gerado automaticamente** pelo script `generate_audio_manifest.gd` (localizado em `res://addons/CafeAudioManager/scripts/`). Ele é crucial para a compatibilidade em builds exportados, pois mapeia as chaves de áudio para os UIDs dos recursos importados pelo Godot.

**Como Gerar o `AudioManifest`:**
1.  No editor Godot, selecione o nó `CafeAudioManager` na sua cena principal.
2.  No painel "Sistema de Arquivos", clique com o botão direito no script `generate_audio_manifest.gd`.
3.  Selecione "Abrir no Editor de Script".
4.  No Editor de Script, clique em "Arquivo" -> "Executar Script".
5.  O `AudioManifest.tres` será gerado e salvo em `res://addons/CafeAudioManager/resources/audio_manifest.tres`.

#### Caminhos de Áudio

Os caminhos raiz para SFX e música podem ser configurados no inspetor do nó `CafeAudioManager`:

*   `sfx_root_path`: Caminho para a pasta contendo os efeitos sonoros (padrão: `res://addons/CafeAudioManager/assets/sfx/`).
*   `music_root_path`: Caminho para a pasta contendo as músicas (padrão: `res://addons/CafeAudioManager/assets/music/`).

<a name="biblioteca-de-áudio-nativa-pt"></a>
### Biblioteca de Áudio Nativa

O `CafeAudioManager` inclui uma biblioteca básica de SFX e músicas para fins de teste e para facilitar a implementação inicial. Estes assets estão localizados nas pastas `res://addons/CafeAudioManager/assets/sfx/` e `res://addons/CafeAudioManager/assets/music/`. Sinta-se à vontade para substituí-los ou adicionar seus próprios assets, garantindo que os caminhos de configuração (`sfx_root_path`, `music_root_path`) estejam corretos.

<a name="instalação-e-uso-pt"></a>
### Instalação e Uso

1.  **Adicionar o Plugin:** Copie a pasta `CafeAudioManager` para a pasta `addons/` do seu projeto Godot.
2.  **Ativar o Plugin:** Vá em `Projeto > Configurações do Projeto > Plugins` e ative o `CafeAudioManager`.
3.  **Configurar Autoload:** Certifique-se de que o `CafeAudioManager` esteja configurado como um Autoload (Singleton) em `Projeto > Configurações do Projeto > Autoload`.
4.  **Gerar AudioManifest:** Siga as instruções na seção "Como Gerar o `AudioManifest`" acima.
5.  **Refatorar Chamadas de Áudio:** Substitua todas as chamadas diretas ao `AudioManager` antigo ou sinais de áudio do `GlobalEvents` pelas chamadas apropriadas ao `CafeAudioManager` (via `CafeAudioManager.play_sfx_requested.emit(...)` e `CafeAudioManager.play_music_requested.emit(...)`).

---

<a name="english"></a>
## English

This plugin replaces the default audio system of the "Café Essentials - Godot Brew Kit" template, offering a robust and decoupled solution for managing music and sound effects (SFX) in your Godot projects. It acts as a dedicated EventBus for audio, ensuring that audio communication is centralized and easy to manage.

<a name="overview-en"></a>
### Overview

The `CafeAudioManager` is designed to simplify audio integration in your games by providing:

*   **Dynamic Loading:** Automatically loads audio files from configurable directories, categorizing them into SFX and music libraries.
*   **SFX Player Pool:** Utilizes a configurable pool of `AudioStreamPlayer` instances to play SFX, preventing sound cutting and optimizing performance.
*   **Music Management:** Manages music playlists, allowing for random playback of tracks within a category and automatic or manual transitions between them.
*   **Volume Control:** Enables decoupled volume control for audio buses (Master, Music, SFX).
*   **Compatibility:** Designed to be compatible with exported builds, using a generated `AudioManifest` to reference audio resources.

**Limitations:** This AudioManager is exclusively designed for mono audio, without support for 2D or 3D positional audio effects.

<a name="signals-audio-eventbus-en"></a>
### Signals (Audio EventBus)

The `CafeAudioManager` acts as its own EventBus for audio, emitting and listening to the following signals:

#### Emitted Signals

*   `music_track_changed(music_key: String)`: Emitted when a new music track starts playing.
*   `volume_changed(bus_name: String, linear_volume: float)`: Emitted when the volume of an audio bus is changed.

#### Listened Signals

*   `play_sfx_requested(sfx_key: String, bus: String)`: Requests the playback of a sound effect.
	*   `sfx_key`: The key of the SFX to be played (defined in the `AudioManifest`).
	*   `bus`: The name of the audio bus (e.g., "SFX"). Default: "SFX".
*   `play_music_requested(music_key: String)`: Requests the playback of a music track or playlist.
	*   `music_key`: The key of the music/playlist to be played (defined in the `AudioManifest`).
*   `volume_changed(bus_name: String, linear_volume: float)`: Listens to its own signal to apply volume changes.

<a name="configuration-en"></a>
### Configuration

#### `AudioManifest`

The plugin uses an `AudioManifest` (a `.tres` resource) to manage references to audio files. This manifest is **automatically generated** by the `generate_audio_manifest.gd` script (located in `res://addons/CafeAudioManager/scripts/`). It is crucial for compatibility in exported builds, as it maps audio keys to the UIDs of Godot's imported resources.

**How to Generate the `AudioManifest`:**
1.  In the Godot editor, select the `CafeAudioManager` node in your main scene.
2.  In the "File System" panel, right-click on the `generate_audio_manifest.gd` script.
3.  Select "Open in Script Editor".
4.  In the Script Editor, click "File" -> "Run Script".
5.  The `AudioManifest.tres` will be generated and saved to `res://addons/CafeAudioManager/resources/audio_manifest.tres`.

#### Audio Paths

The root paths for SFX and music can be configured in the `CafeAudioManager` node's inspector:

*   `sfx_root_path`: Path to the folder containing sound effects (default: `res://addons/CafeAudioManager/assets/sfx/`).
*   `music_root_path`: Path to the folder containing music tracks (default: `res://addons/CafeAudioManager/assets/music/`).

<a name="native-audio-library-en"></a>
### Native Audio Library

The `CafeAudioManager` includes a basic library of SFX and music for testing purposes and to facilitate initial implementation. These assets are located in the `res://addons/CafeAudioManager/assets/sfx/` and `res://addons/CafeAudioManager/assets/music/` folders. Feel free to replace them or add your own assets, ensuring that the configuration paths (`sfx_root_path`, `music_root_path`) are correct.

<a name="instalação-e-uso-en"></a>
### Installation and Usage

1.  **Add the Plugin:** Copy the `CafeAudioManager` folder to your Godot project's `addons/` folder.
2.  **Activate the Plugin:** Go to `Project > Project Settings > Plugins` and activate `CafeAudioManager`.
3.  **Configure Autoload:** Ensure that `CafeAudioManager` is configured as an Autoload (Singleton) in `Project > Project Settings > Autoload`.
4.  **Generate AudioManifest:** Follow the instructions in the "How to Generate the `AudioManifest`" section above.
5.  **Refactor Audio Calls:** Replace all direct calls to the old `AudioManager` or audio signals from `GlobalEvents` with the appropriate calls to `CafeAudioManager` (via `CafeAudioManager.play_sfx_requested.emit(...)` and `CafeAudioManager.play_music_requested.emit(...)`).

---

<a name="español"></a>
## Español

Este plugin reemplaza el sistema de audio predeterminado de la plantilla "Café Essentials - Godot Brew Kit", ofreciendo una solución robusta y desacoplada para la gestión de música y efectos de sonido (SFX) en tus proyectos de Godot. Actúa como un EventBus dedicado para audio, asegurando que la comunicación de audio esté centralizada y sea fácil de gestionar.

<a name="visión-general-es"></a>
### Visión General

El `CafeAudioManager` está diseñado para simplificar la integración de audio en tus juegos, proporcionando:

*   **Carga Dinámica:** Carga automáticamente archivos de audio desde directorios configurables, categorizándolos en bibliotecas de SFX y música.
*   **Pool de Reproductores SFX:** Utiliza un pool configurable de instancias de `AudioStreamPlayer` para reproducir SFX, evitando cortes de sonido y optimizando el rendimiento.
*   **Gestión de Música:** Gestiona listas de reproducción de música, permitiendo la reproducción aleatoria de pistas dentro de una categoría y transiciones automáticas o manuales entre ellas.
*   **Control de Volumen:** Permite un control de volumen desacoplado para los buses de audio (Master, Música, SFX).
*   **Compatibilidad:** Diseñado para ser compatible con compilaciones exportadas, utilizando un `AudioManifest` generado para referenciar recursos de audio.

**Limitaciones:** Este AudioManager está diseñado exclusivamente para audio mono, sin soporte para efectos de audio posicional 2D o 3D.

<a name="señales-eventbus-de-audio-es"></a>
### Señales (EventBus de Audio)

El `CafeAudioManager` actúa como su propio EventBus para audio, emitiendo y escuchando las siguientes señales:

#### Señales Emitidas

*   `music_track_changed(music_key: String)`: Emitida cuando una nueva pista de música comienza a reproducirse.
*   `volume_changed(bus_name: String, linear_volume: float)`: Emitida cuando se cambia el volumen de un bus de audio.

#### Señales Escuchadas

*   `play_sfx_requested(sfx_key: String, bus: String)`: Solicita la reproducción de un efecto de sonido.
	*   `sfx_key`: La clave del SFX a reproducir (definida en el `AudioManifest`).
	*   `bus`: El nombre del bus de audio (ej: "SFX"). Predeterminado: "SFX".
*   `play_music_requested(music_key: String)`: Solicita la reproducción de una pista de música o lista de reproducción.
	*   `music_key`: La clave de la música/lista de reproducción a reproducir (definida en el `AudioManifest`).
*   `volume_changed(bus_name: String, linear_volume: float)`: Escucha su propia señal para aplicar los cambios de volumen.

<a name="configuración-es"></a>
### Configuración

#### `AudioManifest`

El plugin utiliza un `AudioManifest` (un recurso `.tres`) para gestionar las referencias a los archivos de audio. Este manifiesto es **generado automáticamente** por el script `generate_audio_manifest.gd` (ubicado en `res://addons/CafeAudioManager/scripts/`). Es crucial para la compatibilidad en compilaciones exportadas, ya que mapea las claves de audio a los UIDs de los recursos importados de Godot.

**Cómo Generar el `AudioManifest`:**
1.  En el editor de Godot, selecciona el nodo `CafeAudioManager` en tu escena principal.
2.  En el panel "Sistema de Archivos", haz clic derecho en el script `generate_audio_manifest.gd`.
3.  Selecciona "Abrir en Editor de Script".
4.  En el Editor de Script, haz clic en "Archivo" -> "Ejecutar Script".
5.  El `AudioManifest.tres` se generará y guardará en `res://addons/CafeAudioManager/resources/audio_manifest.tres`.

#### Rutas de Audio

Las rutas raíz para SFX y música se pueden configurar en el inspector del nodo `CafeAudioManager`:

*   `sfx_root_path`: Ruta a la carpeta que contiene los efectos de sonido (predeterminado: `res://addons/CafeAudioManager/assets/sfx/`).
*   `music_root_path`: Ruta a la carpeta que contiene las pistas de música (predeterminado: `res://addons/CafeAudioManager/assets/music/`).

<a name="biblioteca-de-audio-nativa-es"></a>
### Biblioteca de Audio Nativa

El `CafeAudioManager` incluye una biblioteca básica de SFX y música para fines de prueba y para facilitar la implementación inicial. Estos assets se encuentran en las carpetas `res://addons/CafeAudioManager/assets/sfx/` y `res://addons/CafeAudioManager/assets/music/`. Siéntete libre de reemplazarlos o agregar tus propios assets, asegurándote de que las rutas de configuración (`sfx_root_path`, `music_root_path`) sean correctas.

<a name="instalação-e-uso-es"></a>
### Instalación y Uso

1.  **Agregar el Plugin:** Copia la carpeta `CafeAudioManager` a la carpeta `addons/` de tu proyecto de Godot.
2.  **Activar el Plugin:** Ve a `Proyecto > Configuración del Proyecto > Plugins` y activa `CafeAudioManager`.
3.  **Configurar Autoload:** Asegúrate de que `CafeAudioManager` esté configurado como un Autoload (Singleton) en `Proyecto > Configuración del Proyecto > Autoload`.
4.  **Generar AudioManifest:** Sigue las instrucciones en la sección "Cómo Generar el `AudioManifest`" anterior.
5.  **Refactorizar Llamadas de Audio:** Reemplaza todas las llamadas directas al antiguo `AudioManager` o señales de audio de `GlobalEvents` con las llamadas apropiadas a `CafeAudioManager` (a través de `CafeAudioManager.play_sfx_requested.emit(...)` y `CafeAudioManager.play_music_requested.emit(...)`).
