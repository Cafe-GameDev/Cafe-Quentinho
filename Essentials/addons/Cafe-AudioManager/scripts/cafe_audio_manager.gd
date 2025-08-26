@tool
extends Node

# CafeAudioManager: Manages audio (music and SFX) for UI/UX/Interfaces and background music.
# This AudioManager acts as its own EventBus for audio-related signals.
# It loads audio resources based on a generated AudioManifest, ensuring compatibility
# with exported builds.

# Limitations: This AudioManager is designed exclusively for mono audio,
# without support for 2D or 3D positional audio effects.

signal play_sfx_requested(sfx_key: String, bus: String)
signal play_music_requested(music_key: String)
signal music_track_changed(music_key: String)
signal volume_changed(bus_name: String, linear_volume: float)

const SFX_BUS_NAME = "SFX"
const MUSIC_BUS_NAME = "Music"

@export var audio_manifest: AudioManifest
@export var sfx_root_path: String = "res://addons/Cafe-AudioManager/assets/sfx/"
@export var music_root_path: String = "res://addons/Cafe-AudioManager/assets/music/"

var _sfx_library: Dictionary = {}
var _music_library: Dictionary = {}

var _music_playlist_keys: Array = []
var _current_playlist_key: String = ""

@export var _sfx_player_count = 15
var _sfx_players: Array[AudioStreamPlayer] = []
@onready var _music_player: AudioStreamPlayer = $MusicPlayer
@onready var _music_change_timer: Timer = $MusicChangeTimer

func _ready():
	_setup_audio_buses()
	_music_player.bus = MUSIC_BUS_NAME
	_music_player.finished.connect(_on_music_finished)

	# Connect to self signals
	play_sfx_requested.connect(_on_play_sfx_requested)
	play_music_requested.connect(_on_play_music_requested)
	
	_load_audio_from_manifest()
	_select_and_play_random_playlist()
	_music_change_timer.start()

func _setup_audio_buses():
	# Ensure Music and SFX buses exist and are configured
	if AudioServer.get_bus_index(MUSIC_BUS_NAME) == -1:
		AudioServer.add_bus(AudioServer.get_bus_count())
		var music_bus_idx = AudioServer.get_bus_count() - 1 # Get the index of the newly added bus
		AudioServer.set_bus_name(music_bus_idx, MUSIC_BUS_NAME)
		AudioServer.set_bus_send(music_bus_idx, "Master")
		print("CafeAudioManager: Created Music audio bus.")
	
	if AudioServer.get_bus_index(SFX_BUS_NAME) == -1:
		AudioServer.add_bus(AudioServer.get_bus_count())
		var sfx_bus_idx = AudioServer.get_bus_count() - 1 # Get the index of the newly added bus
		AudioServer.set_bus_name(sfx_bus_idx, SFX_BUS_NAME)
		AudioServer.set_bus_send(sfx_bus_idx, "Master")
		print("CafeAudioManager: Created SFX audio bus.")

func _load_audio_from_manifest():
	if not audio_manifest:
		printerr("CafeAudioManager: AudioManifest not assigned. Please generate it in the editor.")
		return

	_sfx_library = audio_manifest.sfx_data
	_music_library = audio_manifest.music_data
	_music_playlist_keys = _music_library.keys()
	
	print("CafeAudioManager: Loaded audio from manifest. %d music playlists and %d SFX categories found." % [_music_playlist_keys.size(), _sfx_library.size()])

	# Collect SFX players from the scene
	var sfx_player_node = get_node_or_null("SFXPlayer")
	if sfx_player_node:
		for child in sfx_player_node.get_children():
			if child is AudioStreamPlayer:
				child.bus = SFX_BUS_NAME
				child.finished.connect(Callable(self, "_on_sfx_player_finished").bind(child))
				_sfx_players.append(child)
	else:
		printerr("CafeAudioManager: SFXPlayer Node not found in scene. Please add a Node named 'SFXPlayer' with AudioStreamPlayer children.")

# --- Public Playback Functions (via signals) ---

func _on_play_sfx_requested(sfx_key: String, bus: String = SFX_BUS_NAME):
	if not _sfx_library.has(sfx_key):
		printerr("CafeAudioManager: SFX key not found in library: '%s'" % sfx_key)
		return

	var sfx_uids = _sfx_library[sfx_key]
	if sfx_uids.is_empty():
		printerr("CafeAudioManager: SFX category '%s' is empty." % sfx_key)
		return
	
	var random_uid = sfx_uids.pick_random()
	var sound_stream = load(random_uid)

	for player in _sfx_players:
		if not player.playing:
			player.stream = sound_stream
			player.bus = bus
			player.play()
			return

func _on_play_music_requested(music_key: String):
	if not _music_library.has(music_key):
		printerr("CafeAudioManager: Music key not found in library: '%s'" % music_key)
		return

	var music_uids = _music_library[music_key]
	if music_uids.is_empty():
		printerr("CafeAudioManager: Music category '%s' is empty." % music_key)
		return

	var random_uid = music_uids.pick_random()
	var music_stream = load(random_uid)

	if _music_player.stream == music_stream and _music_player.playing:
		return

	_music_player.stream = music_stream
	_music_player.play()
	music_track_changed.emit(music_stream.resource_path.get_file())

func stop_music():
	_music_player.stop()

# --- Playlist Logic ---

func _select_and_play_random_playlist():
	if _music_playlist_keys.is_empty():
		printerr("CafeAudioManager: No music playlists found to play.")
		return

	_current_playlist_key = _music_playlist_keys.pick_random()
	play_music_requested.emit(_current_playlist_key)

# --- Volume Control ---

func apply_volume_to_bus(bus_name: String, linear_volume: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		var db_volume = linear_to_db(linear_volume) if linear_volume > 0 else -80.0
		AudioServer.set_bus_volume_db(bus_index, db_volume)
		volume_changed.emit(bus_name, linear_volume)
	else:
		printerr("CafeAudioManager: Audio bus '%s' not found." % bus_name)

# --- Signal Handlers ---

func _on_music_finished():
	_select_and_play_random_playlist()

func _on_music_change_timer_timeout():
	_select_and_play_random_playlist()

func _on_sfx_player_finished(player: AudioStreamPlayer):
	player.stream = null # Clear stream after playing to free up memory and allow reuse
