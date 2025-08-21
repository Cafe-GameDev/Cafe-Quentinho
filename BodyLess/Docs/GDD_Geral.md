# Game Design Document (GDD) Geral: Cafe-Quentinho Template

## 1. Visão Geral do Jogo

O "Cafe-Quentinho Template" é um projeto base para o desenvolvimento de jogos no Godot Engine, focado em fornecer uma arquitetura robusta, modular e desacoplada. Ele serve como um ponto de partida para diversos gêneros de jogos, oferecendo sistemas essenciais de UI, áudio, salvamento, configurações e internacionalização, além de estruturas para mecânicas de jogo como inventário, combate e inimigos. O objetivo principal é acelerar o desenvolvimento, promovendo boas práticas de engenharia de software e design de jogos.

## 2. Público-Alvo

Desenvolvedores de jogos Godot, desde iniciantes que buscam uma base sólida até experientes que desejam um template otimizado para prototipagem rápida e desenvolvimento de projetos complexos.

## 3. Filosofia de Design: "BodyLess" e Desacoplamento

A arquitetura "BodyLess" é o pilar central deste template. Ela enfatiza o **desacoplamento total** entre os sistemas, garantindo que cada componente seja independente e se comunique apenas através de um "Barramento de Eventos" (Event Bus). Isso resulta em um código mais limpo, fácil de manter, testar e estender.

### Princípios Chave:

*   **EventBus (`GlobalEvents`, `LocalEvents`):** Toda a comunicação entre sistemas (Autoloads/Singletons, cenas, UI) ocorre via emissão e escuta de sinais. Nenhum sistema chama diretamente funções em outro.
*   **Dicionários (`Dictionary`):** Dados são passados entre sistemas encapsulados em dicionários, promovendo a flexibilidade e evitando referências diretas a nós ou objetos complexos.
*   **Recursos (`Resource`):** Dados de jogo (itens, armas, inimigos, quests) são definidos como `Resource`s personalizados, permitindo a criação de assets de dados reutilizáveis e configuráveis.
*   **Autoloads (Singletons):** Utilizados para sistemas globais (gerenciadores de áudio, save, input, etc.), mas sempre interagindo via EventBus.

## 4. Mecânicas Centrais (Comuns a Todos os Modos)

Embora o template suporte múltiplos gêneros, algumas mecânicas são universais:

*   **Sistema de Configurações:** Gerenciamento de áudio, vídeo, idioma e outras preferências do jogador, com persistência de dados.
*   **Sistema de Salvamento:** Persistência do progresso do jogo, incluindo dados do jogador e do mundo, com suporte a múltiplas sessões de save.
*   **Sistema de Inventário:** Gerenciamento de itens coletáveis, com slots, uso e descarte. Suporte a diferentes tipos de itens (consumíveis, armas).
*   **Sistema de Combate Básico:** Estruturas para dano, saúde, e interação entre jogador e inimigos.
*   **Sistema de Input:** Mapeamento de teclas configurável e traduzível, com suporte a teclado e gamepad.
*   **Internacionalização (I18N):** Suporte a múltiplos idiomas para todos os textos da UI, nomes e descrições de itens, armas e inimigos.

## 5. Interface de Usuário (UI)

A UI é projetada para ser modular, responsiva e informativa, comunicando-se com os sistemas de jogo via EventBus.

*   **Menus Principais:** Menu Inicial, Menu de Pausa, Menu de Opções (Áudio, Vídeo, Idioma).
*   **HUD (Heads-Up Display):** Barra de vida, hotbar de inventário, indicadores de munição.
*   **Sistemas de Feedback Visual:**
    *   **Tooltips:** Dicas de ferramenta contextuais para elementos da UI e itens do inventário.
    *   **Popovers:** Diálogos de confirmação e informações detalhadas (ex: detalhes de itens).
    *   **Toasts/Snackbars:** Notificações temporárias e não intrusivas (ex: "Item Coletado", "Configurações Salvas").
    *   **Coach Marks:** Guias visuais para onboarding de novas mecânicas ou funcionalidades.
*   **Console de Depuração:** Ferramenta embutida para monitorar eventos e estados do jogo.

## 6. Estrutura de Conteúdo (Exemplos)

Para demonstrar as mecânicas, o template incluirá exemplos de:

*   **Itens:**
    *   **Poção de Cura:** Restaura vida.
    *   **Poção de Aumento de Dano:** Aumento temporário de dano.
    *   Outros itens a serem definidos (ex: chave, moeda).
*   **Armas:**
    *   **Soco:** Ataque corpo a corpo básico.
    *   **Espada:** Arma corpo a corpo.
    *   **Arco:** Arma de longo alcance.
    *   **Pistola:** Arma de fogo.
    *   **Granada:** Arma explosiva.
    *   **Metralhadora:** Arma de fogo de alta cadência.
*   **Inimigos:**
    *   **Boneco de Treino:** Inimigo estático para testes.
    *   **Robô Patrulha:** Inimigo com IA de patrulha.
    *   **Caçador:** Inimigo com IA de perseguição.

## 7. Diretrizes de Arte e Som

*   **Arte:** O template será agnóstico a estilo de arte, mas os exemplos visuais (sprites, modelos 3D) seguirão um estilo simples e funcional para prototipagem. A ênfase é na clareza e na demonstração das mecânicas.
*   **Som:** Sons de UI, música de fundo e efeitos sonoros básicos serão incluídos para demonstrar o `AudioManager` e o áudio espacial.

## 8. Considerações Técnicas

*   **Godot Engine:** Versão 4.x (especificamente 4.4.1).
*   **Linguagem:** GDScript.
*   **Otimização:** Implementação de técnicas básicas de otimização (pooling de objetos, otimização de shaders) para garantir bom desempenho.
*   **Acessibilidade:** Inclusão de opções de acessibilidade (modos daltônicos, remapeamento de controles, redução de tremores de tela).

## 9. Modos de Jogo Suportados (com GDDs separados)

O template será capaz de gerar projetos para os seguintes modos de jogo, cada um com seu próprio GDD detalhado:

*   **TopDown (2D):** Visão de cima, movimento em 8 direções.
*   **Platformer (2D):** Jogo de plataforma tradicional.
*   **3D:** Jogo em ambiente tridimensional, com suporte a visão em primeira e terceira pessoa.

---

**Este GDD Geral serve como a base para os GDDs específicos de cada modo de jogo, garantindo que todos os subprojetos compartilhem a mesma visão e princípios arquiteturais.**
