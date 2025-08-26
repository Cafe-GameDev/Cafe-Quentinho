extends EditorScript

const AUDIO_ROOT_PATH = "res://Assets/Audio/"
const MANIFEST_SAVE_PATH = "res://Resources/audio_manifest.tres"

func _run():
	print("Gerando AudioManifest...")

	var audio_manifest = AudioManifest.new()
	
	var root_dir = DirAccess.open(AUDIO_ROOT_PATH)
	if not root_dir:
		printerr("GenerateAudioManifest: Falha ao abrir o diretório raiz de áudio: %s" % AUDIO_ROOT_PATH)
		return

	root_dir.list_dir_begin()
	var category_folder = root_dir.get_next()
	while category_folder != "":
		if root_dir.current_is_dir():
			var current_path = AUDIO_ROOT_PATH.path_join(category_folder)
			
			var library_to_populate: Dictionary
			var key_prefix = category_folder.to_lower()

			if key_prefix == "music":
				library_to_populate = audio_manifest.music_data
			else:
				library_to_populate = audio_manifest.sfx_data

			_populate_library_from_editor(current_path, library_to_populate, key_prefix)

		category_folder = root_dir.get_next()
		
	ResourceSaver.save(audio_manifest, MANIFEST_SAVE_PATH)
	print("AudioManifest gerado e salvo em: %s" % MANIFEST_SAVE_PATH)

func _populate_library_from_editor(path: String, library: Dictionary, key_prefix: String):
	var dir = DirAccess.open(path)
	if not dir:
		printerr("GenerateAudioManifest: Falha ao abrir o caminho: %s" % path)
		return

	dir.list_dir_begin()
	var sub_folder = dir.get_next()
	while sub_folder != "":
		if dir.current_is_dir():
			var sub_path = path.path_join(sub_folder)
			var final_key = (key_prefix + "_" + sub_folder.to_lower()) if not key_prefix.is_empty() else sub_folder.to_lower()
			
			var audio_uids: Array[String] = _get_audio_uids_in_folder(sub_path)
			if not audio_uids.is_empty():
				library[final_key] = audio_uids
				print("  - Categoria '%s' processada com %d UIDs de áudio." % [final_key, audio_uids.size()])
			
			_populate_library_from_editor(sub_path, library, key_prefix) # Recursivo para subpastas
		else:
			# Processa arquivos .import diretamente na pasta atual
			if sub_folder.ends_with(".import"):
				var original_file_name = sub_folder.replace(".import", "")
				var original_path = path.path_join(original_file_name)
				
				var uid = _get_uid_from_import_file(path.path_join(sub_folder))
				if not uid.is_empty():
					var final_key = (key_prefix + "_" + original_file_name.get_basename().to_lower()) if not key_prefix.is_empty() else original_file_name.get_basename().to_lower()
					if not library.has(final_key):
						library[final_key] = []
					library[final_key].append(uid)
					print("  - Arquivo de áudio '%s' adicionado com UID: %s" % [original_file_name, uid])
		sub_folder = dir.get_next()

func _get_audio_uids_in_folder(path: String) -> Array[String]:
	var uids: Array[String] = []
	var dir = DirAccess.open(path)
	if not dir:
		return uids

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".import"):
			var uid = _get_uid_from_import_file(path.path_join(file_name))
			if not uid.is_empty():
				uids.append(uid)
		file_name = dir.get_next()
	
	return uids

func _get_uid_from_import_file(import_file_path: String) -> String:
	var uid = ""
	var file = FileAccess.open(import_file_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		
		var uid_start = content.find("uid=\"uid://")
		if uid_start != -1:
			uid_start += len("uid=\"uid://")
			var uid_end = content.find("\"", uid_start)
			if uid_end != -1:
				uid = content.substr(uid_start, uid_end - uid_start)
				uid = "uid://" + uid # Adiciona o prefixo uid://
			else:
				printerr("GenerateAudioManifest: UID mal formatado no arquivo .import: %s" % import_file_path)
		else:
			printerr("GenerateAudioManifest: UID não encontrado no arquivo .import: %s" % import_file_path)
	else:
		printerr("GenerateAudioManifest: Falha ao abrir arquivo .import: %s" % import_file_path)
	return uid
