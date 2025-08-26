@tool
extends EditorPlugin

const PLUGIN_NAME = "CafeAudioManager"
const AUTOLOAD_NAME = "CafeAudioManager"
const AUTOLOAD_PATH = "res://addons/CafeAudioManager/scenes/cafe_audio_manager.tscn"

func _enter_tree():
	# Add the CafeAudioManager as an Autoload (Singleton)
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)
	print("CafeAudioManager Plugin: Autoload '%s' added." % AUTOLOAD_NAME)

	# TODO: Add editor UI for manifest generation in Phase 2

func _exit_tree():
	# Remove the Autoload when the plugin is deactivated
	remove_autoload_singleton(AUTOLOAD_NAME)
	print("CafeAudioManager Plugin: Autoload '%s' removed." % AUTOLOAD_NAME)

	# TODO: Remove editor UI in Phase 2
