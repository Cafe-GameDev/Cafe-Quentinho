# Guia de Padrões: Sistema de Configurações

Este projeto contém um `SettingsManager` como um Singleton (AutoLoad), que é responsável por gerenciar, salvar, carregar e aplicar as configurações do jogo. Este guia documenta como ele funciona.

## Visão Geral

O `SettingsManager` utiliza a classe `ConfigFile` da Godot, que é ideal para salvar dados de configuração em um formato de texto simples e legível (`.cfg`), similar a arquivos `.ini`.

*   **Arquivo de Save:** As configurações são salvas em `user://settings.cfg`.
*   **Inicialização:** Ao iniciar o jogo (`_ready`), o manager carrega as configurações do arquivo. Se o arquivo não existir, ele salva as configurações padrão e as aplica.

## Estrutura dos Dados

Todas as configurações são armazenadas em um único dicionário chamado `settings` dentro do script. Ele é organizado em seções:

```gdscript
var settings: Dictionary = {
    "audio": {
        "master_volume": 1.0,
        "music_volume": 1.0,
        "sfx_volume": 1.0
    },
    "video": {
        "resolution": "1920x1080",
        "fullscreen": false,
        "vsync": true,
        "fps_limit": 0 # 0 means unlimited
    }
}
```
*   **`audio`**: Controla os volumes dos canais de áudio principais.
*   **`video`**: Controla as configurações de exibição, como resolução, modo de tela e performance.

## Fluxo de Save e Load

*   **`save_settings()`**: Esta função cria uma instância de `ConfigFile`, percorre o dicionário `settings` e escreve cada chave e valor nas suas respectivas seções (`[audio]`, `[video]`). Finalmente, salva o arquivo em `user://settings.cfg`.

*   **`load_settings()`**: Esta função tenta carregar o arquivo `settings.cfg`. Se conseguir, ela lê os valores de cada seção e chave, atualizando o dicionário `settings` no script. Se um valor não existir no arquivo, ele mantém o valor padrão.

## Aplicação das Configurações

A função `apply_settings()` é o coração do sistema. Ela lê os valores do dicionário `settings` e os aplica no jogo:

*   **Áudio:** Chama o `AudioManager` (outro Singleton) para definir o volume de cada canal de áudio (`Master`, `Music`, `SFX`), convertendo os valores lineares (0.0 a 1.0) para decibéis.
*   **Vídeo:** Chama funções do `DisplayServer` para alterar a resolução da janela, modo de tela (janela ou tela cheia) e V-Sync. Também define o `Engine.max_fps` para limitar o FPS.

## Como Usar na UI (Exemplo)

Para conectar um elemento de UI, como um slider de volume, ao sistema:

1.  **Conecte o Sinal:** No editor, conecte o sinal `value_changed(value)` do seu `HSlider` a um método no script da sua UI de configurações.

2.  **Chame o Manager:** No método, chame a função correspondente no `SettingsManager`, aplique as configurações e salve.

```gdscript
# Em um script de UI de configurações (ex: menu_settings.gd)

func _on_master_volume_slider_value_changed(value: float):
    # 1. Atualiza o valor no manager
    SettingsManager.set_master_volume(value)
    
    # 2. Aplica a mudança em tempo real
    SettingsManager.apply_settings()

func _on_save_button_pressed():
    # 3. Salva todas as configurações no arquivo ao sair do menu
    SettingsManager.save_settings()
```

Este padrão mantém a lógica de configurações centralizada, enquanto permite que qualquer cena de UI interaja com ela de forma simples e desacoplada.
