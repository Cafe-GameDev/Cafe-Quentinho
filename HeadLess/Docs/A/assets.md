# Assets

Na Godot Engine, **Assets** são todos os recursos externos que você utiliza no seu projeto, como imagens, modelos 3D, arquivos de áudio, fontes, etc. A Godot possui um pipeline de assets flexível e eficiente, que permite importar diversos tipos de arquivos diretamente para o seu projeto. A chave para um bom gerenciamento é entender as configurações de importação e manter uma estrutura de pastas organizada.

#### 1. Processo Geral de Importação

Quando você copia um arquivo de asset para a pasta do seu projeto Godot, o editor o detecta automaticamente e inicia o processo de importação.

*   **Configurações de Importação:** No painel "FileSystem" (Sistema de Arquivos) do editor Godot, selecione o asset importado. No painel "Import" (Importar), você verá as configurações específicas para aquele tipo de arquivo.
*   **Reimportar:** Após ajustar as configurações, clique em "Reimport" (Reimportar) para aplicar as mudanças. A Godot armazena as configurações de importação em um arquivo `.import` adjacente ao asset original, garantindo que as configurações sejam mantidas e versionadas.

#### 2. Configurações de Importação para Diferentes Tipos de Assets

**a. Imagens (Texturas)**

*   **Pixel Art:** Para manter a nitidez e evitar o "borrão" em pixel art, as configurações são cruciais:
    *   `Modo` de Compressão: **`VRAM Sem Perdas`** (Lossless VRAM).
    *   `Filtro` de Textura: Desative (Nearest).
    *   Clique em "Reimportar".
*   **Arte Vetorial (SVG):** A Godot importa arquivos `.svg` nativamente, mas os rasteriza (converte para pixels) na importação.
    *   A `Escala` nas configurações de importação é vital para a qualidade final. Para UIs ou assets que precisam de alta resolução, aumente a escala antes de reimportar.
*   **Imagens Gerais (Sprites, Fundos):**
    *   `Modo` de Compressão: Geralmente `VRAM Com Perdas` (Lossy VRAM) para otimização de memória, ou `VRAM Sem Perdas` para maior fidelidade.
    *   `Filtro` de Textura: `Linear` para suavização, `Nearest` para pixel art.
    *   `Gerar Mipmaps`: Ative para texturas 3D ou grandes texturas 2D que serão escaladas, para evitar artefatos visuais.

**b. Áudio**

*   **Formatos:**
    *   `.ogg` (Ogg Vorbis): Recomendado para a maioria dos assets de áudio (música e SFX longos) devido à boa compressão e qualidade.
    *   `.wav` (WAV): Ideal para SFX curtos e que precisam ser repetidos em loop com precisão (como um som de metralhadora), pois não sofre de artefatos de compressão no início/fim.
*   **Configurações:**
    *   `Loop`: Marque esta opção na aba de importação para sons que devem ser repetidos continuamente (música de fundo, sons de ambiente).
    *   `Modo` de Compressão: `MP3` ou `Ogg Vorbis` para arquivos maiores, `WAV` para arquivos menores ou que precisam de alta fidelidade.

**c. Modelos 3D**

*   **Fluxo de Trabalho Integrado (`.blend`):** O método mais robusto é usar arquivos `.blend` diretamente. Isso exige uma configuração única (apontar o caminho para o executável do Blender nas configurações do editor Godot: `Editor Settings -> FileSystem -> Import -> Blender`). Com isso, você edita seu modelo no Blender e vê as atualizações na Godot instantaneamente ao salvar.
*   **Formato de Distribuição (`.glb` ou `.gltf`):** O formato glTF 2.0 é o padrão da indústria para assets 3D. Use-o para compartilhar assets ou para otimizações finais do seu projeto.
*   **Configurações Comuns:**
    *   `Root Type`: Define o tipo de nó raiz que o modelo será importado como (geralmente `Node3D`).
    *   `Meshes`: Opções para otimização de malhas, como `Compress` ou `Gen Lightmap UVs`.
    *   `Materials`: Como os materiais do modelo serão importados (ex: `Keep` para manter os materiais do arquivo, `Convert to Godot Materials`).
    *   `Animations`: Opções para importar animações, incluindo `Loop` e `FPS`.

#### 3. Organização de Pastas

Uma estrutura de pastas consistente é a espinha dorsal de um projeto limpo e escalável. O padrão recomendado pelo "Repo Café" é:

*   `addons/`: Para plugins e ferramentas de terceiros.
*   `Assets/`: Para todos os assets de arte e áudio. Pode ser subdividido por tipo:
    *   `Assets/Sprites/`
    *   `Assets/Models/`
    *   `Assets/Music/`
    *   `Assets/SFX/`
*   `Resources/`: Para todos os seus arquivos de Recurso (`.tres`), como dados de personagens, itens, configurações de níveis, etc.
*   `Scenes/`: Para todas as suas cenas (`.tscn`). É comum subdividir por tipo:
    *   `Scenes/Levels/`
    *   `Scenes/Characters/`
    *   `Scenes/UI/`
*   `Scripts/`: Para todos os seus scripts (`.gd`, `.cs`). A estrutura aqui deve espelhar a de `Scenes/` sempre que possível.
*   `Shaders/`: Para todos os seus shaders customizados (`.gdshader`).
*   `Singletons/`: Para scripts que serão carregados como Singletons (AutoLoads).
*   `Tests/`: Para os testes unitários.
*   `UI/`: Um local específico para assets de UI, como fontes (`.ttf`, `.otf`) e temas (`.theme`).

#### 4. Considerações Adicionais

*   **Licenças de Assets de Terceiros:** Ao usar assets de terceiros (Mixamo, Sketchfab, Kenney.nl), **sempre verifique a licença** para garantir que ela é compatível com o seu projeto.
*   **Otimização:** A Godot oferece ferramentas para otimização de performance, como o Profiler e Monitores de Performance, que podem ajudar a identificar assets que estão causando gargalos.
