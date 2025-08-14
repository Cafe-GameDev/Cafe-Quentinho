# Path Tracing e Iluminação Avançada

O Godot Engine, por padrão, não possui um renderizador de *path tracing* em tempo real integrado como uma funcionalidade central. No entanto, a comunidade tem desenvolvido soluções avançadas que permitem o *path tracing* e iluminação global realista, especialmente na Godot 4.

### Path Tracing em Godot

Embora não seja nativo, projetos da comunidade têm implementado o *path tracing* na Godot 4, aproveitando as capacidades de renderização modernas, como o Vulkan. Um exemplo notável é o **JenovaRTX**, um renderizador de *path tracing* em tempo real alimentado por RTX para Godot 4+. Ele oferece recursos como:

*   Iluminação Global com *Path Tracing*.
*   Reflexões e refrações com *Path Tracing*.
*   Oclusão de ambiente com *Path Tracing*.
*   Suporte a DLSS e reconstrução de raios.

Este projeto é desenvolvido como um *add-on* e não requer modificações no código-fonte do Godot Engine. Outras implementações de *path tracing* baseadas em *shaders* de computação Vulkan também existem, demonstrando a flexibilidade da Godot para extensões de renderização.

É importante notar que o *path tracing* é computacionalmente intensivo e, para desempenho em tempo real, geralmente exige GPUs poderosas com suporte a *ray tracing* por hardware.

### Iluminação Avançada Nativa na Godot 4

A Godot 4 trouxe melhorias significativas para seu sistema de iluminação, oferecendo métodos robustos de iluminação global que não são *path tracing* completo, mas proporcionam resultados visuais impressionantes:

*   **SDFGI (Signed Distance Field Global Illumination):** Ideal para cenas dinâmicas, o SDFGI calcula a iluminação global em tempo real, permitindo que a luz se propague e interaja com o ambiente de forma realista.
*   **VoxelGI:** Oferece resultados de alta qualidade para cenas estáticas, pré-calculando a iluminação global em voxels.
*   **LightmapGI:** A opção mais eficiente para dispositivos móveis, que pré-calcula a iluminação em mapas de luz.

Além desses, a Godot oferece os nós de luz tradicionais (DirectionalLight, OmniLight, SpotLight) com diversas configurações, bem como *reflection probes* para reflexões precisas e o nó *WorldEnvironment* para controlar a luz ambiente e efeitos de pós-processamento.
