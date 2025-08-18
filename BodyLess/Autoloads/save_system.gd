extends Node

# SaveSystem: Único responsável por interagir com o sistema de arquivos.
# - Ouve sinais para salvar dados (dicionários) em arquivos.
# - Ouve sinais para carregar dados de arquivos e emitir para outros sistemas.

const SETTINGS_PATH = "user://settings.json"

func _ready() -> void:
	# Conecta-se aos sinais que solicitam operações de arquivo.
	GlobalEvents.save_settings_to_disk.connect(_on_save_settings_to_disk)
	GlobalEvents.load_settings_requested.connect(_on_load_settings_requested)


func _on_save_settings_to_disk(settings_data: Dictionary) -> void:
	print("SaveSystem: Received request to save settings.")
	var error = _save_dictionary_to_json(SETTINGS_PATH, settings_data)
	if error == OK:
		print("SaveSystem: Settings saved successfully to %s" % SETTINGS_PATH)
	else:
		printerr("SaveSystem: Failed to save settings. Error code: %s" % error)


func _on_load_settings_requested() -> void:
	print("SaveSystem: Received request to load settings.")
	var loaded_data = _load_dictionary_from_json(SETTINGS_PATH)
	# Emite os dados carregados (ou um dicionário vazio se falhar) para quem pediu.
	GlobalEvents.emit_signal("settings_loaded", loaded_data)
	if loaded_data.is_empty():
		print("SaveSystem: No settings file found at %s or file is empty." % SETTINGS_PATH)
	else:
		print("SaveSystem: Settings loaded and emitted.")


# --- Funções Utilitárias de Arquivo ---

func _save_dictionary_to_json(path: String, data: Dictionary) -> Error:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return FileAccess.get_open_error()
	
	# Converte o dicionário para uma string JSON formatada (pretty print).
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	return OK


func _load_dictionary_from_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		printerr("SaveSystem: Failed to open file for reading at %s. Error: %s" % [path, FileAccess.get_open_error()])
		return {}

	var content = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		printerr("SaveSystem: Failed to parse JSON from %s. Error: %s" % [path, json.get_error_message()])
		return {}

	if not json.data is Dictionary:
		printerr("SaveSystem: Parsed JSON data is not a Dictionary.")
		return {}

	return json.data
