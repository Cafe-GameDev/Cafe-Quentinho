extends Node

# Controla a reprodução de música e efeitos sonoros.

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer]
const SFX_PLAYER_COUNT = 10 # Número de players simultâneos para SFX

func _ready() -> void:
	# Cria e configura o player de música
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	add_child(music_player)

	# Cria e configura o pool de players de SFX
	for i in range(SFX_PLAYER_COUNT):
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.name = "SfxPlayer_%s" % i
		sfx_player.bus = "SFX"
		add_child(sfx_player)
		sfx_players.append(sfx_player)

func play_music(stream: AudioStream, volume_db: float = 0.0) -> void:
	music_player.stream = stream
	music_player.volume_db = volume_db
	music_player.bus = "Music"
	music_player.play()

func play_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
	for player in sfx_players:
		if not player.playing:
			player.stream = stream
			player.volume_db = volume_db
			player.play()
			return
	# Se todos os players estiverem ocupados, o som não toca.
	# Pode-se adicionar uma lógica mais complexa aqui se necessário.
	print("AudioManager: No available SFX player.")

func set_bus_volume_db(bus_name: StringName, volume_db: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), volume_db)

func get_bus_volume_db(bus_name: StringName) -> float:
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name))