# Xbox e Ecossistema Microsoft

Este documento detalha a integração de jogos Godot com o ecossistema Xbox e Microsoft, incluindo publicação, compatibilidade e suporte a hardware.

## 1. Publicação para Consoles Xbox

Publicar um jogo Godot diretamente para consoles Xbox (e outros) não é um processo direto com a versão pública da Godot Engine. Isso se deve a acordos de confidencialidade (NDAs) e requisitos de licenciamento de hardware impostos pelas fabricantes de console.

*   **Empresas de Portabilidade:** Para levar seu jogo Godot para o Xbox, você precisará trabalhar com **empresas terceirizadas** que são parceiras oficiais da Godot e das fabricantes de console. Empresas como a W4 Games oferecem versões especializadas da Godot que incluem os templates de exportação necessários e o suporte para cada plataforma.
*   **Programa de Desenvolvedores:** Antes de tudo, você precisa ser aprovado como um desenvolvedor registrado no programa **ID@Xbox** da Microsoft.
*   **Requisitos Técnicos (TRCs):** Seu jogo precisará cumprir os rigorosos Requisitos Técnicos de Certificação (TRCs) da Microsoft, que cobrem diversos aspectos do jogo e de sua integração com o sistema do console.

## 2. Publicação para PC Game Pass e Microsoft Store

A publicação para PC Game Pass e a Microsoft Store (para PC) é geralmente mais direta do que para consoles, pois se trata de uma plataforma de PC.

*   **Exportação do Jogo:** A Godot exporta nativamente para Windows (via exportador Win32), o que facilita a criação da versão para PC.
*   **Microsoft Store (UWP):** Embora a Godot 4.x não exporte diretamente para UWP (Universal Windows Platform), a Microsoft Store ainda aceita jogos nesse formato. É possível converter seu executável Win32 para um pacote UWP (`.appx`) utilizando ferramentas da Microsoft (ex: MSIX Packaging Tool). Isso exige uma conta de desenvolvedor e o jogo passará por um processo de certificação.
*   **PC Game Pass:** Você precisará atender aos critérios de inclusão da Microsoft para o Game Pass, que podem envolver aspectos de qualidade, desempenho e adequação ao serviço.

## 3. Xbox Play Anywhere

"Xbox Play Anywhere" é um recurso da Microsoft que permite aos jogadores comprar um jogo digitalmente uma vez e jogá-lo tanto no Xbox quanto em PCs com Windows 10/11, com saves e conquistas sincronizados. Não é uma funcionalidade que você implementa diretamente no Godot, mas sim um programa da plataforma Xbox/Windows ao qual seu jogo pode aderir se atender aos critérios da Microsoft e for publicado em ambas as plataformas.

## 4. Suporte a Gamepads Xbox

O Godot oferece um excelente suporte para gamepads, incluindo controles de Xbox, em diversas plataformas (Windows, macOS, Linux, Android, iOS e HTML5).

*   **Input Map:** A forma recomendada de lidar com a entrada de gamepads é através do sistema de "Input Map" (Mapa de Entrada) da Godot. Você define "ações" abstratas (ex: "mover_para_frente", "pular") e atribui a elas as entradas físicas desejadas (botões e eixos do controle de Xbox).
*   **API XInput vs. DirectInput:** No Windows, o Godot usa a API XInput por padrão (limite de 4 controles). Para mais de 4 controles, pode ser necessário forçar o uso da API DirectInput (com algumas limitações).
*   **Dead Zone:** O Godot possui um sistema de "dead zone" (zona morta) integrado para joysticks, ajustável por ação nas Configurações do Projeto.
*   **Entradas Analógicas:** Para joysticks, use funções como `Input.get_action_strength()` ou `Input.get_vector()` para obter um valor de ponto flutuante que representa a intensidade da entrada.

Em resumo, é possível integrar jogos Godot ao ecossistema Xbox/Microsoft, mas o processo para consoles exige parceiros de portabilidade e conformidade com os requisitos da plataforma, enquanto para PC é mais direto.
