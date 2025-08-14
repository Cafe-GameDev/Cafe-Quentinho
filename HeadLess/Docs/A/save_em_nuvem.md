# Save em Nuvem

A Godot Engine, por padrão, utiliza o diretório `user://` para salvar dados localmente no dispositivo do jogador. Para implementar um sistema de **salvamento na nuvem (Cloud Save)**, você precisará integrar seu jogo com serviços externos, pois a Godot não oferece uma solução nativa de cloud save.

### Abordagens Comuns para Implementar o Salvamento na Nuvem:

1.  **Serviços de Plataforma:**
    *   **Steam Cloud:** Se você planeja lançar seu jogo na Steam, a plataforma oferece um serviço de salvamento na nuvem. Você precisará integrar o SDK da Steam (geralmente via plugins como o GodotSteam) e usar suas APIs para sincronizar os arquivos de save do jogador com a nuvem.
    *   **Google Play Games Services (Android) / Apple Game Center (iOS):** Para jogos mobile, essas plataformas oferecem funcionalidades de salvamento na nuvem. A integração é feita através dos SDKs específicos e plugins da Godot que os encapsulam.
    *   **Outras Plataformas (Xbox, PlayStation, Nintendo):** Cada console possui seu próprio serviço de cloud save. A integração para essas plataformas geralmente envolve o uso de versões licenciadas da Godot (como as oferecidas pela W4 Games) e seus respectivos SDKs.

2.  **Backend Personalizado:**
    *   Você pode criar seu próprio serviço de backend (usando tecnologias como Node.js, Python com FastAPI, PHP, etc.) e um banco de dados (SQL, NoSQL) para armazenar os dados de save dos jogadores.
    *   Seu jogo Godot se comunicaria com este backend através de requisições HTTP (usando `HTTPClient` ou `HTTPRequest` na Godot) para enviar e receber os dados de save.
    *   Esta abordagem oferece total controle e flexibilidade, mas exige mais trabalho de desenvolvimento e manutenção do lado do servidor.

### Recomendações para Implementação:

*   **Singleton `SaveManager`:** Conforme as diretrizes do "Repo Café", utilize um Singleton `SaveManager` para centralizar toda a lógica de salvamento e carregamento. Este Singleton seria responsável por:
    *   Coletar os dados de save do jogo.
    *   Serializar esses dados (por exemplo, para JSON ou binário).
    *   Interagir com a API do serviço de nuvem escolhido (ou seu backend personalizado) para enviar e receber os dados.
    *   Gerenciar a resolução de conflitos caso haja saves diferentes na nuvem e localmente.
*   **Segurança:**
    *   **Criptografia:** Sempre criptografe os dados de save, especialmente se estiver usando um backend personalizado. Isso protege contra manipulação e engenharia reversa. A Godot oferece `FileAccess.open_encrypted_with_pass()` para criptografia básica de arquivos locais. Para a nuvem, você precisaria de uma solução de criptografia mais robusta antes de enviar os dados.
    *   **Validação:** Se usar um backend personalizado, valide os dados de save no servidor para evitar que jogadores enviem dados corrompidos ou trapaceados.
*   **Experiência do Usuário:**
    *   Forneça feedback visual ao jogador sobre o status do salvamento na nuvem (ex: "Salvando na nuvem...", "Erro ao sincronizar save").
    *   Considere a possibilidade de o jogador escolher entre o save local e o save na nuvem em caso de conflito.

Em resumo, o salvamento na nuvem em Godot é realizado através da integração com serviços externos, e um `SaveManager` bem estruturado é fundamental para gerenciar essa complexidade.
