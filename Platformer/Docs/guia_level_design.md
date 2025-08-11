# Guia de Padrões: Level Design

Level Design é a arte de criar os espaços onde o jogo acontece. Na Godot, isso envolve uma combinação de ferramentas do editor e boas práticas de organização.

## Filosofia Principal: Cenas Instanciadas

A abordagem mais poderosa na Godot é construir seu nível a partir de cenas independentes.
*   **Jogador, Inimigos, Itens:** Cada um deve ser sua própria cena (`.tscn`).
*   **Nível Principal:** É uma cena que instancia todas as outras. Um `EnemySpawner` instancia cenas de inimigos, um `TileMap` define o layout, etc.
*   **Vantagem:** Modularidade. Você pode testar cada componente de forma isolada e reutilizá-los em diferentes níveis.

## Level Design 2D: O Poder do TileMap

A ferramenta principal para 2D é o nó `TileMap`.
*   **TileSet:** Primeiro, você cria um `Resource` `TileSet`, que é a paleta de "peças" que você usará para construir o nível.
*   **Pintando o Nível:** Com o `TileMap`, você pode literalmente pintar o layout do seu nível, incluindo colisões, navegação e física, diretamente no editor.
*   **Camadas (Layers):** Use múltiplas camadas para organizar os elementos: uma para o chão (com colisão), uma para o fundo (sem colisão), e uma para decoração na frente do jogador.
*   **Terrains (Autotiling):** Configure "terrains" no seu `TileSet` para que a Godot desenhe automaticamente as bordas e cantos corretos entre diferentes tipos de tile (ex: grama e terra), economizando muito tempo.

## Level Design 3D: Múltiplas Abordagens

*   **GridMap:** Similar ao `TileMap`, mas para 3D. Você constrói o nível usando um conjunto de assets 3D modulares (paredes, pisos, rampas) que se encaixam em uma grade.
*   **CSG (Constructive Solid Geometry):** Nós que permitem "esculpir" o layout do nível diretamente no editor, combinando e subtraindo formas primitivas. Ótimo para prototipagem rápida.
*   **Modelagem Externa:** Modelar o nível inteiro em um software como o Blender e importá-lo para a Godot. É o método que oferece mais controle artístico, mas exige mais trabalho de importação e exportação.

## Boas Práticas

*   **Use Sinais:** Para que os elementos do nível se comuniquem. Uma porta não deve saber sobre o jogador; ela deve abrir ao receber um sinal `abrir_porta`.
*   **Camadas de Colisão:** Organize o que colide com o quê nomeando suas camadas de física em **Projeto > Configurações do Projeto > Nomes das Camadas > Física 2D/3D**.
