extends Node

# O SceneControl é o maestro da UI e das cenas.
# Ele ouve as mudanças de estado da GlobalMachine e atualiza a cena visível.
# Ele também gerencia o carregamento e descarregamento de cenas de jogo.

@onready var main_menu: Control = $CanvasLayer/MainMenu
@onready var options_menu: Control = $CanvasLayer/OptionsMenu
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var quit_dialog: PanelContainer = $CanvasLayer/QuitConfirmationDialog
@onready var game_viewport: SubViewport = $GameViewportContainer/GameViewport

var _current_game_scene: Node = null

func _ready() -> void:
	# Conecta-se ao sinal de mudança de estado para poder reagir.
	GlobalEvents.game_state_changed.connect(_on_game_state_changed)
	# Conecta-se a sinais de gerenciamento de cena.
	GlobalEvents.scene_changed.connect(_on_scene_changed)
	
	# Garante que o estado inicial da UI esteja correto.
	_on_game_state_changed(GlobalMachine.current_state, -1)


# A função central que controla qual UI está visível.
func _on_game_state_changed(new_state: GlobalMachine.State, _old_state: int) -> void:
	# Esconde todas as UIs de sobreposição por padrão.
	options_menu.visible = false
	pause_menu.visible = false
	quit_dialog.visible = false
	
	# Mostra a UI correta com base no novo estado.
	match new_state:
		GlobalMachine.State.MENU:
			main_menu.visible = true
		GlobalMachine.State.PLAYING:
			main_menu.visible = false
		GlobalMachine.State.PAUSED:
			pause_menu.visible = true
		GlobalMachine.State.SETTINGS:
			options_menu.visible = true
		GlobalMachine.State.QUIT_CONFIRMATION:
			quit_dialog.visible = true


# Gerencia a troca de cenas de "nível" ou "mundo".
func _on_scene_changed(scene_path: String) -> void:
	# Se já houver uma cena de jogo, remove-a.
	if _current_game_scene:
		_current_game_scene.queue_free()
		_current_game_scene = null

	# Se o caminho for vazio, estamos apenas voltando para o menu.
	if scene_path.is_empty():
		return

	# Carrega e instancia a nova cena como filha do viewport.
	var scene_resource = load(scene_path)
	if scene_resource:
		_current_game_scene = scene_resource.instantiate()
		game_viewport.add_child(_current_game_scene)
	else:
		printerr("SceneControl: Falha ao carregar a cena em: %s" % scene_path)
