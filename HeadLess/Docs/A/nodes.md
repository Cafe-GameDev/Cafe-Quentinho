# Documentação de Nós Fundamentais da Godot

Este documento serve como uma referência rápida para os nós mais comuns e essenciais da Godot Engine, divididos por categoria. As descrições foram compiladas da documentação oficial e do vídeo "All 219 Godot Nodes Explained In 42 Minutes".

---

## Nós 2D

Estes são os blocos de construção para qualquer jogo 2D.

- **`Node2D`**: O nó base para todos os objetos 2D. Fornece propriedades de transformação como posição, rotação e escala, que são herdadas por todos os seus filhos.

- **`Camera2D`**: Um nó que especifica o ponto de vista da sua cena em 2D. Contém parâmetros para rotação, posição e suavização de movimento, permitindo controlar o que é exibido na tela.

- **`Sprite2D`**: Um nó fundamental utilizado para exibir texturas ou imagens 2D em seus projetos. Essencial para a criação de personagens, objetos e elementos visuais.

- **`AnimatedSprite2D`**: Utilizado para animar sprites 2D, exibindo uma sequência de texturas. Facilita a criação de animações quadro a quadro a partir de uma Sprite Sheet.

- **`CollisionObject2D`**: Não pode ser usado sozinho, mas serve como classe base para todos os objetos 2D que possuem colisões. Possui propriedades para camada de colisão e se está habilitado.

- **`PhysicsBody2D`**: Não pode ser usado sozinho, mas serve como classe base para todos os objetos 2D que são afetados pela física.

- **`CharacterBody2D`**: Um tipo especializado de corpo de física 2D, projetado para ser controlado pelo jogador ou IA. Oferece uma maneira robusta de lidar com movimento e colisões, com funcionalidade embutida para controle preciso dentro da simulação física.

- **`StaticBody2D`**: Um corpo de física 2D estático. Usado para objetos que não se movem no ambiente, como chão, paredes ou tetos. Outros corpos podem colidir com ele, mas ele próprio não é movido pela simulação física.

- **`AnimatableBody2D`**: Similar ao `StaticBody2D`, mas pode ser movido por código ou animação. Ele empurrará outros corpos físicos em seu caminho, mas não é afetado pela gravidade ou outros corpos físicos.

- **`RigidBody2D`**: Um corpo de física 2D que é afetado por outros corpos físicos e pela gravidade. Usado para todos os itens físicos que podem ser movidos e não são controlados diretamente pelo jogador (ex: caixas caindo, flechas voando).

- **`CollisionShape2D`**: Um nó filho que fornece uma forma de colisão a um nó pai de física (como `CharacterBody2D`, `StaticBody2D` ou `Area2D`). Define a geometria (formato) real da colisão de um objeto.

- **`CollisionPolygon2D`**: Permite definir uma forma de colisão usando um polígono customizado, adicionando pontos a um array ou arrastando-os no editor.

- **`Joint2D`**: Classe base para todas as juntas físicas 2D. Conectam dois corpos físicos juntos.

- **`DampAndSpringJoint2D`**: Conecta dois corpos físicos como uma mola, com parâmetros para comprimento, rigidez e amortecimento da mola.

- **`GrooveJoint2D`**: Conecta dois corpos físicos como um pistão, permitindo apenas retração e extensão em um eixo de movimento.

- **`PinJoint2D`**: Usado para fixar dois corpos físicos juntos em um ponto, permitindo rotação livre em qualquer direção.

- **`Area2D`**: Uma região 2D que detecta quando outros corpos de colisão entram ou saem dela. Útil para gatilhos, coletar itens ou verificar proximidade. Pode ter suas próprias configurações de física e áudio (ex: áreas subaquáticas).

- **`AudioListener2D`**: Define um ponto de escuta para áudio 2D. Por padrão, a câmera é o ouvinte, mas este nó permite que o som seja ouvido de uma localização diferente.

- **`AudioStreamPlayer2D`**: Fonte de áudio 2D que pode ser usada para reproduzir áudio de um ponto específico no espaço, com configurações de volume, pitch, alcance e atenuação.

- **`CPUParticles2D`**: Usado para sistemas de partículas 2D processados na CPU. Uma alternativa mais simples ao `GPUParticles2D`.

- **`GPUParticles2D`**: Nó para sistemas de partículas 2D altamente performáticos, pois rodam inteiramente na GPU. O comportamento e a aparência são definidos por um `ParticleProcessMaterial`.

- **`TileMap`**: Nó para criar layouts de mapa a partir de um `TileSet`. Permite pintar tiles em camadas e configurar física e navegação diretamente nos tiles.

- **`CanvasModulate`**: Multiplica a cor de todos os elementos 2D desenhados abaixo dele. Usado para tingir ou alterar a cor geral de uma cena 2D, essencial para configurar sombras 2D.

- **`Light2D`**: Classe base para todas as luzes 2D. Adiciona fontes de luz a uma cena 2D, com propriedades como cor, energia e modo de mistura.

- **`PointLight2D`**: Emite luz de um ponto específico em 2D, projetando sombras e simulando fontes de luz locais.

- **`DirectionalLight2D`**: Emite luz em uma única direção, simulando uma fonte de luz distante como o sol, para iluminação global em 2D.

- **`LightOccluder2D`**: Define áreas que bloqueiam a luz em 2D, trabalhando com `Light2D` para criar sombras e controlar efeitos de iluminação.

- **`Line2D`**: Permite desenhar linhas 2D adicionando pontos a um array. Possui propriedades para estilo, largura e arredondamento.

- **`Marker2D`**: Um nó de depuração que mostra sua posição e rotação no editor. Útil para rastrear nós invisíveis ou pontos no espaço.

- **`MeshInstance2D`**: Usado para renderizar uma malha (modelo 3D) em 2D. Possui propriedades para a malha e seu material.

- **`MultiMeshInstance2D`**: Renderiza eficientemente um grande número de cópias idênticas de uma malha em 2D, otimizando a performance para milhares de objetos próximos.

- **`NavigationRegion2D`**: Define uma área navegável para agentes de navegação 2D, gerando uma malha de navegação para pathfinding.

- **`NavigationLink2D`**: Conecta duas malhas ou regiões de navegação separadas, permitindo que agentes se desloquem entre áreas desconectadas.

- **`NavigationObstacle2D`**: Define um obstáculo para agentes de navegação 2D, impedindo que passem por certas áreas.

- **`ParallaxLayer`**: Usado para criar efeitos de paralaxe em jogos 2D, movendo elementos visuais em diferentes velocidades em relação à câmera para criar ilusão de profundidade.

- **`ParallaxBackground`**: Nó para criar efeitos de paralaxe em fundos 2D, permitindo que diferentes camadas de fundo se movam em velocidades variadas.

- **`Path2D`**: Define um caminho 2D (curva Bézier) para mover objetos ao longo de uma trajetória predefinida.

- **`PathFollow2D`**: Nó filho de `Path2D` que permite a um nó seguir um caminho definido, calculando sua posição e rotação ao longo da curva.

- **`Polygon2D`**: Permite definir formas 2D usando um polígono, adicionando pontos a um array ou arrastando-os no editor.

- **`RayCast2D`**: Dispara um raio em uma dada direção para detecção de colisão, reportando se atingiu algo e o ponto de colisão. Comumente usado em mecânicas de tiro e interação.

- **`ShapeCast2D`**: Funciona como o `RayCast2D`, mas verifica colisões usando uma forma (ex: retângulo, círculo) em vez de uma linha fina, para áreas maiores.

- **`RemoteTransform2D`**: Aplica a transformação (posição, rotação, escala) de seu nó pai a outro `Node2D` na árvore de cena, agindo como um pai sem ser na hierarquia direta.

- **`Skeleton2D`**: Usado para criar uma hierarquia de ossos (`Bone2D`) para deformação esquelética 2D, permitindo animações mais flexíveis.

- **`Bone2D`**: Um nó que faz parte de um `Skeleton2D`, usado para rigging em animações 2D de recorte, com posição, rotação e escala relativas ao seu pai.

- **`PhysicalBone2D`**: Simula um osso em um sistema de ragdoll 2D, aplicando física a um `Bone2D` para animações realistas baseadas em física.

- **`VisibleOnScreenNotifier2D`**: Detecta quando seu retângulo delimitador entra ou sai da tela, emitindo sinais para otimizar o desempenho.

- **`VisibleOnScreenEnabler2D`**: Desativa nós quando não estão visíveis na tela, otimizando o desempenho ao desativar renderização, física e processamento.

- **`CanvasGroup`**: Usado para mesclar todos os seus filhos em uma única chamada de desenho, útil para combinar texturas eficientemente.

- **`BackBufferCopy`**: Copia uma região da tela para uma textura, que pode ser usada em shaders para efeitos de pós-processamento como desfoque ou distorção.

---

## Nós de Controle (UI)

Estes são os blocos de construção para todas as interfaces de usuário (menus, HUDs, etc.).

- **`Control`**: O nó base para todos os elementos de UI. Oferece funcionalidades para eventos de entrada, desenho e gerenciamento de layout, essencial para UIs responsivas.

- **`Container`**: Classe base para todos os diferentes tipos de contêineres. Mantém outros nós dentro dele e determina como eles são posicionados.

- **`AspectRatioContainer`**: Garante que seus controles filhos mantenham uma proporção de aspecto específica, útil para elementos de UI que precisam escalar preservando suas proporções.

- **`BoxContainer`**: Classe base para `VBoxContainer` e `HBoxContainer`, alinha elementos horizontal ou verticalmente.

- **`VBoxContainer`**: Organiza seus controles filhos verticalmente em uma coluna.

- **`HBoxContainer`**: Organiza seus controles filhos horizontalmente em uma linha.

- **`CenterContainer`**: Centraliza seus nós filhos dentro de suas próprias bordas.

- **`FlowContainer`**: Organiza seus filhos em uma linha horizontal ou vertical, quebrando para a próxima linha/coluna quando não há mais espaço, como texto em uma caixa.

- **`GridContainer`**: Organiza seus controles filhos em uma grade, útil para inventários e formulários.

- **`HSplitContainer`**: Organiza dois controles filhos horizontalmente com um divisor arrastável, permitindo redimensionar a proporção.

- **`VSplitContainer`**: Organiza dois controles filhos verticalmente com um divisor arrastável, permitindo redimensionar a proporção.

- **`MarginContainer`**: Adiciona uma margem configurável em todos os lados de seus controles filhos, útil para espaçamento consistente.

- **`PanelContainer`**: Exibe um painel e redimensiona seus filhos para caberem dentro dele, comumente usado para agrupar elementos de UI visualmente.

- **`ScrollContainer`**: Adiciona barras de rolagem quando o conteúdo é maior que seu tamanho, permitindo rolar para ver todo o conteúdo.

- **`TabContainer`**: Gerencia múltiplos controles filhos, exibindo apenas um por vez através de uma interface de abas.

- **`Label`**: Usado para exibir texto simples ou formatado.

- **`RichTextLabel`**: Exibe texto formatado com suporte a fontes personalizadas, cores, imagens e BBCode.

- **`ColorRect`**: Exibe um retângulo de cor sólida, útil para fundos ou depuração de UI.

- **`TextureRect`**: Exibe uma textura dentro de uma interface, similar ao `ColorRect` mas com imagem.

- **`VideoStreamPlayer`**: Reproduz vídeos dentro da UI.

- **`Separator`**: Classe base para linhas divisórias horizontais ou verticais.

- **`HSeparator`**: Desenha uma linha horizontal para separar elementos de UI.

- **`VSeparator`**: Desenha uma linha vertical para separar elementos de UI.

- **`Panel`**: Exibe um painel com um estilo definido pelo `Theme`, usado como fundo ou contêiner visual.

- **`NinePatchRect`**: Exibe uma textura usando uma grade 3x3, permitindo criar elementos de UI escaláveis sem distorcer cantos ou bordas.

- **`BaseButton`**: Classe base abstrata para todos os tipos de botões, oferecendo funcionalidades comuns como eventos de pressionar e soltar.

- **`Button`**: Um nó de controle que oferece um botão clicável, emitindo um sinal `pressed`.

- **`TextureButton`**: Exibe uma textura para seus estados (normal, pressionado, etc.), ideal para botões visualmente ricos.

- **`LinkButton`**: Comporta-se como um hiperlink, usado para criar links clicáveis dentro da UI.

- **`CheckBox`**: Permite ao usuário alternar entre dois estados: ligado (marcado) ou desligado (desmarcado).

- **`CheckButton`**: Um tipo de botão que pode ser ativado ou desativado, adicionando uma caixa de seleção à sua esquerda.

- **`MenuButton`**: Exibe um `PopupMenu` quando pressionado, usado para criar menus suspensos.

- **`OptionButton`**: Exibe um menu pop-up com uma lista de opções para o usuário escolher, similar a um menu suspenso.

- **`ColorPickerButton`**: Abre um `ColorPicker` em um pop-up, permitindo ao usuário selecionar uma cor.

- **`LineEdit`**: Campo de entrada de texto em uma única linha, com propriedades para formatação e comprimento máximo.

- **`TextEdit`**: Editor de texto multilinha para exibir e permitir a edição de blocos de texto.

- **`CodeEdit`**: Controle de edição de texto multilinha com destaque de sintaxe, numeração de linhas e autocompletar, projetado para editores de código.

- **`ProgressBar`**: Exibe uma barra horizontal representando um valor percentual, comumente usada para barras de vida ou carregamento.

- **`TexturedProgressBar`**: Exibe o progresso usando texturas para o estado vazio, preenchido e fundo, oferecendo flexibilidade visual.

- **`SpinBox`**: Permite inserir valores numéricos com botões de seta para ajustar o valor.

- **`ScrollBar`**: Classe base para barras de rolagem (`HScrollBar`, `VScrollBar`).

- **`HScrollBar`**: Fornece uma barra de rolagem horizontal.

- **`VScrollBar`**: Fornece uma barra de rolagem vertical.

- **`Slider`**: Permite selecionar um valor movendo um botão arrastável ao longo de uma trilha linear.

- **`HSlider`**: Controle deslizante horizontal.

- **`VSlider`**: Controle deslizante vertical.

- **`ItemList`**: Exibe uma lista de itens clicáveis, onde cada item pode conter texto e um ícone.

- **`MenuBar`**: Permite configurar uma linha de menus suspensos, usando `PopupMenu` para cada item.

- **`TabBar`**: Exibe uma lista de abas, permitindo que os usuários selecionem uma aba e emitindo sinais quando uma aba é pressionada, alterada ou fechada.

- **`ReferenceRect`**: Um nó de depuração que mostra um retângulo no editor, útil para visualizar áreas de layout ou limites.

---

## Nós Fundamentais e Utilitários

Estes são nós fundamentais ou ferramentas que são usados em diversos contextos.

- **`Node`**: A classe base para **todos** os outros nós na Godot. Um projeto é uma árvore de Nós. Fornece a funcionalidade mais básica, como nome, processamento e a capacidade de ter filhos.

- **`CanvasLayer`**: Cria uma camada de renderização 2D separada. Essencial para UIs, pois garante que os elementos (como um HUD) permaneçam fixos na tela, independentemente do movimento da câmera no mundo do jogo.

- **`AnimationPlayer`**: Uma ferramenta extremamente poderosa para animar praticamente qualquer propriedade de qualquer nó ao longo do tempo. Usado para cinemáticas, animações de UI complexas e eventos de personagem detalhados.

- **`Timer`**: Um cronômetro que emite um sinal após um intervalo de tempo definido. Útil para criar delays, contagens regressivas ou ações periódicas.