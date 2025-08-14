# Multithreading

Em Godot, o **multithreading** é uma ferramenta poderosa para melhorar a performance do seu jogo, permitindo que tarefas pesadas sejam executadas em segundo plano sem travar o thread principal (onde a lógica do jogo e a renderização acontecem).

### Conceito Fundamental

O multithreading permite que seu programa execute várias partes do código "simultaneamente" (ou de forma concorrente) em diferentes threads de execução. Isso é útil para:

*   **Evitar travamentos:** Mover cálculos complexos, carregamento de assets, geração procedural ou operações de rede para um thread separado impede que o jogo congele.
*   **Melhorar a responsividade:** A interface do usuário e a lógica principal do jogo permanecem fluidas enquanto tarefas demoradas são processadas em segundo plano.

### Implementação em Godot

A Godot fornece a classe `Thread` para gerenciar threads.

1.  **Criação e Início de um Thread:**
    Você cria uma nova instância de `Thread` e usa o método `start()` para iniciar a execução de uma função em um novo thread.

    ```gdscript
    var my_thread = Thread.new()
    my_thread.start(self, "my_heavy_task", my_data) # self é o objeto, "my_heavy_task" é o método, my_data são os argumentos
    ```

2.  **A Função a Ser Executada:**
    A função que você passa para `start()` será executada no novo thread. Ela deve ser projetada para ser independente do thread principal e não deve tentar acessar nós da árvore de cena diretamente, pois isso pode levar a problemas de thread safety.

    ```gdscript
    func my_heavy_task(data):
        # Simula uma tarefa pesada
        var result = 0
        for i in range(10000000):
            result += i
        print("Tarefa pesada concluída com resultado: ", result)
        # Quando a tarefa termina, você pode emitir um sinal para o thread principal
        call_deferred("emit_signal", "task_completed", result)
    ```

3.  **Comunicação entre Threads:**
    A comunicação segura entre threads é crucial. A maneira mais comum e segura é usar **sinais**.
    *   O thread de trabalho (o que você criou) emite um sinal quando termina sua tarefa ou precisa enviar dados de volta.
    *   O thread principal se conecta a esse sinal e processa os dados recebidos.
    *   Use `call_deferred()` ao emitir sinais ou chamar métodos que afetam a árvore de cena a partir de um thread secundário. Isso garante que a chamada seja enfileirada e executada no thread principal no momento seguro.

    ```gdscript
    # No script principal (onde você iniciou o thread)
    signal task_completed(result)

    func _ready():
        connect("task_completed", Callable(self, "_on_task_completed"))

    func _on_task_completed(result):
        print("Recebido resultado da tarefa pesada no thread principal: ", result)

    ```

4.  **Esperando um Thread Terminar (`wait_to_finish()`):**
    Você pode usar `wait_to_finish()` para bloquear o thread atual até que o thread de trabalho termine. **Use com extrema cautela**, pois isso pode causar travamentos se o thread principal esperar por uma tarefa muito longa. Geralmente, é melhor usar sinais para comunicação assíncrona.

    ```gdscript
    # Não recomendado para o thread principal em tempo real
    var result = my_thread.wait_to_finish()
    ```

### Casos de Uso Comuns

*   **Carregamento de Assets:** Carregar grandes texturas, modelos ou cenas em segundo plano.
*   **Geração Procedural:** Gerar terrenos, níveis ou dados complexos sem interromper o jogo.
*   **Cálculos Complexos:** Algoritmos de IA, simulações físicas não críticas ou processamento de dados.
*   **Operações de Rede:** Enviar e receber dados de um servidor, especialmente em jogos multiplayer.

### Considerações Importantes e Advertências

*   **Thread Safety:** A Godot não é totalmente thread-safe por padrão. Acessar nós da árvore de cena, recursos ou outras APIs da Godot que não são explicitamente marcadas como thread-safe a partir de um thread secundário pode levar a *crashes* ou comportamentos imprevisíveis. **Sempre use `call_deferred()` ou sinais para interagir com o thread principal.**
*   **Sincronização de Dados:** Se vários threads precisam acessar ou modificar os mesmos dados, você precisará de mecanismos de sincronização (como `Mutex` ou `Semaphore`, embora a Godot não os exponha diretamente para GDScript de forma simples, o uso de `call_deferred` para comunicação já ajuda a evitar muitos problemas).
*   **Overhead:** Criar e gerenciar threads tem um custo. Não use threads para tarefas muito pequenas ou frequentes, pois o overhead pode ser maior do que o ganho de performance.
*   **Depuração:** Depurar código multithreaded pode ser complexo devido à natureza não determinística da execução.

### GDExtension e Outras Linguagens

Para tarefas que exigem o máximo de performance e controle sobre threads, você pode usar **GDExtension**. Linguagens como C++, Rust ou até mesmo Python (para IA avançada) podem ser usadas para implementar lógica multithreaded de forma mais eficiente e com maior controle sobre a sincronização, expondo os resultados de volta para o GDScript através de sinais ou métodos seguros.

Em resumo, o multithreading em Godot é uma ferramenta valiosa para otimização, mas exige um entendimento cuidadoso de como os threads interagem e das limitações de thread safety da engine. Priorize o uso de sinais e `call_deferred()` para comunicação segura entre threads.
