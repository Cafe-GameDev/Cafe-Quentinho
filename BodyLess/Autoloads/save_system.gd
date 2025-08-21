extends Node

const BASE_SAVE_DIR = "user://saves/"
const SAVE_FILE_EXTENSION = ".json"

# Define o número de slots de save por modo de jogo
const MAX_SAVE_SLOTS_PER_MODE = 3

func _ready() -> void:
	_connect_signals()
	# A criação dos diretórios específicos de modo será feita no momento do save.

func _connect_signals() -> void:
	GlobalEvents.request_save_game.connect(_on_request_save_game)
	GlobalEvents.request_load_game.connect(_on_request_load_game)

# ==============================================================================
# Funções de Orquestração de Save/Load
# ==============================================================================

func _on_request_save_game(session_id: int, game_mode: String) -> void:
	if session_id < 0 or session_id >= MAX_SAVE_SLOTS_PER_MODE:
		printerr("[SaveSystem] Tentativa de salvar em slot inválido: %d para modo %s" % [session_id, game_mode])
		GlobalEvents.show_toast_requested.emit("TOAST_ERROR_SAVE_FAILED_MESSAGE", "error")
		return

	var game_data: Dictionary = {}

	# Solicita dados de outros managers para compor o save
	# Os managers devem ouvir esses sinais e emitir seus dados via '..._received'
	GlobalEvents.request_player_data_for_save.emit()
	var player_data = await GlobalEvents.player_data_for_save_received
	game_data["player_data"] = player_data

	GlobalEvents.request_inventory_data_for_save.emit()
	var inventory_data = await GlobalEvents.inventory_data_for_save_received
	game_data["inventory_data"] = inventory_data

	GlobalEvents.request_global_machine_data_for_save.emit()
	var global_machine_data = await GlobalEvents.global_machine_data_for_save_received
	game_data["global_machine_data"] = global_machine_data

	GlobalEvents.request_world_data_for_save.emit()
	var world_data = await GlobalEvents.world_data_for_save_received
	game_data["world_data"] = world_data

	GlobalEvents.request_settings_data_for_save.emit()
	var settings_data = await GlobalEvents.settings_data_for_save_received
	game_data["settings_data"] = settings_data

	GlobalEvents.request_language_data_for_save.emit()
	var language_data = await GlobalEvents.language_data_for_save_received
	game_data["language_data"] = language_data

	GlobalEvents.request_input_map_data_for_save.emit()
	var input_map_data = await GlobalEvents.input_map_data_for_save_received
	game_data["input_map_data"] = input_map_data

	# Adicionar mais requisições de dados conforme necessário (ex: quests, NPCs, etc.)

	if _save_to_file(game_mode, session_id, game_data):
		print("[SaveSystem] Jogo salvo com sucesso no slot %d para o modo %s." % [session_id, game_mode])
		GlobalEvents.game_saved.emit(session_id)
		GlobalEvents.show_toast_requested.emit("TOAST_SETTINGS_SAVED_MESSAGE", "success") # Reutilizando a chave de settings
	else:
		printerr("[SaveSystem] Falha ao salvar o jogo no slot %d para o modo %s." % [session_id, game_mode])
		GlobalEvents.show_toast_requested.emit("TOAST_ERROR_SAVE_FAILED_MESSAGE", "error")


func _on_request_load_game(session_id: int, game_mode: String) -> void:
	if session_id < 0 or session_id >= MAX_SAVE_SLOTS_PER_MODE:
		printerr("[SaveSystem] Tentativa de carregar de slot inválido: %d para modo %s" % [session_id, game_mode])
		GlobalEvents.show_toast_requested.emit("TOAST_ERROR_SAVE_FAILED_MESSAGE", "error")
		return

	var loaded_data = _load_from_file(game_mode, session_id)

	if not loaded_data.is_empty():
		print("[SaveSystem] Jogo carregado com sucesso do slot %d para o modo %s." % [session_id, game_mode])
		GlobalEvents.game_loaded.emit(session_id, loaded_data)
		GlobalEvents.show_toast_requested.emit("TOAST_LOAD_SUCCESS_MESSAGE", "info") # Nova chave de tradução
	else:
		printerr("[SaveSystem] Falha ao carregar o jogo do slot %d para o modo %s. Arquivo não encontrado ou corrompido." % [session_id, game_mode])
		GlobalEvents.show_toast_requested.emit("TOAST_ERROR_LOAD_FAILED_MESSAGE", "error") # Nova chave de tradução

# ==============================================================================
# Funções de Acesso a Arquivos
# ==============================================================================

func _get_save_path(game_mode: String, session_id: int) -> String:
	var mode_dir = BASE_SAVE_DIR.path_join(game_mode.to_lower())
	if not DirAccess.dir_exists_absolute(mode_dir):
		DirAccess.make_dir_absolute(mode_dir)
	return mode_dir.path_join("save_slot_" + str(session_id) + SAVE_FILE_EXTENSION)

func _save_to_file(game_mode: String, session_id: int, data: Dictionary) -> bool:
	var path = _get_save_path(game_mode, session_id)
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(data, "  ")
		file.store_string(json_string)
		return true
	else:
		printerr("[SaveSystem] Falha ao abrir arquivo para escrita em %s" % path)
		return false

func _load_from_file(game_mode: String, session_id: int) -> Dictionary:
	var path = _get_save_path(game_mode, session_id)
	if not FileAccess.file_exists(path):
		return {} # Retorna dicionário vazio se o arquivo não existe

	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var parse_result = JSON.parse_string(json_string)
		if parse_result is Dictionary:
			return parse_result
		else:
			printerr("[SaveSystem] Falha ao parsear JSON ou dados não são um dicionário de %s" % path)
			return {} # Retorna vazio em erro de parse
	else:
		printerr("[SaveSystem] Falha ao abrir arquivo para leitura em %s" % path)

	return {}
