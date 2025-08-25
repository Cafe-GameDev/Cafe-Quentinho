extends Node

# Utilitário para tocar sons de UI comuns.
# Este script não precisa ser instanciado em nenhuma cena.
# Suas funções estáticas podem ser chamadas de qualquer outro script.

# Toca o som de hover (passar o mouse sobre um botão).
static func play_hover_sound() -> void:
	# A chave "interface_select" corresponde à estrutura de pastas em Assets/Audio/
	# Ex: res://Assets/Audio/interface/select/sound.ogg
	GlobalEvents.emit_signal("play_sfx_by_key_requested", "interface_select")


# Toca o som de clique/confirmação.
static func play_click_sound() -> void:
	# A chave "interface_confirmation" corresponde à estrutura de pastas em Assets/Audio/
	# Ex: res://Assets/Audio/interface/confirmation/sound.ogg
	GlobalEvents.emit_signal("play_sfx_by_key_requested", "interface_confirmation")
