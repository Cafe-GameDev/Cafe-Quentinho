@tool
extends EditorScript

const MANIFEST_SAVE_PATH = "res://addons/Cafe-AudioManager/resources/audio_manifest.tres"

@export var sfx_root_path: String = "res://addons/Cafe-AudioManager/assets/sfx/"
@export var music_root_path: String = "res://addons/Cafe-AudioManager/assets/music/"
# Define root paths for SFX and music assets within the plugin

func _run():
	print("Generating AudioManifest...")
	
	var audio_manifest = AudioManifest.new()
	
	_scan_and_populate_library(sfx_root_path, audio_manifest.sfx_data, "sfx")
	_scan_and_populate_library(music_root_path, audio_manifest.music_data, "music")
	
	ResourceSaver.save(audio_manifest, MANIFEST_SAVE_PATH)
	print("AudioManifest generated and saved to: %s" % MANIFEST_SAVE_PATH)

func _scan_and_populate_library(current_path: String, library: Dictionary, audio_type: String):
	var dir = DirAccess.open(current_path)
	if not dir:
		printerr("GenerateAudioManifest: Failed to open directory: %s" % current_path)
		return
	
	dir.list_dir_begin()
	var file_or_dir_name = dir.get_next()
	while file_or_dir_name != "":
		if dir.current_is_dir():
			# Recursively scan subdirectories
			_scan_and_populate_library(current_path.path_join(file_or_dir_name), library, audio_type)
		elif file_or_dir_name.ends_with(".ogg") or file_or_dir_name.ends_with(".wav"): # Add other audio formats if needed
			var import_file_path = current_path.path_join(file_or_dir_name + ".import")
			var uid = _get_uid_from_import_file(import_file_path)
			
			if not uid.is_empty():
				# Derive key from relative path, e.g., "res://addons/Cafe-AudioManager/assets/sfx/interface/click/click_001.ogg"
				# becomes "interface_click"
				var relative_path_parts = current_path.split("/")
				var category_name = ""
				var subcategory_name = ""
	
				# Assuming structure like: res://addons/Cafe-AudioManager/assets/sfx/category/subcategory/file.ogg
				# We want to extract 'category_subcategory' or just 'category' if no subcategory
				# Find the index of 'assets/sfx' or 'assets/music'
				var assets_path_index = -1
				for i in range(relative_path_parts.size()):
					if relative_path_parts[i] == "assets":
						assets_path_index = i
						break
				
				if assets_path_index != -1 and relative_path_parts.size() > assets_path_index + 2:
					category_name = relative_path_parts[assets_path_index + 2]
					if relative_path_parts.size() > assets_path_index + 3:
						subcategory_name = relative_path_parts[assets_path_index + 3]
					
					var final_key = ""
					if not subcategory_name.is_empty():
						final_key = category_name.to_lower() + "_" + subcategory_name.to_lower()
					elif not category_name.is_empty():
						final_key = category_name.to_lower()
					else:
						final_key = file_or_dir_name.get_basename().to_lower() # Fallback to filename if no category/subcategory
					
					if not library.has(final_key):
						library[final_key] = []
					library[final_key].append(uid)
					print("  - Added %s audio '%s' with UID: %s" % [audio_type, final_key, uid])
				else:
					printerr("GenerateAudioManifest: Could not derive a meaningful key for %s" % import_file_path)
		file_or_dir_name = dir.get_next()

func _get_uid_from_import_file(import_file_path: String) -> String:
	var uid = ""
	var file = FileAccess.open(import_file_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		
		var uid_key_start = content.find("uid=")
		if uid_key_start != -1:
			var uid_value_start = uid_key_start + len("uid=")
			var uid_value_end = content.find("\"", uid_value_start)
			if uid_value_end != -1:
				uid = content.substr(uid_value_start, uid_value_end - uid_value_start)
			else:
				printerr("GenerateAudioManifest: Malformed UID in import file (missing closing quote): %s" % import_file_path)
		else:
			printerr("GenerateAudioManifest: UID key 'uid=\' not found in import file: %s" % import_file_path)
	else:
		printerr("GenerateAudioManifest: Failed to open import file: %s" % import_file_path)
	return uid
