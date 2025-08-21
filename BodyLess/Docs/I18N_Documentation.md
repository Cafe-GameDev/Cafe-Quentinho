# Documentação de Internacionalização (I18N)

Este documento detalha o processo de internacionalização (I18N) no projeto "Cafe-Quentinho Template", com foco na manutenção dos arquivos `.po` e na garantia de que todas as chaves de tradução estejam presentes em todos os idiomas suportados.

## 1. Visão Geral da Internacionalização

O Godot Engine utiliza arquivos `.po` (Portable Object) para gerenciar as traduções. No "Cafe-Quentinho Template", o idioma padrão do projeto (e a base para novas traduções) é o **Inglês (US)**, representado pelo arquivo `en_US.po`. Para os usuários finais, um middleware implementado no jogo é responsável por definir o idioma, mas para o editor Godot, o inglês é o padrão quando as chaves de tradução dos demais idiomas não estão presentes.

### Estrutura de Arquivos

Os arquivos de tradução estão localizados em `BodyLess/I18N/`. Cada arquivo `.po` corresponde a um idioma específico (ex: `pt_BR.po` para Português do Brasil, `es_LA.po` para Espanhol da América Latina).

## 2. Chaves de Tradução Essenciais

É uma prioridade que todas as traduções essenciais para a experiência do usuário estejam completas em todos os arquivos `.po`. Isso garante uma experiência de usuário consistente, independentemente do idioma selecionado.

### 2.1. Chaves de Tradução de Menu (UI Geral)

Estas chaves são definidas no `en_US.po` e se estendem aproximadamente até a linha 286 (conforme o estado atual do template).

*   **Títulos de Menu:** `UI_MAIN_MENU_TITLE`, `UI_PAUSE_MENU_TITLE`, `UI_SETTINGS_TITLE`
*   **Opções de Jogo:** `UI_NEW_GAME`, `UI_RESUME_GAME`, `UI_OPTIONS`, `UI_EXIT`
*   **Confirmações:** `UI_QUIT_CONFIRMATION_PROMPT`, `UI_YES`, `UI_NO`
*   **Configurações:** `UI_VIDEO`, `UI_AUDIO`, `UI_BACK`, `UI_APPLY`, `UI_LANGUAGE`
*   **Opções de Vídeo:** `UI_VIDEO_OPTIONS`, `UI_FULLSCREEN`, `UI_MONITOR`, `UI_WINDOW_MODE_WINDOWED`, `UI_WINDOW_MODE_FULLSCREEN`, `UI_RESOLUTION`, `UI_DRS_OFF`, `UI_DRS_CUSTOM`, `UI_FPS_CUSTOM`, `UI_VSYNC_OFF`, `UI_VSYNC_ON`, `UI_VSYNC_ADAPTIVE`, `UI_QUALITY_LOW`, `UI_QUALITY_MEDIUM`, `UI_QUALITY_HIGH`, `UI_COLORBLIND_OFF`, `UI_COLORBLIND_PROTANOPIA`, `UI_COLORBLIND_DEUTERANOPIA`, `UI_COLORBLIND_TRITANOPIA`
*   **Opções de Áudio:** `UI_AUDIO_OPTIONS`, `UI_MASTER_VOLUME`, `UI_MUSIC_VOLUME`, `UI_SFX_VOLUME`
*   **Opções de Idioma:** `UI_LANGUAGE_OPTIONS`, e todas as chaves `UI_LANGUAGE_XX_YY` para os idiomas suportados.
*   **Mensagens do Console de Depuração:** `DEBUG_CONSOLE_READY`, `DEBUG_LOG_TITLE`, `DEBUG_GAME_SECTION`, `DEBUG_GAME_VERSION`, `DEBUG_GAME_STATE`, `DEBUG_CURRENT_SCENE`, `DEBUG_LAST_SAVE`, `DEBUG_SYSTEM_SECTION`, `DEBUG_OS`, `DEBUG_DISPLAY_SECTION`, `DEBUG_MONITOR_INFO`, `DEBUG_SIGNAL_RECEIVED`, `DEBUG_WITH_ARGS`, `DEBUG_PROCESSOR`, `DEBUG_CORES`, `DEBUG_RAM`, `DEBUG_VIDEO_ADAPTER`, `DEBUG_VIDEO_DRIVER`, `DEBUG_VIDEO_RENDERER`

### 2.2. Chaves de Tradução para Tooltips

As tooltips fornecem informações contextuais para elementos da UI e itens. Cada tooltip terá um título e uma descrição.

*   `TOOLTIP_GAMMA_CORRECTION_TITLE`
*   `TOOLTIP_GAMMA_CORRECTION_DESC`
*   `TOOLTIP_MASTER_VOLUME_TITLE`
*   `TOOLTIP_MASTER_VOLUME_DESC`
*   `TOOLTIP_MUSIC_VOLUME_TITLE`
*   `TOOLTIP_MUSIC_VOLUME_DESC`
*   `TOOLTIP_SFX_VOLUME_TITLE`
*   `TOOLTIP_SFX_VOLUME_DESC`
*   `TOOLTIP_MONITOR_TITLE`
*   `TOOLTIP_MONITOR_DESC`
*   `TOOLTIP_WINDOW_MODE_TITLE`
*   `TOOLTIP_WINDOW_MODE_DESC`
*   `TOOLTIP_RESOLUTION_TITLE`
*   `TOOLTIP_RESOLUTION_DESC`
*   `TOOLTIP_ASPECT_RATIO_TITLE`
*   `TOOLTIP_ASPECT_RATIO_DESC`
*   `TOOLTIP_DYNAMIC_RENDER_SCALE_TITLE`
*   `TOOLTIP_DYNAMIC_RENDER_SCALE_DESC`
*   `TOOLTIP_RENDER_SCALE_TITLE`
*   `TOOLTIP_RENDER_SCALE_DESC`
*   `TOOLTIP_FRAME_RATE_LIMIT_TITLE`
*   `TOOLTIP_FRAME_RATE_LIMIT_DESC`
*   `TOOLTIP_MAX_FRAME_RATE_TITLE`
*   `TOOLTIP_MAX_FRAME_RATE_DESC`
*   `TOOLTIP_VSYNC_MODE_TITLE`
*   `TOOLTIP_VSYNC_MODE_DESC`
*   `TOOLTIP_CONTRAST_TITLE`
*   `TOOLTIP_CONTRAST_DESC`
*   `TOOLTIP_BRIGHTNESS_TITLE`
*   `TOOLTIP_BRIGHTNESS_DESC`
*   `TOOLTIP_SHADERS_QUALITY_TITLE`
*   `TOOLTIP_SHADERS_QUALITY_DESC`
*   `TOOLTIP_EFFECTS_QUALITY_TITLE`
*   `TOOLTIP_EFFECTS_QUALITY_DESC`
*   `TOOLTIP_COLORBLIND_MODE_TITLE`
*   `TOOLTIP_COLORBLIND_MODE_DESC`
*   `TOOLTIP_REDUCE_SCREEN_SHAKE_TITLE`
*   `TOOLTIP_REDUCE_SCREEN_SHAKE_DESC`
*   `TOOLTIP_UI_SCALE_TITLE`
*   `TOOLTIP_UI_SCALE_DESC`

### 2.3. Chaves de Tradução para Itens (Inventário)

Cada item no jogo terá um nome e uma descrição traduzíveis.

*   `ITEM_HEALING_POTION_NAME`
*   `ITEM_HEALING_POTION_DESC`
*   `ITEM_DAMAGE_BOOST_NAME`
*   `ITEM_DAMAGE_BOOST_DESC`
*   `ITEM_GENERIC_NAME`
*   `ITEM_GENERIC_DESC`

### 2.4. Chaves de Tradução para Armas

Cada arma no jogo terá um nome e uma descrição traduzíveis.

*   `WEAPON_PUNCH_NAME`
*   `WEAPON_PUNCH_DESC`
*   `WEAPON_SWORD_NAME`
*   `WEAPON_SWORD_DESC`
*   `WEAPON_BOW_NAME`
*   `WEAPON_BOW_DESC`
*   `WEAPON_PISTOL_NAME`
*   `WEAPON_PISTOL_DESC`
*   `WEAPON_GRENADE_NAME`
*   `WEAPON_GRENADE_DESC`
*   `WEAPON_MACHINE_GUN_NAME`
*   `WEAPON_MACHINE_GUN_DESC`

### 2.5. Chaves de Tradução para Inimigos

Cada tipo de inimigo no jogo terá um nome e uma descrição traduzíveis.

*   `ENEMY_DUMMY_NAME`
*   `ENEMY_DUMMY_DESC`
*   `ENEMY_PATROL_BOT_NAME`
*   `ENEMY_PATROL_BOT_DESC`
*   `ENEMY_HUNTER_NAME`
*   `ENEMY_HUNTER_DESC`

### 2.6. Chaves de Tradução para HUD e Mensagens de Jogo

Elementos da HUD e mensagens contextuais em jogo.

*   `UI_INVENTORY_TITLE`
*   `UI_INVENTORY_USE_BUTTON`
*   `UI_INVENTORY_DROP_BUTTON`
*   `UI_INVENTORY_EMPTY_SLOT`
*   `UI_HEALTH`
*   `UI_AMMO`
*   `UI_RELOAD_PROMPT`

### 2.7. Chaves de Tradução para Toasts

Mensagens de notificação temporárias.

*   `TOAST_SETTINGS_SAVED_TITLE`
*   `TOAST_SETTINGS_SAVED_MESSAGE`
*   `TOAST_ITEM_COLLECTED_TITLE`
*   `TOAST_ITEM_COLLECTED_MESSAGE`
*   `TOAST_ERROR_SAVE_FAILED_TITLE`
*   `TOAST_ERROR_SAVE_FAILED_MESSAGE`
*   `TOAST_LOAD_SUCCESS_MESSAGE`
*   `TOAST_ERROR_LOAD_FAILED_MESSAGE`
*   `TOAST_ITEM_USED_MESSAGE`
*   `TOAST_ITEM_EQUIPPED_MESSAGE`

### 2.8. Chaves de Tradução para Popovers

Diálogos de confirmação e informações detalhadas.

*   `POPOVER_CONFIRM_USE_ITEM_TITLE`
*   `POPOVER_CONFIRM_USE_ITEM_MESSAGE`
*   `POPOVER_YES`
*   `POPOVER_NO`

### 2.9. Chaves de Tradução para Coach Marks (Tutorial)

Guias visuais passo a passo.

*   `COACH_MARK_WELCOME_TITLE`
*   `COACH_MARK_WELCOME_MESSAGE`
*   `COACH_MARK_MOVEMENT_TITLE`
*   `COACH_MARK_MOVEMENT_MESSAGE`
*   `COACH_MARK_PAUSE_TITLE`
*   `COACH_MARK_PAUSE_MESSAGE`
*   `COACH_MARK_INVENTORY_TITLE`
*   `COACH_MARK_INVENTORY_MESSAGE`
*   `COACH_MARK_SKIP_BUTTON`
*   `COACH_MARK_NEXT_BUTTON`

### 2.10. Chaves de Tradução para Mapeamento de Teclas (Input)

Nomes das ações de input para exibição na UI.

*   `INPUT_INVENTORY_NAME`
*   `INPUT_RELOAD_NAME`
*   `INPUT_SPECIAL_NAME`
*   `INPUT_SPRINT_NAME`
*   `INPUT_CROUCH_NAME`
*   `INPUT_MOVE_LEFT_NAME`
*   `INPUT_MOVE_RIGHT_NAME`
*   `INPUT_MOVE_UP_NAME`
*   `INPUT_MOVE_DOWN_NAME`
*   `INPUT_JUMP_NAME`
*   `INPUT_ATTACK_NAME`

## 3. Processo de Verificação e Preenchimento

Para garantir a completude das traduções, siga os passos abaixo:

1.  **Obtenha as Chaves de Referência:** O arquivo `en_US.po` serve como a fonte primária de todas as chaves de tradução. Certifique-se de que este arquivo esteja sempre atualizado com todas as chaves necessárias.

2.  **Verifique Outros Arquivos `.po`:** Para cada idioma suportado, abra o arquivo `.po` correspondente.

3.  **Compare e Adicione Chaves Ausentes:** Compare as chaves presentes no arquivo do idioma com as chaves de referência do `en_US.po`. Se alguma chave estiver faltando, adicione-a ao arquivo do idioma, utilizando a tradução em inglês como valor `msgstr` inicial. Isso garante que a chave exista, mesmo que a tradução específica para aquele idioma ainda não esteja disponível.

    Exemplo de adição de uma chave ausente:

    ```po
    msgid "UI_NEW_MISSING_KEY"
    msgstr "New Missing Key"
    ```

4.  **Atualize os Cabeçalhos:** Verifique se os cabeçalhos de cada arquivo `.po` estão corretamente definidos, incluindo `Project-Id-Version`, `Report-Msgid-Bugs-To`, `POT-Creation-Date`, `PO-Revision-Date`, `Last-Translator`, `Language-Team`, `Language`, `MIME-Version`, `Content-Type`, `Content-Transfer-Encoding` e `X-Generator`.

## 4. Ferramentas de Suporte

Para facilitar a manutenção dos arquivos `.po`, você pode utilizar ferramentas como:

*   **Poedit:** Um editor de arquivos `.po` que oferece uma interface gráfica para tradução e verificação de chaves.
*   **`msgmerge` (Gettext):** Uma ferramenta de linha de comando que pode ser usada para mesclar arquivos `.po` e atualizar chaves.

## 5. Boas Práticas

*   **Consistência:** Mantenha a consistência na terminologia e no estilo de tradução em todos os idiomas.
*   **Contexto:** Forneça contexto suficiente para os tradutores, especialmente para frases que podem ter múltiplos significados.
*   **Testes:** Sempre teste as traduções no jogo para garantir que elas apareçam corretamente e não causem problemas de layout.

Ao seguir estas diretrizes, garantimos que o "Cafe-Quentinho Template" ofereça uma experiência de internacionalização robusta e de alta qualidade.