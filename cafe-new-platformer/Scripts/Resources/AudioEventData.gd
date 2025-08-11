class_name AudioEventData
extends Resource

# Array de AudioStream que podem ser tocados para este evento.
@export var audio_streams: Array[AudioStream] = []

@export_group("Variação")
@export var randomize_volume: bool = true
@export_range(0.0, 1.0) var volume_min: float = 0.8
@export_range(0.0, 1.0) var volume_max: float = 1.0

@export var randomize_pitch: bool = true
@export_range(0.5, 2.0) var pitch_min: float = 0.9
@export_range(0.5, 2.0) var pitch_max: float = 1.1

# Função auxiliar para ser chamada pelo AudioManager
func play(audio_player: AudioStreamPlayer):
    if audio_streams.is_empty():
        return
    
    var stream = audio_streams.pick_random()
    audio_player.stream = stream
    
    if randomize_volume:
        audio_player.volume_db = linear_to_db(randf_range(volume_min, volume_max))
    
    if randomize_pitch:
        audio_player.pitch_scale = randf_range(pitch_min, pitch_max)
        
    audio_player.play()
