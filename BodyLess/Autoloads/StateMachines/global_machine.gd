extends Node

# Enum para definir todos os estados possíveis da máquina de estados global.
# Isso centraliza a lógica de fluxo do jogo, determinando o que pode acontecer em cada momento.
enum State {
	MENU, # O jogador está no menu principal.
	SETTINGS, # O jogador está no menu de opções.
	LOADING, # O jogo está carregando uma cena/nível.
	PLAYING, # O jogador está ativamente no jogo.
	PLAYING_SAVING, # O jogo está salvando em segundo plano (autosave), mas a jogabilidade continua.
	PAUSED, # O jogo está pausado e o menu de pause está visível.
	QUIT_CONFIRMATION, # A caixa de diálogo "Deseja sair?" está na tela.
	SAVING_QUIT # O jogo está salvando os dados antes de fechar.
}

# A variável que armazena o estado atual do jogo.
var current_state: State = State.MENU