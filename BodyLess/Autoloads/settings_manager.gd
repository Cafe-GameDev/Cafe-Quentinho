extends Node

# SettingsManager: Mantém o estado atual de todas as configurações do jogo.
# - Ouve os sinais da UI para atualizar seu estado interno (_current_settings).
# - Ouve um sinal para carregar dados do SaveSystem e atualizar seu estado.
# - Emite sinais individuais para que outros sistemas (AudioManager) possam reagir às mudanças.
# - Solicita ao SaveSystem que salve seu estado em disco.

# O dicionário que serve como "fonte da verdade" para todas as configurações padrão.
const _DEFAULTS: Dictionary = {
	"audio": {
		"master_volume": 1.0,
		"music_volume": 1.0,
		"sfx_volume": 1.0,
	},
	"video": {
		"monitor": 0,
		"window_mode": DisplayServer.WINDOW_MODE_WINDOWED,
		"resolution": Vector2i(1280, 720),
		"aspect_ratio": 0,
		"dynamic_render_scale": 0,
		"render_scale": 1.0,
		"frame_rate_limit": 0,
		"max_frame_rate": 60,
		"vsync_mode": DisplayServer.VSYNC_ENABLED,
		"gamma": 2.2,
		"contrast": 1.0,
		"brightness": 1.0,
		"shaders_quality": 0,
		"effects_quality": 0,
		"colorblind_mode": 0,
		"reduce_screen_shake": false,
		"ui_scale": "100%",
	},
	"language": {
		"locale": "pt_BR"
	}
}

# O dicionário que armazena o estado ATUAL de todas as configurações.
var _current_settings: Dictionary = {}


func _ready() -> void:
	# Inicializa as configurações atuais com uma cópia profunda dos padrões.
	_current_settings = _DEFAULTS.duplicate(true)
	
	# --- Conecta-se aos sinais da UI para atualizar o estado interno ---
	# Áudio
	GlobalEvents.master_volume_changed.connect(_on_master_volume_changed)
	GlobalEvents.music_volume_changed.connect(_on_music_volume_changed)
	GlobalEvents.sfx_volume_changed.connect(_on_sfx_volume_changed)
	
	# Vídeo
	GlobalEvents.monitor_changed.connect(func(index): _current_settings.video.monitor = index)
	GlobalEvents.video_window_mode_changed.connect(func(mode): _current_settings.video.window_mode = mode)
	GlobalEvents.video_resolution_changed.connect(func(res): _current_settings.video.resolution = res)
	GlobalEvents.aspect_ratio_changed.connect(func(index): _current_settings.video.aspect_ratio = index)
	GlobalEvents.render_scale_changed.connect(func(value): _current_settings.video.render_scale = value)
	GlobalEvents.frame_rate_limit_changed.connect(func(mode): _current_settings.video.frame_rate_limit = mode)
	GlobalEvents.max_frame_rate_changed.connect(func(fps): _current_settings.video.max_frame_rate = fps)
	GlobalEvents.vsync_mode_changed.connect(func(mode): _current_settings.video.vsync_mode = mode)
	GlobalEvents.gamma_correction_changed.connect(func(value): _current_settings.video.gamma = value)
	GlobalEvents.contrast_changed.connect(func(value): _current_settings.video.contrast = value)
	GlobalEvents.brightness_changed.connect(func(value): _current_settings.video.brightness = value)
	GlobalEvents.shaders_quality_changed.connect(func(level): _current_settings.video.shaders_quality = level)
	GlobalEvents.effects_quality_changed.connect(func(level): _current_settings.video.effects_quality = level)
	GlobalEvents.colorblind_mode_changed.connect(func(mode): _current_settings.video.colorblind_mode = mode)
	GlobalEvents.reduce_screen_shake_changed.connect(func(enabled): _current_settings.video.reduce_screen_shake = enabled)
	GlobalEvents.ui_scale_preset_changed.connect(func(preset): _current_settings.video.ui_scale = preset)

	# Idioma
	GlobalEvents.locale_setting_changed.connect(_on_locale_setting_changed)

	# --- Conecta-se aos sinais de Save/Load ---
	GlobalEvents.save_settings_requested.connect(_on_save_settings_requested)
	GlobalEvents.settings_loaded.connect(_on_settings_loaded)
	
	# Solicita o carregamento das configurações salvas assim que o jogo inicia.
	GlobalEvents.emit_signal("load_settings_requested")


# --- Handlers de Sinais de Áudio ---

func _on_master_volume_changed(linear_volume: float) -> void:
	_current_settings.audio.master_volume = linear_volume
	_apply_audio_setting("Master", linear_volume)

func _on_music_volume_changed(linear_volume: float) -> void:
	_current_settings.audio.music_volume = linear_volume
	_apply_audio_setting("Music", linear_volume)

func _on_sfx_volume_changed(linear_volume: float) -> void:
	_current_settings.audio.sfx_volume = linear_volume
	_apply_audio_setting("SFX", linear_volume)

# --- Handler de Sinal de Idioma ---

func _on_locale_setting_changed(locale_code: String) -> void:
	_current_settings.language.locale = locale_code
	TranslationServer.set_locale(locale_code)

# --- Lógica de Aplicação ---

func _apply_all_settings() -> void:
	# Aplica todas as configurações de áudio
	_apply_audio_setting("Master", _current_settings.audio.master_volume)
	_apply_audio_setting("Music", _current_settings.audio.music_volume)
	_apply_audio_setting("SFX", _current_settings.audio.sfx_volume)
	
	# Aplica a configuração de idioma
	TranslationServer.set_locale(_current_settings.language.locale)
	
	# TODO: Aplicar todas as configurações de vídeo aqui
	# Exemplo: DisplayServer.window_set_mode(_current_settings.video.window_mode)


func _apply_audio_setting(bus_name: String, linear_volume: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		var db_volume = linear_to_db(linear_volume) if linear_volume > 0.001 else -80.0
		AudioServer.set_bus_volume_db(bus_index, db_volume)


# --- Handlers de Save/Load ---

func _on_save_settings_requested() -> void:
	GlobalEvents.emit_signal("save_settings_to_disk", _current_settings)
	print("SettingsManager: Save requested. Emitting data to SaveSystem.")


func _on_settings_loaded(loaded_data: Dictionary) -> void:
	if loaded_data.is_empty():
		print("SettingsManager: No saved settings found. Using default values.")
		_current_settings = _DEFAULTS.duplicate(true)
	else:
		print("SettingsManager: Settings loaded from SaveSystem. Merging with defaults.")
		# Começa com uma cópia dos padrões e mescla os dados carregados por cima.
		# Isso garante que novas configurações adicionadas em atualizações do jogo
		# não quebrem o save.
		_current_settings = _DEFAULTS.duplicate(true)
		_merge_dictionaries(_current_settings, loaded_data)

	# Aplica as configurações (carregadas ou padrão) no jogo.
	_apply_all_settings()
	
	# Emite sinais para que a UI possa se atualizar com os valores corretos.
	_emit_signals_to_update_ui()


func _emit_signals_to_update_ui() -> void:
	# Emite todos os sinais com os valores atuais para que a UI reflita o estado.
	var audio = _current_settings.audio
	GlobalEvents.emit_signal("master_volume_changed", audio.master_volume)
	GlobalEvents.emit_signal("music_volume_changed", audio.music_volume)
	GlobalEvents.emit_signal("sfx_volume_changed", audio.sfx_volume)
	
	var video = _current_settings.video
	GlobalEvents.emit_signal("monitor_changed", video.monitor)
	GlobalEvents.emit_signal("video_window_mode_changed", video.window_mode)
	# ... e assim por diante para todas as outras configurações ...
	
	GlobalEvents.emit_signal("locale_setting_changed", _current_settings.language.locale)


# --- Funções Utilitárias ---

# Mescla recursivamente o dicionário 'source' no dicionário 'target'.
func _merge_dictionaries(target: Dictionary, source: Dictionary) -> void:
	for key in source:
		if target.has(key) and target[key] is Dictionary and source[key] is Dictionary:
			_merge_dictionaries(target[key], source[key])
		else:
			target[key] = source[key]

