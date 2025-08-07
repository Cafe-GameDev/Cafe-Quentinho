# Curso de Godot 2D: Do Zero ao Profissional (Open Source)

Bem-vindo ao repositório oficial do curso **"Godot 2D: Do Zero ao Profissional"**! Este projeto é uma iniciativa **Open Source** e um curso completo, baseado em texto, que te guiará desde os primeiros passos na Godot Engine até a criação de jogos complexos com arquitetura profissional.

## 📚 O Curso em Formato de Repositório

Diferente de um curso em vídeo, este repositório **é o próprio curso**. Todo o material didático está organizado em formato de texto (Markdown), permitindo que você aprenda no seu próprio ritmo, como se estivesse lendo um livro interativo.

**Objetivos Principais:**
*   Dominar a Godot Engine para desenvolvimento 2D.
*   Aprender a projetar e implementar arquiteturas de jogo robustas e escaláveis.
*   Desenvolver projetos práticos e completos, passo a passo.
*   Adquirir uma mentalidade de engenharia de software aplicada a jogos.

## 🚀 Café Gemini: Seu Copiloto Especialista em Godot

Uma característica única deste projeto é o **Café Gemini**, um assistente de IA que transforma o Gemini em um copiloto especializado para a Godot Engine.

Embora tenha sido treinado com todo o conteúdo e arquitetura deste curso, o Café Gemini é uma ferramenta poderosa para **qualquer desenvolvedor Godot**. Ele tem acesso direto ao seu ambiente de desenvolvimento (código-fonte, cenas, nós, etc.), permitindo que você tire dúvidas, gere código e refatore sistemas de forma contextual e inteligente.

Ele não é um assistente genérico; é o seu especialista particular em Godot.

### Instalação (Método Oficial)

A instalação é feita através do NPM (Node Package Manager).

> **Pré-requisito:** Você precisa ter o [Node.js](https://nodejs.org/downloads/) (que inclui o `npm`) instalado no seu sistema.

Com o Node.js pronto, abra seu terminal e execute o comando:
```bash
npm install -g @cafe-gamedev/gemini
```

**Após a instalação, reinicie seu terminal** para que os novos comandos sejam reconhecidos.

### Comandos Disponíveis

Após a instalação, os seguintes comandos estarão disponíveis em qualquer diretório do seu sistema:

*   `cafe-gemini`
    *   Inicia uma conversa com o assistente especializado.
*   `cafe-gemini-update`
    *   Atualiza o assistente para a versão mais recente, baixando os manuais e templates mais atuais.

## 🗺️ Trilha de Aprendizagem: Como Navegar no Curso

A estrutura de pastas foi desenhada para ser uma trilha de aprendizagem clara e sequencial. **Comece pelo módulo `00` e siga a ordem numérica.**

## ⚙️ Configuração do Ambiente (VS Code)

Para a melhor experiência de desenvolvimento, este repositório já vem pré-configurado para o Visual Studio Code.

Ao abrir o projeto pela primeira vez, siga estes passos:

1.  **Instale as Extensões Recomendadas:** O VS Code irá notificá-lo sobre uma lista de extensões recomendadas para este workspace. Clique em **"Instalar"** para configurar automaticamente o ambiente com ferramentas para Godot (GDScript), Markdown e mais.
2.  **Configure o Caminho do Godot:** A integração com o motor Godot requer uma configuração manual:
    *   Abra o arquivo: `.vscode/settings.json`.
    *   Encontre a linha que diz `"godot_tools.editor_path"`.
    *   Substitua o valor `"INSIRA_AQUI_O_CAMINHO_PARA_O_SEU_EXECUTAVEL_DO_GODOT"` pelo caminho absoluto para o executável do Godot no seu computador.

Feito isso, seu ambiente estará pronto!

## 🧪 Filosofia de Testes com GUT (Godot Unit Test)

A qualidade e a estabilidade são pilares fundamentais deste projeto. Para garantir um desenvolvimento robusto e sustentável, adotamos o **GUT (Godot Unit Test)** como o framework de testes automatizados padrão.

**Por que testar?**
*   **Confiança para Refatorar:** Altere e melhore o código com a segurança de que os testes verificarão se as funcionalidades existentes continuam operando como esperado.
*   **Detecção Rápida de Bugs:** Encontre problemas no momento em que são introduzidos, economizando horas de depuração futura.
*   **Documentação Viva:** Os testes servem como um exemplo prático de como o código deve ser utilizado.

**Diretriz Oficial:**
> Toda nova funcionalidade, sistema ou correção de bug crítico deve, sempre que possível, ser acompanhado por testes unitários correspondentes no GUT.

Esta prática é essencial para a saúde do projeto a longo prazo e um requisito para contribuições que envolvam lógica de jogo.

## 🤝 Contribuições

Este é um projeto Open Source! Contribuições são muito bem-vindas. Se você encontrar erros, tiver sugestões de melhoria, ou quiser adicionar conteúdo, por favor:

1.  Faça um `fork` do repositório.
2.  Crie uma `branch` para sua feature (`git checkout -b feature/minha-contribuicao`).
3.  Faça suas alterações e `commit` (`git commit -m 'feat: adiciona nova funcionalidade'`).
4.  Envie para sua `branch` (`git push origin feature/minha-contribuicao`).
5.  Abra um `Pull Request` detalhando suas mudanças.

## 📄 Licença

Este projeto está licenciado sob a Licença APACHE 2.0. Veja o arquivo `LICENSE` para mais detalhes.
