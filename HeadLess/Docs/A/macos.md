# macOS

Para adaptar e publicar seu projeto Godot para macOS, é importante considerar alguns pontos específicos além do processo de exportação padrão da Godot.

### 1. Exportação Básica para macOS na Godot

1.  **Configuração de Exportação:** No editor Godot, vá em `Projeto` -> `Exportar`.
2.  **Adicionar Predefinição:** Adicione uma nova predefinição para `macOS`.
3.  **Template de Exportação:** Certifique-se de ter o template de exportação para macOS instalado. Se não tiver, a Godot geralmente oferece para baixá-lo automaticamente.
4.  **Opções de Exportação:**
    *   **`Executable Name`**: O nome do seu aplicativo (ex: `MeuJogo.app`).
    *   **`Bundle Identifier`**: Um identificador único para seu aplicativo (ex: `com.suaempresa.meujogo`). Isso é crucial para a assinatura de código e notarização.
    *   **`Icon`**: Defina o ícone do seu aplicativo (formato `.icns`).
    *   **`Use Pck`**: Geralmente recomendado para empacotar os dados do jogo em um único arquivo `.pck`.

### 2. Assinatura de Código (Code Signing) e Notarização da Apple

Para que seu aplicativo seja executado em macOS sem avisos de segurança (como "aplicativo de desenvolvedor não identificado") e para ser distribuído, ele precisa ser assinado e notarizado.

*   **Assinatura de Código (Code Signing):**
    *   Você precisará de uma conta de desenvolvedor Apple (Apple Developer Program).
    *   Crie um certificado de desenvolvedor (Developer ID Application) e um perfil de provisionamento (Provisioning Profile) no portal da Apple.
    *   A Godot pode ser configurada para assinar seu aplicativo durante o processo de exportação, usando as informações do seu certificado. Isso garante que o macOS confie na origem do seu aplicativo.

*   **Notarização da Apple:**
    *   Mesmo após a assinatura, a Apple exige que os aplicativos distribuídos fora da Mac App Store sejam "notarizados". Isso significa que a Apple escaneia seu aplicativo em busca de malware e problemas de segurança.
    *   O processo de notarização geralmente envolve o upload do seu aplicativo assinado para os servidores da Apple. Se aprovado, a Apple anexa um "ticket" ao seu aplicativo, permitindo que ele seja executado sem avisos de segurança em máquinas macOS.
    *   A Godot não faz a notarização automaticamente. Você precisará usar ferramentas de linha de comando do macOS (como `xcrun altool` e `stapler`) após a exportação para enviar seu aplicativo para notarização e "grampear" o ticket de volta ao seu `.app` bundle.

### 3. Distribuição

*   **Mac App Store:**
    *   Se você planeja distribuir seu jogo pela Mac App Store, o processo de exportação e assinatura é um pouco diferente e mais rigoroso. Você precisará de um certificado de "Mac App Store Distribution" e seguir as diretrizes específicas da Apple para submissão.
    *   A Godot suporta a exportação para a Mac App Store, mas você ainda precisará usar o Xcode e o App Store Connect para o processo de submissão final.

*   **Distribuição Direta (fora da Mac App Store):**
    *   Para distribuição via seu site, Itch.io, Steam, etc., você precisará do aplicativo assinado e notarizado.
    *   O arquivo final será um `.app` bundle, que pode ser compactado em um `.zip` ou empacotado em um `.dmg` (imagem de disco) para facilitar a distribuição.

### 4. Considerações de Segurança

*   **Gerenciamento de Chaves de API:** **Nunca** armazene chaves de API ou outros segredos diretamente no seu código-fonte. Para macOS, isso é ainda mais crítico, pois o aplicativo pode ser facilmente inspecionado. Use arquivos de configuração externos ou variáveis de ambiente.
*   **Proteção de Dados de Save:** Para dados de save, utilize `FileAccess.open_encrypted_with_pass()` para adicionar uma camada básica de segurança contra manipulação casual.
