# Cafe-AudioManager Plugin para Godot Engine

Este plugin substitui o sistema de áudio padrão do template "Café Essentials - Godot Brew Kit", oferecendo uma solução robusta e desacoplada para gerenciamento de música e efeitos sonoros (SFX) em seus projetos Godot. Ele atua como um EventBus dedicado para áudio, garantindo que a comunicação de áudio seja centralizada e fácil de gerenciar.

## Visão Geral

O `Cafe-AudioManager` é projetado para simplificar a integração de áudio em seus jogos, fornecendo:

*   **Carregamento Dinâmico:** Carrega automaticamente arquivos de áudio de diretórios configuráveis, categorizando-os em bibliotecas de SFX e música.
*   **Pool de SFX Players:** Utiliza um pool configurável de `AudioStreamPlayer` para reproduzir SFX, evitando cortes de som e otimizando a performance.
*   **Gestão de Música:** Gerencia playlists de música, permitindo a reprodução aleatória de faixas dentro de uma categoria e a transição automática ou manual entre elas.
*   **Controle de Volume:** Permite o controle de volume para buses de áudio (Master, Música, SFX) de forma desacoplada.
*   **Compatibilidade:** Projetado para ser compatível com builds exportados, utilizando um `AudioManifest` gerado para referenciar recursos de áudio.

**Limitações:** Este AudioManager é projetado exclusivamente para áudio mono, sem suporte para efeitos de áudio posicional 2D ou 3D.

## Sinais (EventBus de Áudio)

O `Cafe-AudioManager` atua como seu próprio EventBus para áudio, emitindo e ouvindo os seguintes sinais:

### Sinais Emitidos

*   `music_track_changed(music_key: String)`: Emitido quando uma nova faixa de música começa a tocar.
*   `volume_changed(bus_name: String, linear_volume: float)`: Emitido quando o volume de um bus de áudio é alterado.

### Sinais Ouvidos

*   `play_sfx_requested(sfx_key: String, bus: String)`: Solicita a reprodução de um efeito sonoro.
    *   `sfx_key`: A chave do SFX a ser reproduzido (definida no `AudioManifest`).
    *   `bus`: O nome do bus de áudio (ex: "SFX"). Padrão: "SFX".
*   `play_music_requested(music_key: String)`: Solicita a reprodução de uma faixa de música ou playlist.
    *   `music_key`: A chave da música/playlist a ser reproduzida (definida no `AudioManifest`).
*   `volume_changed(bus_name: String, linear_volume: float)`: Ouve seu próprio sinal para aplicar as mudanças de volume.

## Configuração

### `AudioManifest`

O plugin utiliza um `AudioManifest` (um recurso `.tres`) para gerenciar as referências aos arquivos de áudio. Este manifest é gerado automaticamente pelo plugin e é crucial para a compatibilidade em builds exportados.

### Caminhos de Áudio

Os caminhos raiz para SFX e música podem ser configurados no inspetor do nó `CafeAudioManager`:

*   `sfx_root_path`: Caminho para a pasta contendo os efeitos sonoros (padrão: `res://addons/Cafe-AudioManager/assets/sfx/`).
*   `music_root_path`: Caminho para a pasta contendo as músicas (padrão: `res://addons/Cafe-AudioManager/assets/music/`).

## Instalação e Uso

1.  **Adicionar o Plugin:** Copie a pasta `Cafe-AudioManager` para a pasta `addons/` do seu projeto Godot.
2.  **Ativar o Plugin:** Vá em `Projeto > Configurações do Projeto > Plugins` e ative o `Cafe-AudioManager`.
3.  **Configurar Autoload:** Certifique-se de que o `CafeAudioManager` esteja configurado como um Autoload (Singleton) em `Projeto > Configurações do Projeto > Autoload`.
4.  **Gerar AudioManifest:** No editor Godot, selecione o nó `CafeAudioManager` e, no inspetor, certifique-se de que o `AudioManifest` esteja atribuído ou gere um novo.
5.  **Refatorar Chamadas de Áudio:** Substitua todas as chamadas diretas ao `AudioManager` antigo ou sinais de áudio do `GlobalEvents` pelas chamadas apropriadas ao `CafeAudioManager` (via `CafeAudioManager.play_sfx_requested.emit(...)` e `CafeAudioManager.play_music_requested.emit(...)`).

---

# Cafe-AudioManager Plugin for Godot Engine (English)

This plugin replaces the default audio system of the "Café Essentials - Godot Brew Kit" template, offering a robust and decoupled solution for managing music and sound effects (SFX) in your Godot projects. It acts as a dedicated EventBus for audio, ensuring that audio communication is centralized and easy to manage.

## Overview

The `Cafe-AudioManager` is designed to simplify audio integration in your games by providing:

*   **Dynamic Loading:** Automatically loads audio files from configurable directories, categorizing them into SFX and music libraries.
*   **SFX Player Pool:** Utilizes a configurable pool of `AudioStreamPlayer` instances to play SFX, preventing sound cutting and optimizing performance.
*   **Music Management:** Manages music playlists, allowing for random playback of tracks within a category and automatic or manual transitions between them.
*   **Volume Control:** Enables decoupled volume control for audio buses (Master, Music, SFX).
*   **Compatibility:** Designed to be compatible with exported builds, using a generated `AudioManifest` to reference audio resources.

**Limitations:** This AudioManager is exclusively designed for mono audio, without support for 2D or 3D positional audio effects.

## Signals (Audio EventBus)

The `Cafe-AudioManager` acts as its own EventBus for audio, emitting and listening to the following signals:

### Emitted Signals

*   `music_track_changed(music_key: String)`: Emitted when a new music track starts playing.
*   `volume_changed(bus_name: String, linear_volume: float)`: Emitted when the volume of an audio bus is changed.

### Listened Signals

*   `play_sfx_requested(sfx_key: String, bus: String)`: Requests the playback of a sound effect.
    *   `sfx_key`: The key of the SFX to be played (defined in the `AudioManifest`).
    *   `bus`: The name of the audio bus (e.g., "SFX"). Default: "SFX".
*   `play_music_requested(music_key: String)`: Requests the playback of a music track or playlist.
    *   `music_key`: The key of the music/playlist to be played (defined in the `AudioManifest`).
*   `volume_changed(bus_name: String, linear_volume: float)`: Listens to its own signal to apply volume changes.

## Configuration

### `AudioManifest`

The plugin uses an `AudioManifest` (a `.tres` resource) to manage references to audio files. This manifest is automatically generated by the plugin and is crucial for compatibility in exported builds.

### Audio Paths

The root paths for SFX and music can be configured in the `CafeAudioManager` node's inspector:

*   `sfx_root_path`: Path to the folder containing sound effects (default: `res://addons/Cafe-AudioManager/assets/sfx/`).
*   `music_root_path`: Path to the folder containing music tracks (default: `res://addons/Cafe-AudioManager/assets/music/`).

## Installation and Usage

1.  **Add the Plugin:** Copy the `Cafe-AudioManager` folder to your Godot project's `addons/` folder.
2.  **Activate the Plugin:** Go to `Project > Project Settings > Plugins` and activate `Cafe-AudioManager`.
3.  **Configure Autoload:** Ensure that `CafeAudioManager` is configured as an Autoload (Singleton) in `Project > Project Settings > Autoload`.
4.  **Generate AudioManifest:** In the Godot editor, select the `CafeAudioManager` node and, in the inspector, ensure that the `AudioManifest` is assigned or generate a new one.
5.  **Refactor Audio Calls:** Replace all direct calls to the old `AudioManager` or audio signals from `GlobalEvents` with the appropriate calls to `CafeAudioManager` (via `CafeAudioManager.play_sfx_requested.emit(...)` and `CafeAudioManager.play_music_requested.emit(...)`).

---

# Plugin Cafe-AudioManager para Godot Engine (Español)

Este plugin reemplaza el sistema de audio predeterminado de la plantilla "Café Essentials - Godot Brew Kit", ofreciendo una solución robusta y desacoplada para la gestión de música y efectos de sonido (SFX) en tus proyectos de Godot. Actúa como un EventBus dedicado para audio, asegurando que la comunicación de audio esté centralizada y sea fácil de gestionar.

## Visión General

El `Cafe-AudioManager` está diseñado para simplificar la integración de audio en tus juegos, proporcionando:

*   **Carga Dinámica:** Carga automáticamente archivos de audio desde directorios configurables, categorizándolos en bibliotecas de SFX y música.
*   **Pool de Reproductores SFX:** Utiliza un pool configurable de instancias de `AudioStreamPlayer` para reproducir SFX, evitando cortes de sonido y optimizando el rendimiento.
*   **Gestión de Música:** Gestiona listas de reproducción de música, permitiendo la reproducción aleatoria de pistas dentro de una categoría y transiciones automáticas o manuales entre ellas.
*   **Control de Volumen:** Permite un control de volumen desacoplado para los buses de audio (Master, Música, SFX).
*   **Compatibilidad:** Diseñado para ser compatible con compilaciones exportadas, utilizando un `AudioManifest` generado para referenciar recursos de audio.

**Limitaciones:** Este AudioManager está diseñado exclusivamente para audio mono, sin soporte para efectos de audio posicional 2D o 3D.

## Señales (EventBus de Audio)

El `Cafe-AudioManager` actúa como su propio EventBus para audio, emitiendo y escuchando las siguientes señales:

### Señales Emitidas

*   `music_track_changed(music_key: String)`: Emitida cuando una nueva pista de música comienza a reproducirse.
*   `volume_changed(bus_name: String, linear_volume: float)`: Emitida cuando se cambia el volumen de un bus de audio.

### Señales Escuchadas

*   `play_sfx_requested(sfx_key: String, bus: String)`: Solicita la reproducción de un efecto de sonido.
    *   `sfx_key`: La clave del SFX a reproducir (definida en el `AudioManifest`).
    *   `bus`: El nombre del bus de audio (ej: "SFX"). Predeterminado: "SFX".
*   `play_music_requested(music_key: String)`: Solicita la reproducción de una pista de música o lista de reproducción.
    *   `music_key`: La clave de la música/lista de reproducción a reproducir (definida en el `AudioManifest`).
*   `volume_changed(bus_name: String, linear_volume: float)`: Escucha su propia señal para aplicar los cambios de volumen.

## Configuración

### `AudioManifest`

El plugin utiliza un `AudioManifest` (un recurso `.tres`) para gestionar las referencias a los archivos de audio. Este manifiesto es generado automáticamente por el plugin y es crucial para la compatibilidad en compilaciones exportadas.

### Rutas de Audio

Las rutas raíz para SFX y música se pueden configurar en el inspector del nodo `CafeAudioManager`:

*   `sfx_root_path`: Ruta a la carpeta que contiene los efectos de sonido (predeterminado: `res://addons/Cafe-AudioManager/assets/sfx/`).
*   `music_root_path`: Ruta a la carpeta que contiene las pistas de música (predeterminado: `res://addons/Cafe-AudioManager/assets/music/`).

## Instalación y Uso

1.  **Agregar el Plugin:** Copia la carpeta `Cafe-AudioManager` a la carpeta `addons/` de tu proyecto de Godot.
2.  **Activar el Plugin:** Ve a `Proyecto > Configuración del Proyecto > Plugins` y activa `Cafe-AudioManager`.
3.  **Configurar Autoload:** Asegúrate de que `CafeAudioManager` esté configurado como un Autoload (Singleton) en `Proyecto > Configuración del Proyecto > Autoload`.
4.  **Generar AudioManifest:** En el editor de Godot, selecciona el nodo `CafeAudioManager` y, en el inspector, asegúrate de que el `AudioManifest` esté asignado o genera uno nuevo.
5.  **Refactorizar Llamadas de Audio:** Reemplaza todas las llamadas directas al antiguo `AudioManager` o señales de audio de `GlobalEvents` con las llamadas apropiadas a `CafeAudioManager` (a través de `CafeAudioManager.play_sfx_requested.emit(...)` y `CafeAudioManager.play_music_requested.emit(...)`).
