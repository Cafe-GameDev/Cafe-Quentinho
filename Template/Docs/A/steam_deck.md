# Steam Deck

O Steam Deck é um computador de mão para jogos desenvolvido pela Valve Corporation, projetado para rodar jogos disponíveis na loja Steam.

## 1. Especificações de Hardware

O Steam Deck é equipado com uma APU AMD personalizada, que inclui uma CPU Zen 2 de 4 núcleos/8 threads (2.4-3.5GHz) e uma GPU RDNA 2 com 8 unidades de computação (1.6GHz), com um consumo de energia de 4-15W. Possui 16 GB de RAM LPDDR5 integrada (5500 MT/s ou 6400 MT/s em modelos OLED), configurada em quad-channel, oferecendo uma largura de banda de até 102.4 GB/s nos modelos OLED.

Em termos de armazenamento, o Steam Deck oferece opções de SSD NVMe de 512 GB ou 1 TB, além de um slot para cartão microSD de alta velocidade para expansão.

A tela varia entre os modelos:
*   **Modelos LCD:** Tela sensível ao toque IPS LCD de 7 polegadas com resolução de 1280x800 pixels a 60 Hz e 400 nits de brilho.
*   **Modelos OLED:** Tela sensível ao toque HDR OLED de 7.4 polegadas com resolução de 1280x800 pixels a 90 Hz e 1.000 nits de brilho máximo, oferecendo maior contraste e cores mais vibrantes.

Os controles incluem botões A B X Y, D-pad, gatilhos e botões de ombro L e R, botões View e Menu, e 4 botões traseiros atribuíveis. Possui dois analógicos de tamanho normal com toque capacitivo, dois trackpads quadrados de 32.5mm com feedback háptico e sensibilidade à pressão, e um giroscópio de 6 eixos.

Para áudio, conta com alto-falantes estéreo com DSP integrado, microfones duplos e uma entrada de 3.5mm para fone de ouvido/microfone. A conectividade inclui USB-C com suporte a DisplayPort 1.4, Bluetooth (5.0 para LCD, 5.3 para OLED) e Wi-Fi (5 para LCD, 6E para OLED).

## 2. Sistema Operacional (OS)

O Steam Deck roda o **SteamOS 3**, uma distribuição Linux focada em jogos, baseada no Arch Linux. O SteamOS foi otimizado para a experiência de jogo portátil e é constantemente atualizado. Ele utiliza o **Proton**, uma camada de compatibilidade, que permite que jogos desenvolvidos para Windows sejam executados no SteamOS sem a necessidade de portabilidade direta pelos desenvolvedores. O dispositivo também oferece um modo desktop com o ambiente KDE Plasma.

## 3. Publicação de Jogos

Para publicar jogos na Steam e, consequentemente, torná-los disponíveis para o Steam Deck, os desenvolvedores precisam aderir ao Programa de Desenvolvedores Steamworks. Isso envolve a assinatura de documentos digitais, fornecimento de informações bancárias e fiscais, e o pagamento de uma taxa única de US$100 por produto. Essa taxa é reembolsável se o jogo gerar US$1.000 em receita bruta de vendas na loja Steam. Os desenvolvedores podem fazer o upload de suas builds de jogo para o Steamworks.

## 4. Adaptação de Jogos para Steam Deck

A Valve implementou um programa "Deck Verified" para informar aos usuários como os jogos funcionam no Steam Deck. Para uma adaptação ideal, os desenvolvedores devem considerar os seguintes pontos:
*   **Controles:** O jogo deve suportar os controles físicos do Steam Deck. A configuração padrão do controle deve permitir acesso a todo o conteúdo sem que o usuário precise ajustar as configurações do jogo.
*   **Glifos de Controle:** Os glifos exibidos na tela devem corresponder aos nomes dos botões do Deck ou do Xbox 360/One.
*   **Resolução e Legibilidade:** Recomenda-se que o jogo suporte as resoluções nativas do Deck (1280x800 preferencialmente, ou 1280x720). O texto da interface deve ser facilmente legível a uma distância de 30 cm da tela, com o menor caractere de fonte não caindo abaixo de 9 pixels de altura em 1280x800.
*   **Desempenho:** Os jogos devem lidar graciosamente com as mudanças dinâmicas de velocidade do clock da CPU e GPU, sem introduzir travamentos ou quedas de taxa de quadros. O objetivo é uma taxa de quadros mínima consistente de 30fps em configurações médias.
*   **Integração da Plataforma:** A otimização inclui a integração adequada com recursos do SteamOS, como funcionalidade de suspender/retomar, compatibilidade com a sobreposição de acesso rápido e suporte à configuração do Steam Input.

Os desenvolvedores podem usar o SteamOS Devkit Client para conectar-se a um Steam Deck e fazer o upload e depuração de builds de jogos diretamente no dispositivo.
