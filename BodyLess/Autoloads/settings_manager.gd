extends Node

# O SettingsManager gerencia o estado das configurações do jogo.
# Ele é dividido em duas responsabilidades principais:
# 1. Gerenciar configurações de Áudio/Vídeo.
# 2. Gerenciar configurações de Idioma.
# Cada responsabilidade tem seu próprio conjunto de variáveis, seu próprio arquivo de save,
# e responde ao seu próprio conjunto de sinais do GlobalEvents, garantindo total desacoplamento.

# --- Dicionários de Configurações (Áudio/Vídeo) ---

var DEFAULT_SETTINGS: Dictionary = {
	"audio": {
		"master_volume": 1.0,
		"music_volume": 1.0,
		"sfx_volume": 1.0,
	},
	"video": {
		"monitor_index": 0,
		"window_mode": DisplayServer.WINDOW_MODE_WINDOWED,
		"resolution": Vector2i(1920, 1080),
		"aspect_ratio": 0,
		"upscaling_mode": 0, # 0: None, 1: FSR1, 2: FSR2
		"upscaling_quality": 2, # 0: Ultra Quality, 1: Quality, 2: Balanced, 3: Performance, 4: Ultra Performance
		"frame_rate_limit_mode": 0,
		"max_frame_rate": 60,
		"vsync_mode": DisplayServer.VSYNC_ENABLED,
		"gamma_correction": 2.2,
		"contrast": 1.0,
		"brightness": 1.0,
		"shaders_quality": 2, # High
		"effects_quality": 2, # High
		"colorblind_mode": 0, # Off
		"reduce_screen_shake": false,
		"ui_scale_preset": "medium",
	}
}

const FSR_QUALITY_SCALES: Dictionary = {
    0: 1.0,  # Ultra Quality
    1: 0.77, # Quality
    2: 0.66, # Balanced
    3: 0.5,  # Performance
    4: 0.33  # Ultra Performance
}

const SETTINGS_TEMPLATE: Dictionary = {
	"audio": {
		"master_volume": {"type": TYPE_FLOAT, "min": 0.0, "max": 1.0},
		"music_volume": {"type": TYPE_FLOAT, "min": 0.0, "max": 1.0},
		"sfx_volume": {"type": TYPE_FLOAT, "min": 0.0, "max": 1.0},
	},
	"video": {
		"monitor_index": {"type": TYPE_INT, "min": 0, "max": 16},
		"window_mode": {"type": TYPE_INT, "valid_values": [DisplayServer.WINDOW_MODE_WINDOWED, DisplayServer.WINDOW_MODE_FULLSCREEN, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN]},
		"resolution": {"type": TYPE_VECTOR2I},
		"aspect_ratio": {"type": TYPE_INT},
		"upscaling_mode": {"type": TYPE_INT, "valid_values": [0, 1, 2]},
		"upscaling_quality": {"type": TYPE_INT, "valid_values": [0, 1, 2, 3, 4]},
		"frame_rate_limit_mode": {"type": TYPE_INT},
		"max_frame_rate": {"type": TYPE_INT, "min": 30, "max": 300},
		"vsync_mode": {"type": TYPE_INT, "valid_values": [DisplayServer.VSYNC_DISABLED, DisplayServer.VSYNC_ENABLED, DisplayServer.VSYNC_ADAPTIVE]},
		"gamma_correction": {"type": TYPE_FLOAT, "min": 1.0, "max": 3.0},
		"contrast": {"type": TYPE_FLOAT, "min": 0.5, "max": 1.5},
		"brightness": {"type": TYPE_FLOAT, "min": 0.5, "max": 1.5},
		"shaders_quality": {"type": TYPE_INT},
		"effects_quality": {"type": TYPE_INT},
		"colorblind_mode": {"type": TYPE_INT},
		"reduce_screen_shake": {"type": TYPE_BOOL},
		"ui_scale": {"type": TYPE_FLOAT, "min": 1.0, "max": 2.0},
	}
}

var live_settings: Dictionary = {}

# --- Dicionários de Idioma ---

var DEFAULT_LANGUAGE_SETTINGS: Dictionary = {
	"language": {
		"locale": "en_US" # Um padrão seguro, será sobrescrito.
	}
}

const LANGUAGE_TEMPLATE: Dictionary = {
	"language": {
		"locale": {"type": TYPE_STRING, "valid_values": [
			"en_US", "en_GB", "en_IN", "pt_BR", "pt_PT", "es_ES", "es_LA", "fr", "de", "it", "nl", "ja", "ko", "ru", 
			"zh_Hans", "zh_Hant", "sw", "af", "pl", "tr", "ar", "hi", "id", "vi", "fil", "ha", "am", "yo", "bn"
		]}
	}
}

var live_language_settings: Dictionary = {}

# --- Dicionários de Mapeamento de Teclas (Input Map) ---
var DEFAULT_INPUT_MAP_SETTINGS: Dictionary = {
	"move_up": [
		{"type": "InputEventKey", "keycode": KEY_W, "physical_keycode": KEY_W, "unicode": 0, "pressed": false}
	],
	"move_down": [
		{"type": "InputEventKey", "keycode": KEY_S, "physical_keycode": KEY_S, "unicode": 0, "pressed": false}
	],
	"move_left": [
		{"type": "InputEventKey", "keycode": KEY_A, "physical_keycode": KEY_A, "unicode": 0, "pressed": false}
	],
	"move_right": [
		{"type": "InputEventKey", "keycode": KEY_D, "physical_keycode": KEY_D, "unicode": 0, "pressed": false}
	],
	"jump": [
		{"type": "InputEventKey", "keycode": KEY_SPACE, "physical_keycode": KEY_SPACE, "unicode": 0, "pressed": false}
	],
	"attack": [
		{"type": "InputEventMouseButton", "button_index": MOUSE_BUTTON_LEFT, "pressed": false}
	],
	"pause": [
		{"type": "InputEventKey", "keycode": KEY_ESCAPE, "physical_keycode": KEY_ESCAPE, "unicode": 0, "pressed": false}
	],
	"inventory": [
		{"type": "InputEventKey", "keycode": KEY_I, "physical_keycode": KEY_I, "unicode": 0, "pressed": false}
	],
	"reload": [
		{"type": "InputEventKey", "keycode": KEY_R, "physical_keycode": KEY_R, "unicode": 0, "pressed": false}
	],
	"special": [
		{"type": "InputEventKey", "keycode": KEY_E, "physical_keycode": KEY_E, "unicode": 0, "pressed": false}
	],
	"sprint": [
		{"type": "InputEventKey", "keycode": KEY_SHIFT, "physical_keycode": KEY_SHIFT, "unicode": 0, "pressed": false}
	],
	"crouch": [
		{"type": "InputEventKey", "keycode": KEY_C, "physical_keycode": KEY_C, "unicode": 0, "pressed": false}
	],
	"toggle_console": [
		{"type": "InputEventKey", "keycode": KEY_F1, "physical_keycode": KEY_F1, "unicode": 0, "pressed": false}
	],
	"music_change": [
		{"type": "InputEventKey", "keycode": KEY_M, "physical_keycode": KEY_M, "unicode": 0, "pressed": false}
	]
}

var live_input_map_settings: Dictionary = {}


func _ready() -> void:
	# Inicializa o idioma padrão baseado no SO.
	DEFAULT_LANGUAGE_SETTINGS.language.locale = OS.get_locale()
	
	_connect_signals()
	
	# O SaveSystem agora é responsável por iniciar o carregamento das configurações
	# GlobalEvents.request_loading_settings_changed.emit() # Isso será emitido pelo SaveSystem
	# GlobalEvents.request_loading_language_changed.emit() # Isso será emitido pelo SaveSystem


func _connect_signals() -> void:
	# Conexões para Configurações (Áudio/Vídeo)
	GlobalEvents.setting_changed.connect(_on_setting_changed)
	GlobalEvents.request_saving_settings_changed.connect(_on_request_saving_settings)
	GlobalEvents.request_reset_settings_changed.connect(_on_request_reset_settings)
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed) # Recebe dados carregados do SaveSystem
	GlobalEvents.request_settings_data_for_save.connect(_on_request_settings_data_for_save) # SaveSystem requisita dados

	# Conexões para Idioma
	GlobalEvents.language_changed.connect(_on_language_changed)
	GlobalEvents.request_saving_language_changed.connect(_on_request_saving_language)
	GlobalEvents.request_reset_language_changed.connect(_on_request_reset_language)
	GlobalEvents.loading_language_changed.connect(_on_loading_language_changed) # Recebe dados carregados do SaveSystem
	GlobalEvents.request_language_data_for_save.connect(_on_request_language_data_for_save) # SaveSystem requisita dados

	# Conexões para Mapeamento de Teclas (Input Map)
	GlobalEvents.request_reset_input_map_changed.connect(_on_request_reset_input_map_changed)
	GlobalEvents.loading_input_map_changed.connect(_on_loading_input_map_changed_from_save) # Recebe dados carregados do SaveSystem
	GlobalEvents.request_input_map_data_for_save.connect(_on_request_input_map_data_for_save) # SaveSystem requisita dados


# ==============================================================================
# Lógica para Configurações (Áudio/Vídeo)
# ==============================================================================

func _on_loading_settings_changed(settings_data: Dictionary) -> void:
	live_settings = _validate_and_merge_data(settings_data, DEFAULT_SETTINGS, SETTINGS_TEMPLATE)
	_apply_video_settings(live_settings.video)
	_apply_audio_settings(live_settings.audio)

func _on_request_saving_settings() -> void:
	# O SaveSystem agora espera por um sinal para coletar os dados
	GlobalEvents.settings_data_for_save_received.emit(live_settings)

func _on_loading_language_changed(language_data: Dictionary) -> void:
	live_language_settings = _validate_and_merge_data(language_data, DEFAULT_LANGUAGE_SETTINGS, LANGUAGE_TEMPLATE)
	_apply_locale(live_language_settings.language.locale)

func _on_request_saving_language() -> void:
	# O SaveSystem agora espera por um sinal para coletar os dados
	GlobalEvents.language_data_for_save_received.emit(live_language_settings)

func _on_request_settings_data_for_save() -> void:
	GlobalEvents.settings_data_for_save_received.emit(live_settings)

func _on_request_language_data_for_save() -> void:
	GlobalEvents.language_data_for_save_received.emit(live_language_settings)

func _on_setting_changed(change_data: Dictionary) -> void:
	live_settings.merge(change_data, true)
	if change_data.has("video"):
		_apply_video_settings(live_settings.video)
	if change_data.has("audio"):
		_apply_audio_settings(live_settings.audio)

func _on_request_reset_settings() -> void:
	live_settings = DEFAULT_SETTINGS.duplicate(true)
	GlobalEvents.request_saving_settings_changed.emit()


func _apply_video_settings(video_settings: Dictionary) -> void:
	# Aplica configurações de janela
	DisplayServer.window_set_mode(video_settings.window_mode)
	DisplayServer.window_set_size(video_settings.resolution)
	DisplayServer.window_set_current_screen(video_settings.monitor_index)

	# Aplica FSR
	var fsr_mode = video_settings.upscaling_mode
	var fsr_scale = FSR_QUALITY_SCALES.get(video_settings.upscaling_quality, 0.66) # Default para Balanced

	ProjectSettings.set_setting("rendering/scaling_3d/mode", fsr_mode)
	ProjectSettings.set_setting("rendering/scaling_3d/scale", fsr_scale)
	ProjectSettings.save() # Salva as configurações do projeto para que o FSR seja aplicado

	# Aplica VSync
	DisplayServer.window_set_vsync_mode(video_settings.vsync_mode)

	# Aplica Frame Rate Limit
	Engine.max_fps = video_settings.max_frame_rate if video_settings.frame_rate_limit_mode == 1 else 0

	# TODO: Implementar lógica para aspect_ratio, gamma_correction, contrast, brightness, shaders_quality, effects_quality, colorblind_mode, reduce_screen_shake, ui_scale_preset

func _apply_audio_settings(audio_settings: Dictionary) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(audio_settings.master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(audio_settings.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), linear_to_db(audio_settings.sfx_volume))


# ==============================================================================
# Lógica para Idioma
# ==============================================================================



func _on_language_changed(change_data: Dictionary) -> void:
	live_language_settings.merge(change_data, true)
	# Aplica a mudança de idioma em tempo real
	if change_data.has("language") and change_data.language.has("locale"):
		_apply_locale(change_data.language.locale)

func _on_request_reset_language() -> void:
	live_language_settings = DEFAULT_LANGUAGE_SETTINGS.duplicate(true)
	GlobalEvents.request_saving_language_changed.emit()

func _apply_locale(locale_code: String) -> void:
	TranslationServer.set_locale(locale_code)


# ==============================================================================
# Lógica para Mapeamento de Teclas (Input Map)
# ==============================================================================

func _on_request_reset_input_map_changed() -> void:
	# Redefine os mapeamentos de input para os padrões de fábrica.
	# Aplica os mapeamentos padrão ao InputMap do Godot.
	_apply_input_map_data(DEFAULT_INPUT_MAP_SETTINGS)

	# Notifica a UI de InputMap para atualizar seus botões com os padrões
	GlobalEvents.loading_input_map_changed.emit(DEFAULT_INPUT_MAP_SETTINGS)

	# Solicita o salvamento das configurações de input redefinidas.
	GlobalEvents.request_saving_input_map_changed.emit()


func _on_loading_input_map_changed_from_save(input_map_data: Dictionary) -> void:
	# Recebe os dados do InputMap carregados do SaveSystem e os aplica.
	_apply_input_map_data(input_map_data)

	# Atualiza a UI de InputMap para refletir os mapeamentos carregados.
	GlobalEvents.loading_input_map_changed.emit(input_map_data)


func _on_request_input_map_data_for_save() -> void:
	# Coleta os mapeamentos atuais do InputMap e os envia para o SaveSystem.
	var input_map_data: Dictionary = {}
	for action_name in InputMap.get_actions():
		var events_data: Array = []
		for event in InputMap.action_get_events(action_name):
			var event_dict: Dictionary = {}
			if event is InputEventKey:
				event_dict = {
					"type": "InputEventKey",
					"keycode": event.keycode,
					"physical_keycode": event.physical_keycode,
					"unicode": event.unicode,
					"pressed": false
				}
			elif event is InputEventJoypadButton:
				event_dict = {
					"type": "InputEventJoypadButton",
					"button_index": event.button_index,
					"pressed": false
				}
			elif event is InputEventJoypadMotion:
				event_dict = {
					"type": "InputEventJoypadMotion",
					"axis": event.axis,
					"axis_value": event.axis_value
				}
			elif event is InputEventMouseButton:
				event_dict = {
					"type": "InputEventMouseButton",
					"button_index": event.button_index,
					"pressed": false
				}
			events_data.append(event_dict)
		input_map_data[action_name] = events_data
	
	GlobalEvents.input_map_data_for_save_received.emit(input_map_data)


func _apply_input_map_data(input_map_data: Dictionary) -> void:
	# Aplica os mapeamentos de input fornecidos ao InputMap do Godot.
	for action_name in input_map_data:
		var events_data: Array = input_map_data[action_name]
		# Limpa todos os eventos existentes para esta ação antes de aplicar os novos
		for event in InputMap.action_get_events(action_name):
			InputMap.action_erase_event(action_name, event)
		
		for event_data in events_data:
			var event_type: String = event_data.get("type", "")
			var new_event: InputEvent
			
			match event_type:
				"InputEventKey":
					new_event = InputEventKey.new()
					new_event.keycode = event_data.get("keycode", 0)
					new_event.physical_keycode = event_data.get("physical_keycode", 0)
					new_event.unicode = event_data.get("unicode", 0)
					new_event.pressed = event_data.get("pressed", false)
				"InputEventJoypadButton":
					new_event = InputEventJoypadButton.new()
					new_event.button_index = event_data.get("button_index", 0)
					new_event.pressed = event_data.get("pressed", false)
				"InputEventJoypadMotion":
					new_event = InputEventJoypadMotion.new()
					new_event.axis = event_data.get("axis", 0)
					new_event.axis_value = event_data.get("axis_value", 0.0)
				"InputEventMouseButton":
					new_event = InputEventMouseButton.new()
					new_event.button_index = event_data.get("button_index", 0)
					new_event.pressed = event_data.get("pressed", false)
				_:
					printerr("SettingsManager: Tipo de evento desconhecido ao aplicar InputMap: %s" % event_type)
					continue
			InputMap.action_add_event(action_name, new_event)


# ==============================================================================
# Lógica Genérica de Validação
# ==============================================================================

func _validate_and_merge_data(loaded_data: Dictionary, default_data: Dictionary, template: Dictionary) -> Dictionary:
	var final_data = default_data.duplicate(true)
	if loaded_data.is_empty():
		return final_data

	for category in final_data:
		if not loaded_data.has(category) or typeof(loaded_data[category]) != TYPE_DICTIONARY:
			continue
		for key in final_data[category]:
			if not loaded_data[category].has(key):
				continue

			var loaded_value = loaded_data[category][key]
			var rule = template[category][key]
			var is_valid = false

			var loaded_type = typeof(loaded_value)
			if rule.has("type") and loaded_type != rule.type:
				printerr("[SM] Validation FAILED for '%s.%s'. Type mismatch." % [category, key])
			elif key == "locale":
				var validated_locale = _get_validated_locale(loaded_value)
				if validated_locale in rule.valid_values:
					loaded_value = validated_locale
					is_valid = true
				else:
					printerr("[SM] Validation FAILED for '%s'. Not a valid locale: %s" % [key, loaded_value])
			elif rule.has("valid_values"):
				if loaded_value in rule.valid_values: is_valid = true
			elif rule.has("min") and rule.has("max"):
				if loaded_value >= rule.min and loaded_value <= rule.max: is_valid = true
			else:
				is_valid = true

			if is_valid:
				final_data[category][key] = loaded_value
	
	return final_data

func _get_validated_locale(locale_code: String) -> String:
	# Lógica de middleware/fallback para locales
	if locale_code.begins_with("en") and locale_code not in ["en_US", "en_GB", "en_IN"]:
		return "en_US"
	if locale_code.begins_with("es") and locale_code not in ["es_ES", "es_LA"]:
		return "es_LA"
	if locale_code.begins_with("pt") and locale_code not in ["pt_BR", "pt_PT"]:
		return "pt_PT"
	if locale_code == "zh_CN" or locale_code == "zh":
		return "zh_Hans"
	if locale_code in ["zh_TW", "zh_HK"]:
		return "zh_Hant"
	return locale_code