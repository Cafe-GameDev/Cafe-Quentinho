# Addons (Plugins)

Addons na Godot Engine são ferramentas ou funcionalidades extras que estendem as capacidades do editor ou adicionam recursos específicos ao seu projeto. Eles são como "plugins" que você pode instalar para otimizar seu fluxo de trabalho ou adicionar funcionalidades complexas de forma modular.

#### Como Instalar um Addon

Existem algumas maneiras de instalar addons na Godot:

1.  **Através do AssetLib (Biblioteca de Assets):**
    *   A maneira mais comum e recomendada. Dentro do editor Godot, vá para a aba "AssetLib".
    *   Pesquise pelo addon desejado.
    *   Clique em "Download" e, em seguida, em "Install". O Godot fará o download e colocará os arquivos do addon na pasta `addons/` do seu projeto.

2.  **Manualmente:**
    *   Se você baixar um addon de uma fonte externa (como GitHub), você precisará descompactá-lo.
    *   Copie a pasta do addon (que geralmente contém um arquivo `plugin.cfg`) para a pasta `addons/` dentro do diretório raiz do seu projeto Godot. Se a pasta `addons/` não existir, você pode criá-la.

#### Como Gerenciar um Addon

Após a instalação, um addon precisa ser ativado para ser usado no seu projeto.

1.  **Ativando/Desativando Addons:**
    *   No editor Godot, vá em `Projeto` -> `Configurações do Projeto...` -> `Plugins`.
    *   Você verá uma lista de todos os addons detectados na pasta `addons/`.
    *   Para ativar um addon, certifique-se de que o status esteja como "Ativo". Se não estiver, clique no botão para ativá-lo. Você também pode desativar addons aqui.

2.  **Estrutura de um Addon:**
    *   Um addon típico reside em uma subpasta dentro de `res://addons/`.
    *   Cada addon deve ter um arquivo `plugin.cfg` na sua raiz. Este arquivo contém metadados sobre o plugin, como nome, descrição, autor e versão.
    *   O arquivo `plugin.gd` (ou outro nome de script) é o script principal do plugin, que contém a lógica para registrar e desregistrar o plugin no editor.

#### Exemplos de Uso de Addons

Addons podem ser usados para uma vasta gama de funcionalidades:

*   **Ferramentas de Editor:** Adicionar novas ferramentas ao editor Godot, como geradores de mapas, editores de diálogo personalizados, ou ferramentas de alinhamento de nós.
*   **Nós Personalizados:** Introduzir novos tipos de nós que podem ser usados nas suas cenas, como um nó de "Máquina de Estado" ou um nó de "Inventário".
*   **Sistemas de Jogo:** Fornecer sistemas completos que podem ser facilmente integrados ao seu jogo, como um sistema de save/load, um gerenciador de conquistas, ou um sistema de diálogo complexo.
*   **Integração com Ferramentas Externas:** Facilitar a integração com softwares externos, como um importador de modelos 3D de um formato específico ou um sistema de controle de versão.

#### Addons e Ferramentas Recomendadas (Identificadas para este Projeto)

Com base em nossa pesquisa e nas necessidades de um projeto Godot, especialmente um Metroidvania, os seguintes addons e ferramentas são altamente recomendados:

-   **Godot Unit Test (GUT):** O framework de testes unitários mais popular para Godot. Essencial para garantir a qualidade do código e prevenir bugs em projetos complexos.
-   **Dialogic:** Uma ferramenta completa para criar diálogos, árvores de conversas e quests com um editor visual, ideal para jogos com foco narrativo.
-   **Godot State Charts:** Um editor visual para criar e gerenciar Máquinas de Estado Finitas (FSMs), facilitando o controle de comportamento de personagens e outros sistemas.
-   **Aseprite Wizard:** Essencial para quem usa Aseprite para pixel art, pois automatiza a importação de animações, agilizando o fluxo de trabalho.
-   **Godot Rich Text Effect:** Uma coleção de efeitos de texto (ondulado, arco-íris, etc.) para o nó `RichTextLabel`, ótimo para dar mais vida a diálogos.
-   **Godot Git Plugin:** Integra o sistema de controle de versão Git diretamente no editor da Godot, agilizando o fluxo de trabalho de desenvolvimento.
