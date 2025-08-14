# HTML5

Para adaptar uma exportação HTML5 do Godot para publicação, é crucial considerar otimização, compatibilidade e experiência do usuário.

## 1. Configuração de Exportação no Godot

*   **Template de Exportação:** Certifique-se de ter o template de exportação HTML5 instalado na sua versão do Godot. Vá em `Projeto > Gerenciar Modelos de Exportação...` e instale o modelo correspondente à sua versão do Godot.
*   **Configurações de Projeto:**
    *   `Projeto > Configurações do Projeto > Geral > Display > Window`: Ajuste `Size` para a resolução base do seu jogo. Considere `Mode` (e.g., `Viewport`, `2D`) e `Aspect` (e.g., `Keep`, `Expand`) para como o jogo se adaptará a diferentes tamanhos de tela.
    *   `Projeto > Configurações do Projeto > Geral > Export > HTML5`:
        *   `Custom HTML Shell`: Você pode usar um shell HTML personalizado para adicionar elementos como um carregador de progresso customizado, botões de tela cheia, ou integrar com APIs de terceiros.
        *   `Head Include`: Adicione tags HTML personalizadas ao `<head>` do seu arquivo HTML, útil para metadados, CSS externo ou scripts.
        *   `Progress Message`: Mensagem exibida durante o carregamento.
        *   `Canvas Resize Policy`: Define como o canvas do jogo se redimensiona. `None` (tamanho fixo), `Adapt to Window` (redimensiona com a janela do navegador), `Can Shrink/Grow` (permite encolher/crescer).
        *   `Experimental Features`: Ative se necessário, mas teste cuidadosamente.
*   **Exportar:** Vá em `Projeto > Exportar...`, selecione `HTML5` e clique em `Exportar Projeto`. Escolha uma pasta vazia para exportar.

## 2. Otimização para Web

*   **Compressão:**
    *   **`Exportar > HTML5 > Exportar > Compression`**: Escolha `Gzip` ou `Brotli`. `Brotli` geralmente oferece melhor compressão, mas pode não ser suportado por todos os servidores. Certifique-se de que seu servidor web esteja configurado para servir arquivos `.wasm`, `.js`, `.html` e `.pck` com a compressão correta.
    *   **Otimização de Assets:** Comprima imagens (PNG, JPG), áudios (OGG para música, WAV para SFX curtos) e vídeos para reduzir o tamanho total do download.
*   **Carregamento Progressivo:**
    *   O Godot carrega o arquivo `.pck` inteiro antes de iniciar o jogo. Para jogos muito grandes, considere dividir assets ou usar carregamento sob demanda, embora isso exija mais lógica de programação.
*   **Remoção de Código Não Utilizado:**
    *   Em `Projeto > Configurações do Projeto > Geral > Editor > Export`, você pode ativar `Export with Debug` para desativar o modo de depuração na exportação final, o que pode reduzir o tamanho do arquivo e melhorar o desempenho.
    *   Remova assets e scripts não utilizados do seu projeto.

## 3. Adaptação para Publicação

*   **Responsividade (UI/UX):**
    *   Utilize os nós `Control` e `Container` do Godot para criar interfaces de usuário que se adaptem a diferentes resoluções e proporções de tela. Use `Anchors` e `Size Flags` para garantir que sua UI se comporte bem em telas de desktop e mobile.
    *   Considere um `CanvasLayer` para o HUD para que ele sempre seja desenhado sobre o jogo, independentemente da câmera.
*   **Input:**
    *   Garanta que seu jogo suporte tanto mouse/teclado quanto toque para dispositivos móveis. Use o `Input Map` do Godot para mapear ações abstratas (e.g., "pular") a diferentes inputs.
*   **Tela de Carregamento (Loading Screen):**
    *   A tela de carregamento padrão do Godot é funcional, mas você pode criar uma personalizada usando o `Custom HTML Shell` para melhorar a experiência do usuário. Isso permite adicionar um indicador de progresso mais visual ou elementos de branding.
*   **Modo Tela Cheia:**
    *   Forneça um botão ou atalho para o modo tela cheia no seu jogo HTML5, pois muitos jogadores preferem essa experiência imersiva. Isso pode ser feito via JavaScript no seu `Custom HTML Shell` ou usando a função `OS.window_fullscreen = true` no Godot.
*   **Persistência de Dados:**
    *   Para salvar o progresso do jogador, use `user://` para armazenar dados. Em HTML5, isso geralmente se traduz em `IndexedDB` ou `localStorage` do navegador.
*   **Integração com Plataformas (itch.io, Newgrounds, etc.):**
    *   Cada plataforma pode ter requisitos específicos para o upload e a configuração do seu jogo HTML5. Siga as diretrizes de cada uma. Por exemplo, itch.io tem um sistema de upload direto para arquivos HTML5.

## 4. Hospedagem

*   **Servidor Web:** Você precisará de um servidor web (Apache, Nginx, ou serviços de hospedagem estática como Netlify, GitHub Pages, Vercel) para hospedar seus arquivos exportados.
*   **Configuração MIME Types:** Certifique-se de que seu servidor esteja configurado para servir os tipos MIME corretos para os arquivos do Godot:
    *   `.html`: `text/html`
    *   `.js`: `application/javascript`
    *   `.wasm`: `application/wasm`
    *   `.pck`: `application/octet-stream`
    *   `.zip` (se usar compressão zip): `application/zip`
    *   `.br` (se usar Brotli): `application/x-brotli`
    *   `.gz` (se usar Gzip): `application/gzip`

Ao seguir essas diretrizes, você pode garantir que seu jogo Godot exportado para HTML5 seja otimizado, responsivo e pronto para ser publicado e desfrutado por um público amplo.
