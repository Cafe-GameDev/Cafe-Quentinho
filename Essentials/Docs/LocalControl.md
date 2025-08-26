# Documentação: `LocalControl` (Autoload)

### Propósito

O `LocalControl` é um Autoload (Singleton) que atua como o **cérebro central e adaptável** para a lógica de jogo específica de uma cena. Diferente de outros Managers que seguem um padrão estrito de desacoplamento via EventBus para todas as interações, o `LocalControl` é projetado para ser uma "placa-mãe" genérica. Ele oferece um conjunto de funcionalidades e um ponto de acesso direto para os nós internos da cena de jogo, permitindo uma sincronia e controle mais íntimos sobre o estado e o comportamento do jogo em execução.

Ele é **modular e agnóstico ao tipo de jogo**, adaptando suas funcionalidades com base nas necessidades do jogo atualmente ativo. Um jogo de "cobrinha" pode usar apenas o gerenciamento de pontuação, enquanto um RPG complexo pode utilizar o controle de estado do jogador, dados de ambiente e progresso de fase.

### Princípios de Design

*   **Modularidade e Adaptabilidade:** O `LocalControl` não impõe uma estrutura de dados ou funcionalidades. Ele expõe um conjunto de "slots" (métodos e propriedades genéricas) que cada jogo pode "conectar" e utilizar conforme necessário.
*   **Ponto de Acesso Direto (para nós locais):** Embora se comunique com sistemas globais via `GlobalEvents`, os nós *dentro da cena de jogo ativa* podem acessar o `LocalControl` diretamente para consultar estados ou invocar funcionalidades, otimizando a performance e a simplicidade para lógicas de jogo intensivas.
*   **Agnóstico ao Estado do Jogo:** Ele não define os estados específicos do jogo (ex: "invencível", "morto"). Em vez disso, ele fornece mecanismos para que o *jogo ativo* registre e gerencie esses estados através dele.
*   **Integração com `GlobalEvents`:** Utiliza o `GlobalEvents` para:
    *   **Inicialização:** Receber a "identidade" do jogo ativo e suas configurações iniciais.
    *   **Persistência:** Coletar dados de sistemas locais e enviá-los ao `SaveSystem`.
    *   **Comunicação Global:** Emitir sinais sobre eventos importantes do jogo local para outros Singletons.
*   **Resistência à Pausa:** Como um Autoload, suas operações não são afetadas pelo `get_tree().paused`, garantindo que a lógica de controle continue funcionando mesmo quando o jogo está pausado.

### Comunicação e Fluxo de Dados

1.  **Inicialização do Jogo (`GlobalEvents`):**
    *   Quando um jogo é carregado (ex: via `SceneControl`), ele emite um sinal no `GlobalEvents` (ex: `game_loaded(game_id: String, config: Dictionary)`).
    *   O `LocalControl` ouve este sinal e usa o `game_id` e `config` para inicializar suas funcionalidades e registrar as funções e estados específicos que o jogo ativo irá utilizar.

2.  **Gerenciamento de Dados Locais:**
    *   O `LocalControl` mantém dicionários internos para armazenar estados do jogador, dados da máquina de estados do jogo e referências a `Callables` (funções) fornecidas pelo jogo.
    *   Os nós da cena de jogo podem interagir diretamente com o `LocalControl` para atualizar ou consultar esses dados.

3.  **Persistência (`GlobalEvents` -> `SaveSystem`):**
    *   Quando o `SaveSystem` (ou outro sistema global) solicita o salvamento de dados do jogo (via `GlobalEvents.request_saving_game_data_requested`), o `LocalControl` inicia um processo de coleta.
    *   Ele emite sinais específicos (ex: `GlobalEvents.request_local_data(data_type: String)`) para que os sistemas locais (Player, Environment, Stage, etc.) respondam com seus dados.
    *   Os sistemas locais respondem emitindo `GlobalEvents.local_data_received(data_type: String, data: Dictionary)`.
    *   Após coletar todos os dados necessários, o `LocalControl` os compila em um único `Dictionary` e o envia ao `SaveSystem` via `GlobalEvents.sending_game_data(game_data: Dictionary)`.
    *   Imediatamente após o envio, o `LocalControl` limpa seu dicionário interno de dados de salvamento para evitar persistência indesejada.

### Funcionalidades Genéricas (Exemplos)

O `LocalControl` pode expor uma vasta gama de métodos genéricos que os jogos podem utilizar. Estes são apenas exemplos e a lista pode ser expandida conforme a necessidade:

*   **Gerenciamento de Estado do Jogador:**
    *   `set_player_state(key: String, value: Variant)`: Define um estado específico para o jogador (ex: "invencível", "morto", "pulando").
    *   `get_player_state(key: String) -> Variant`: Retorna o valor de um estado do jogador.
    *   `is_player_in_state(key: String) -> bool`: Verifica se o jogador está em um determinado estado.

*   **Registro e Invocação de Funções do Jogo:**
    *   `register_game_function(key: String, callable_func: Callable)`: Permite que o jogo registre funções específicas que podem ser chamadas pelo `LocalControl` ou por outros nós.
    *   `call_game_function(key: String, args: Array = []) -> Variant`: Invoca uma função registrada.

*   **Gerenciamento de Dados da Máquina de Estados do Jogo:**
    *   `set_game_state_machine_data(key: String, value: Variant)`: Armazena dados relacionados à máquina de estados do jogo (ex: estado atual, transições permitidas).
    *   `get_game_state_machine_data(key: String) -> Variant`: Retorna dados da máquina de estados.

*   **Gerenciamento de Pontuação/Progresso:**
    *   `update_score(amount: int)`: Atualiza a pontuação do jogo.
    *   `get_score() -> int`: Retorna a pontuação atual.
    *   `set_level_progress(progress: float)`: Define o progresso do nível (0.0 a 1.0).

*   **Gerenciamento de Itens/Inventário Local:**
    *   `add_item_to_local_inventory(item_id: String, quantity: int)`: Adiciona um item ao inventário local do jogo.
    *   `remove_item_from_local_inventory(item_id: String, quantity: int)`: Remove um item.

*   **Gerenciamento de Eventos Locais:**
    *   `emit_local_game_event(event_name: String, data: Dictionary = {})`: Emite um evento específico do jogo local para outros nós que estejam ouvindo o `LocalControl` diretamente.

### Sinais Necessários no `GlobalEvents`

Para suportar a comunicação com o `LocalControl`, os seguintes sinais devem ser adicionados ao `GlobalEvents`:

*   **`game_loaded(game_id: String, config: Dictionary)`**
    *   **Propósito:** Emitido pelo `SceneControl` (ou pelo próprio jogo ao ser instanciado) para notificar o `LocalControl` sobre qual jogo está ativo e fornecer configurações iniciais.
    *   **Parâmetros:**
        *   `game_id: String`: Um identificador único para o jogo (ex: "snake_game", "pacman").
        *   `config: Dictionary`: Um dicionário com configurações específicas do jogo (ex: `{"has_stage_data": false, "has_env_data": false, "max_score": 1000}`).

*   **`request_saving_game_data_requested()`**
    *   **Propósito:** Emitido pelo `SaveSystem` (ou outro sistema global) para solicitar que o `LocalControl` colete e prepare os dados do jogo ativo para salvamento.

*   **`request_local_data(data_type: String)`**
    *   **Propósito:** Emitido pelo `LocalControl` para solicitar dados específicos (ex: "player_data", "environment_data", "stage_data") de sistemas locais dentro da cena de jogo.
    *   **Parâmetros:**
        *   `data_type: String`: O tipo de dado solicitado.

*   **`local_data_received(data_type: String, data: Dictionary)`**
    *   **Propósito:** Emitido por um sistema local (Player, Environment, Stage, etc.) em resposta a `request_local_data`, fornecendo os dados solicitados ao `LocalControl`.
    *   **Parâmetros:**
        *   `data_type: String`: O tipo de dado que está sendo fornecido.
        *   `data: Dictionary`: O dicionário contendo os dados.

*   **`sending_game_data(game_data: Dictionary)`**
    *   **Propósito:** Emitido pelo `LocalControl` após coletar todos os dados necessários, enviando o dicionário completo de dados do jogo para o `SaveSystem`.
    *   **Parâmetros:**
        *   `game_data: Dictionary`: Um dicionário contendo todos os dados do jogo a serem salvos.
