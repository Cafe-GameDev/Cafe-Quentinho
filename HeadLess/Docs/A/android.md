# Android

Para adaptar seu projeto Godot para exportação e publicação no Android, é crucial considerar alguns pontos chave para garantir a melhor experiência e funcionalidade.

## 1. Portabilidade e Adaptação para Dispositivos Móveis

*   **Sistema de Input Abstrato:** Utilize o **Input Map** da Godot para mapear ações (ex: "mover_para_cima") em vez de teclas específicas. Isso permite associar gestos de toque, botões virtuais ou controles físicos, tornando o jogo compatível com diversas formas de interação em dispositivos móveis.
*   **Layout de UI Adaptativo:** Use os nós de `Control` e `Container` (como `HBoxContainer`, `VBoxContainer`, `GridContainer`) para construir suas interfaces. Domine as propriedades de **Layout** (Âncoras, Margens, `Size Flags`) para que sua UI se ajuste automaticamente a diferentes resoluções e proporções de tela de dispositivos Android.
*   **Caminhos de Arquivo Universais:** Sempre use os caminhos relativos da Godot. Para acessar assets do projeto, utilize `res://` (ex: `res://Scenes/player.tscn`). Para salvar e carregar dados do jogador (saves, configurações), use `user://` (ex: `user://save_game.dat`), que aponta para um local seguro e apropriado no sistema de arquivos do usuário, independentemente da plataforma.

## 2. Publicação e Segurança

*   **Compilação de Scripts:** Ao exportar para Android, a Godot compila seus scripts `.gd` para o formato `.gdc`. Isso não só melhora a performance, mas também oferece uma camada básica de ofuscação, dificultando a engenharia reversa do seu código-fonte.
*   **Gerenciamento de Chaves de API:** **Nunca** armazene chaves de API, senhas de banco de dados ou outros segredos diretamente no seu código-fonte. O ideal é carregá-los a partir de um arquivo de configuração (ex: `secrets.cfg`) que deve ser adicionado ao seu `.gitignore` para não ser versionado.
*   **Proteção de Dados de Save:** Para uma proteção simples contra manipulação, evite salvar dados do jogador em texto puro. Utilize `FileAccess.open_encrypted_with_pass()` para salvar e carregar arquivos com uma senha, adicionando uma camada de segurança.

## 3. Monetização (se aplicável)

*   **Compras no Aplicativo (IAP):** A Godot oferece um plugin oficial de IAP que unifica a API para a Google Play Store. Você precisará configurar seus produtos (consumíveis, não consumíveis, assinaturas) no painel de desenvolvedor da Google Play.
*   **Anúncios (Ads):** Para integrar anúncios (banner, intersticiais, recompensados), você precisará de um SDK de uma rede de anúncios (como AdMob). A comunidade Godot mantém plugins para as principais redes.

Lembre-se de testar exaustivamente seu jogo em diferentes dispositivos Android para garantir a compatibilidade e o desempenho.
