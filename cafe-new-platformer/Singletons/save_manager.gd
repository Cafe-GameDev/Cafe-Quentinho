extends Node

# Lida com o salvamento e carregamento do progresso do jogo.

const SAVE_PATH = "user://savegame.dat"

func save_game(data: Dictionary) -> void:
	var config = ConfigFile.new()
	for key in data:
		config.set_value("save", key, data[key])
	
	var err = config.save(SAVE_PATH)
	if err != OK:
		printerr("Erro ao salvar o jogo!")

func load_game() -> Dictionary:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	if err != OK:
		print("Nenhum jogo salvo encontrado.")
		return {}
	
	var data: Dictionary = {}
	var keys = config.get_section_keys("save")
	for key in keys:
		data[key] = config.get_value("save", key)
		
	return data