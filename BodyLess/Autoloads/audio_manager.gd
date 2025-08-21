extends Node

# AudioManager: Gerencia o carregamento e a reprodução de música e efeitos sonoros (SFX).
# Este singleton carrega arquivos de áudio de diretórios específicos,
# os categoriza em bibliotecas separadas e fornece sistemas para reprodução.

const SFX_BUS_NAME = "SFX"
const MUSIC_BUS_NAME = "Music"
const MASTER_BUS_NAME = "Master"

# --- Bibliotecas de Som ---
var _sfx_library: Dictionary = {}
var _music_library: Dictionary = {}

# --- Variáveis de Playlist ---
var _music_playlist_keys: Array = []
var _current_playlist_key: String = ""

# --- Componentes de Player ---
@export var _sfx_player_count = 15
var _sfx_players: Array[AudioStreamPlayer] = []
@onready var _music_player: AudioStreamPlayer = $MusicPlayer
@onready var music_change_timer: Timer = $MusicChangeTimer

func _ready():
	# Configura o bus do player de música e conecta seu sinal de término.
	_music_player.bus = MUSIC_BUS_NAME
	_music_player.finished.connect(_on_music_finished)

	# Conecta-se a sinais globais para reprodução e controle.
	GlobalEvents.play_sfx_by_key_requested.connect(play_random_sfx)
	GlobalEvents.music_change_requested.connect(_on_music_change_requested)
	
	# Conecta-se ao novo sinal unificado de configurações
	GlobalEvents.setting_changed.connect(func(change_data: Dictionary): _on_settings_changed(change_data))
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	# Solicita o carregamento inicial das configurações quando o AudioManager estiver pronto
	GlobalEvents.request_loading_settings_changed.emit()

	# Cria um pool de AudioStreamPlayers para SFX.
	for i: int in range(_sfx_player_count):
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.name = "SFXPlayer_" + str(i)
		add_child(player)
		_sfx_players.append(player)

	# Carrega todas as bibliotecas de som.
	_load_all_sounds()
	
	# Seleciona e toca uma playlist aleatória.
	_select_and_play_random_playlist()

	# Inicia o timer para trocar de playlist periodicamente.
	$MusicChangeTimer.start()


# --- Lógica de Carregamento ---

func _load_all_sounds() -> void:
	print("Iniciando carregamento das bibliotecas de áudio...")
	_music_library.clear()
	_sfx_library.clear()

	var audio_root_path: String = "res://Assets/Audio/"
	var root_dir: DirAccess = DirAccess.open(audio_root_path)
	if not root_dir:
		printerr("AudioManager: Falha ao abrir o diretório raiz de áudio: %s" % audio_root_path)
		return

	root_dir.list_dir_begin()
	var category_folder: String = root_dir.get_next()
	while category_folder != "":
		if root_dir.current_is_dir():
			var current_path: String = audio_root_path.path_join(category_folder)
			
			# Separa os áudios: a pasta "music" vai para a biblioteca de música, o resto para SFX.
			if category_folder.to_lower() == "music":
				_populate_library_from(current_path, _music_library)
			else:
				_populate_library_from(current_path, _sfx_library, category_folder.to_lower())

		category_folder = root_dir.get_next()
	
	# Após carregar, popula a lista de chaves de playlists.
	_music_playlist_keys = _music_library.keys()
	print("Carregamento de áudio concluído. %d playlists de música encontradas." % _music_playlist_keys.size())


func _populate_library_from(path: String, library: Dictionary, key_prefix: String = "") -> void:
	var dir: DirAccess = DirAccess.open(path)
	if not dir:
		printerr("AudioManager: Falha ao abrir o caminho: %s" % path)
		return

	dir.list_dir_begin()
	var sub_folder: String = dir.get_next()
	while sub_folder != "":
		if dir.current_is_dir():
			var sub_path: String = path.path_join(sub_folder)
			var final_key: String = (key_prefix + "_" + sub_folder.to_lower()) if not key_prefix.is_empty() else sub_folder.to_lower()
			
			var audio_streams: Array[AudioStream] = _get_streams_in_folder(sub_path)
			if not audio_streams.is_empty():
				library[final_key] = audio_streams
				print("  - Categoria '%s' carregada com %d sons." % [final_key, audio_streams.size()])

		sub_folder = dir.get_next()


func _get_streams_in_folder(path: String) -> Array[AudioStream]:
	var streams: Array[AudioStream] = []
	var dir: DirAccess = DirAccess.open(path)
	if not dir:
		return streams

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and not file_name.ends_with(".import"):
			var stream: AudioStream = load(path.path_join(file_name))
			if stream is AudioStream:
				streams.append(stream)
		file_name = dir.get_next()
	
	return streams


# --- Funções Públicas de Reprodução ---

func play_random_sfx(sfx_key: String, bus: String = SFX_BUS_NAME) -> void:
	if not _sfx_library.has(sfx_key):
		printerr("AudioManager: Chave de SFX não encontrada na biblioteca: '%s'" % sfx_key)
		return

	var sound_array: Array[AudioStream] = _sfx_library[sfx_key]
	if sound_array.is_empty():
		printerr("AudioManager: Categoria de SFX '%s' está vazia." % sfx_key)
		return
	
	var sound_stream: AudioStream = sound_array.pick_random()

	for player: AudioStreamPlayer in _sfx_players:
		if not player.playing:
			player.stream = sound_stream
			player.bus = bus
			player.play()
			return

func play_random_music(music_key: String) -> void:
	if not _music_library.has(music_key):
		printerr("AudioManager: Chave de música não encontrada na biblioteca: '%s'" % music_key)
		return

	var music_array: Array[AudioStream] = _music_library[music_key]
	if music_array.is_empty():
		printerr("AudioManager: Categoria de música '%s' está vazia." % music_key)
		return

	var music_stream: AudioStream = music_array.pick_random()

	if _music_player.stream == music_stream and _music_player.playing:
		return

	_music_player.stream = music_stream
	_music_player.play()
	print("Tocando música da categoria '%s': %s" % [music_key, music_stream.resource_path.get_file()])
	GlobalEvents.music_track_changed.emit(music_stream.resource_path.get_file())


func stop_music():
	_music_player.stop()

# --- Lógica de Playlist ---

func _select_and_play_random_playlist():
	if _music_playlist_keys.is_empty():
		printerr("AudioManager: Nenhuma playlist de música encontrada para tocar.")
		return

	_current_playlist_key = _music_playlist_keys.pick_random()
	print("Playlist selecionada: '%s'" % _current_playlist_key)
	play_random_music(_current_playlist_key)


# --- Handlers de Sinais ---

func _on_settings_changed(change_data: Dictionary) -> void:
	if change_data.has("audio") and typeof(change_data["audio"]) == TYPE_DICTIONARY:
		var audio_changes = change_data["audio"]
		if audio_changes.has("master_volume"):
			call_deferred("_update_bus_volume", MASTER_BUS_NAME, audio_changes["master_volume"])
		if audio_changes.has("music_volume"):
			call_deferred("_update_bus_volume", MUSIC_BUS_NAME, audio_changes["music_volume"])
		if audio_changes.has("sfx_volume"):
			call_deferred("_update_bus_volume", SFX_BUS_NAME, audio_changes["sfx_volume"])

func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("audio") and typeof(settings["audio"]) == TYPE_DICTIONARY:
		var audio_settings = settings["audio"]
		if audio_settings.has("master_volume"):
			_update_bus_volume(MASTER_BUS_NAME, audio_settings["master_volume"])
		if audio_settings.has("music_volume"):
			_update_bus_volume(MUSIC_BUS_NAME, audio_settings["music_volume"])
		if audio_settings.has("sfx_volume"):
			_update_bus_volume(SFX_BUS_NAME, audio_settings["sfx_volume"])

func _on_music_finished():
	# Toca a próxima música aleatória da mesma playlist.
	if _current_playlist_key.is_empty():
		_select_and_play_random_playlist()
	else:
		play_random_music(_current_playlist_key)


func _update_bus_volume(bus_name: String, linear_volume: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		var db_volume: float = linear_to_db(linear_volume) if linear_volume > 0.001 else -80.0
		AudioServer.set_bus_volume_db(bus_index, db_volume)


func _on_music_change_timer_timeout() -> void:
	# Esta função pode ser usada para trocar de playlist após um tempo.
	_select_and_play_random_playlist()


func _on_music_change_requested() -> void:
	_select_and_play_random_playlist()
	music_change_timer.start(300) # Restart the timer after manual change
