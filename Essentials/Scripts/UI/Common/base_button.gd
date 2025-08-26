@tool
extends Button

# Este script é um componente reutilizável para todos os botões da UI.
# Ele adiciona automaticamente feedback sonoro para hover e clique.

func _ready() -> void:
	# Conecta os sinais nativos do nó Button às nossas funções de som.
	# Isso é feito por código para não precisar conectar manualmente cada botão no editor.
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)


func _on_mouse_entered() -> void:
	# Emite um sinal global solicitando a reprodução de um som de hover.
	# A chave "ui_hover" corresponde à estrutura de pastas em Assets/Audio/ui/hover
	GlobalEvents.emit_signal("play_sfx_by_key_requested", "ui_hover")


func _on_pressed() -> void:
	# Emite um sinal global solicitando a reprodução de um som de clique.
	# A chave "ui_click" corresponde à estrutura de pastas em Assets/Audio/ui/click
	CafeAudioManager.play_sfx_requested.emit("ui_click", "SFX")
