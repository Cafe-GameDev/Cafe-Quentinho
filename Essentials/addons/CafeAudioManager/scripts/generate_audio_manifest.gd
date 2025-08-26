@tool
extends EditorScript

const MANIFEST_SAVE_PATH = "res://addons/CafeAudioManager/resources/audio_manifest.tres"
# Define root paths for SFX and music assets within the plugin

@export var sfx_root_path: String = "res://addons/CafeAudioManager/assets/sfx/"
@export var music_root_path: String = "res://addons/CafeAudioManager/assets/music/"

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
			var resource_path = current_path.path_join(file_or_dir_name)
			var uid = ResourceLoader.get_resource_uid(resource_path)
			print("  - Debug: Resource Path: %s, Raw UID: %s" % [resource_path, str(uid)])
			if uid != -1: # ResourceLoader.get_resource_uid returns -1 if not found
				var root_path_to_remove = sfx_root_path if audio_type == "sfx" else music_root_path
				var relative_dir_path = current_path.replace(root_path_to_remove, "").trim_suffix("/")
				var final_key = ""

				if not relative_dir_path.is_empty():
					final_key = relative_dir_path.replace("/", "_").to_lower()
				else:
					# If at the root of sfx_root_path or music_root_path, use the filename as key
					final_key = file_or_dir_name.get_basename().to_lower()

				if not library.has(final_key):
					library[final_key] = []
				library[final_key].append("uid://%s" % str(uid))
				print("  - Added %s audio '%s' with UID: uid://%s" % [audio_type, final_key, str(uid)])
		file_or_dir_name = dir.get_next()

func _get_uid_from_import_file(import_file_path: String) -> String:
	# This function is no longer needed as we are using ResourceLoader.get_resource_uid
	return ""
