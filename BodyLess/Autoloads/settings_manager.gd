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

const TYPE_TO_STRING: Dictionary = {
	TYPE_NIL: "Nil",
	TYPE_BOOL: "bool",
	TYPE_INT: "int",
	TYPE_FLOAT: "float",
	TYPE_STRING: "String",
	TYPE_VECTOR2: "Vector2",
	TYPE_VECTOR2I: "Vector2i",
	TYPE_RECT2: "Rect2",
	TYPE_RECT2I: "Rect2i",
	TYPE_VECTOR3: "Vector3",
	TYPE_VECTOR3I: "Vector3i",
	TYPE_TRANSFORM2D: "Transform2D",
	TYPE_VECTOR4: "Vector4",
	TYPE_VECTOR4I: "Vector4i",
	TYPE_QUATERNION: "Quaternion",
	TYPE_AABB: "AABB",
	TYPE_BASIS: "Basis",
	TYPE_TRANSFORM3D: "Transform3D",
	TYPE_PROJECTION: "Projection",
	TYPE_COLOR: "Color",
	TYPE_STRING_NAME: "StringName",
	TYPE_NODE_PATH: "NodePath",
	TYPE_RID: "RID",
	TYPE_OBJECT: "Object",
	TYPE_CALLABLE: "Callable",
	TYPE_SIGNAL: "Signal",
	TYPE_DICTIONARY: "Dictionary",
	TYPE_ARRAY: "Array",
	TYPE_PACKED_BYTE_ARRAY: "PackedByteArray",
	TYPE_PACKED_INT32_ARRAY: "PackedInt32Array",
	TYPE_PACKED_INT64_ARRAY: "PackedInt64Array",
	TYPE_PACKED_FLOAT32_ARRAY: "PackedFloat32Array",
	TYPE_PACKED_FLOAT64_ARRAY: "PackedFloat64Array",
	TYPE_PACKED_STRING_ARRAY: "PackedStringArray",
	TYPE_PACKED_VECTOR2_ARRAY: "PackedVector2Array",
	TYPE_PACKED_VECTOR3_ARRAY: "PackedVector3Array",
	TYPE_PACKED_COLOR_ARRAY: "PackedColorArray"
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

	live_settings = DEFAULT_SETTINGS.duplicate(true)
	live_language_settings = DEFAULT_LANGUAGE_SETTINGS.duplicate(true)
	live_input_map_settings = DEFAULT_INPUT_MAP_SETTINGS.duplicate(true)


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
	GlobalEvents.input_map_changed.connect(_on_input_map_changed) # Recebe atualizações da UI de remapeamento
	GlobalEvents.request_reset_input_map.connect(_on_request_reset_input_map)


# ==============================================================================
# Lógica para Configurações (Áudio/Vídeo)
# ==============================================================================



func _on_loading_settings_changed(settings_data: Dictionary) -> void:
	print("[SettingsManager] Recebendo dados de configurações carregados: ", settings_data)
	live_settings = _validate_and_merge_data(settings_data, DEFAULT_SETTINGS, SETTINGS_TEMPLATE)
	live_input_map_settings = settings_data.get("input_map_settings", DEFAULT_INPUT_MAP_SETTINGS).duplicate(true)
	_apply_video_settings(live_settings.video)
	_apply_audio_settings(live_settings.audio)
	_apply_input_map_data(live_input_map_settings)
	GlobalEvents.loading_input_map_changed.emit(live_input_map_settings) # Notifica a UI de InputMap
	print("[SettingsManager] Configurações aplicadas: ", live_settings)
	print("[SettingsManager] Mapeamento de input aplicado: ", live_input_map_settings)

func _on_request_saving_settings() -> void:
	print("[SettingsManager] Requisitando salvamento de configurações. Enviando dados: ", live_settings)
	var data_to_save = live_settings.duplicate(true)
	data_to_save["input_map_settings"] = live_input_map_settings.duplicate(true)
	GlobalEvents.settings_data_for_save_received.emit(data_to_save)

func _on_loading_language_changed(language_data: Dictionary) -> void:
	print("[SettingsManager] Recebendo dados de idioma carregados: ", language_data)
	live_language_settings = _validate_and_merge_data(language_data, DEFAULT_LANGUAGE_SETTINGS, LANGUAGE_TEMPLATE)
	_apply_locale(live_language_settings.language.locale)
	print("[SettingsManager] Idioma aplicado: ", live_language_settings.language.locale)

func _on_request_saving_language() -> void:
	print("[SettingsManager] Requisitando salvamento de idioma. Enviando dados: ", live_language_settings)
	GlobalEvents.language_data_for_save_received.emit(live_language_settings)

func _on_request_settings_data_for_save() -> void:
	print("[SettingsManager] SaveSystem requisitou dados de configurações. Enviando: ", live_settings)
	GlobalEvents.settings_data_for_save_received.emit(live_settings)

func _on_request_language_data_for_save() -> void:
	print("[SettingsManager] SaveSystem requisitou dados de idioma. Enviando: ", live_language_settings)
	GlobalEvents.language_data_for_save_received.emit(live_language_settings)

func _on_setting_changed(change_data: Dictionary) -> void:
	print("[SettingsManager] Configuração alterada em tempo real: ", change_data)
	live_settings.merge(change_data, true)
	if change_data.has("video"):
		_apply_video_settings(live_settings.video)
	if change_data.has("audio"):
		_apply_audio_settings(live_settings.audio)

func _on_request_reset_settings() -> void:
	print("[SettingsManager] Requisitando reset de configurações para padrão.")
	live_settings = DEFAULT_SETTINGS.duplicate(true)
	live_input_map_settings = DEFAULT_INPUT_MAP_SETTINGS.duplicate(true)
	_apply_video_settings(live_settings.video)
	_apply_audio_settings(live_settings.audio)
	_apply_input_map_data(live_input_map_settings)
	GlobalEvents.loading_input_map_changed.emit(live_input_map_settings) # Notifica a UI de InputMap
	GlobalEvents.request_saving_settings_changed.emit()
	print("[SettingsManager] Configurações e mapeamento de input resetados e salvamento solicitado.")


func _apply_video_settings(video_settings: Dictionary) -> void:
	print("[SettingsManager] Aplicando configurações de vídeo: ", video_settings)
	# Aplica configurações de janela
	DisplayServer.window_set_mode(video_settings.get("window_mode", DisplayServer.WINDOW_MODE_WINDOWED))
	DisplayServer.window_set_size(video_settings.get("resolution", Vector2i(1920, 1080)))
	DisplayServer.window_set_current_screen(video_settings.get("monitor_index", 0))

	# Aplica FSR
	var fsr_mode = video_settings.get("upscaling_mode", 0)
	var fsr_quality_index = video_settings.get("upscaling_quality", 2) # Default para Balanced
	var fsr_scale = FSR_QUALITY_SCALES.get(fsr_quality_index, 0.66)

	ProjectSettings.set_setting("rendering/scaling_3d/mode", fsr_mode)
	ProjectSettings.set_setting("rendering/scaling_3d/scale", fsr_scale)
	ProjectSettings.save() # Salva as configurações do projeto para que o FSR seja aplicado
	print("[SettingsManager] FSR Mode: %d, FSR Scale: %f" % [fsr_mode, fsr_scale])

	# Aplica VSync
	DisplayServer.window_set_vsync_mode(video_settings.get("vsync_mode", DisplayServer.VSYNC_ENABLED))
	print("[SettingsManager] VSync Mode: %d" % video_settings.get("vsync_mode", DisplayServer.VSYNC_ENABLED))

	# Aplica Frame Rate Limit
	Engine.max_fps = video_settings.get("max_frame_rate", 60) if video_settings.get("frame_rate_limit_mode", 0) == 1 else 0
	print("[SettingsManager] Max FPS: %d" % Engine.max_fps)

	# TODO: Implementar lógica para aspect_ratio, gamma_correction, contrast, brightness, shaders_quality, effects_quality, colorblind_mode, reduce_screen_shake, ui_scale_preset

func _apply_audio_settings(audio_settings: Dictionary) -> void:
	print("[SettingsManager] Aplicando configurações de áudio: ", audio_settings)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(audio_settings.get("master_volume", 1.0)))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(audio_settings.get("music_volume", 1.0)))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), linear_to_db(audio_settings.get("sfx_volume", 1.0)))
	print("[SettingsManager] Volumes de áudio aplicados.")


# ==============================================================================
# Lógica para Idioma
# ==============================================================================



func _on_language_changed(change_data: Dictionary) -> void:
	print("[SettingsManager] Idioma alterado em tempo real: ", change_data)
	live_language_settings.merge(change_data, true)
	# Aplica a mudança de idioma em tempo real
	if change_data.has("language") and change_data.language.has("locale"):
		_apply_locale(change_data.language.locale)

func _on_request_reset_language() -> void:
	print("[SettingsManager] Requisitando reset de idioma para padrão.")
	live_language_settings = DEFAULT_LANGUAGE_SETTINGS.duplicate(true)
	GlobalEvents.request_saving_language_changed.emit()
	print("[SettingsManager] Idioma resetado e salvamento solicitado.")

func _apply_locale(locale_code: String) -> void:
	print("[SettingsManager] Aplicando locale: ", locale_code)
	TranslationServer.set_locale(locale_code)


# ==============================================================================
# Lógica para Mapeamento de Teclas (Input Map)
# ==============================================================================

func _on_request_reset_input_map() -> void:
	print("[SettingsManager] Requisitando reset de mapeamento de teclas para padrão.")
	# Redefine os mapeamentos de input para os padrões de fábrica.
	# Aplica os mapeamentos padrão ao InputMap do Godot.
	_apply_input_map_data(DEFAULT_INPUT_MAP_SETTINGS)

	# Notifica a UI de InputMap para atualizar seus botões com os padrões
	GlobalEvents.loading_input_map_changed.emit(DEFAULT_INPUT_MAP_SETTINGS)

	# Solicita o salvamento das configurações de input redefinidas.
	GlobalEvents.request_saving_settings_changed.emit()
	print("[SettingsManager] Mapeamento de teclas resetado e salvamento solicitado.")





func _on_input_map_changed(input_map_data: Dictionary) -> void:
	print("[SettingsManager] Mapeamento de teclas alterado em tempo real: ", input_map_data)
	live_input_map_settings = input_map_data.duplicate(true) # Atualiza o estado interno
	GlobalEvents.request_saving_settings_changed.emit() # Solicita o salvamento das configurações (incluindo input map)
	print("[SettingsManager] Mapeamento de teclas atualizado e salvamento solicitado.")


func _apply_input_map_data(input_map_data: Dictionary) -> void:
	print("[SettingsManager] Aplicando mapeamentos de input: ", input_map_data)
	# Limpa todas as ações existentes no InputMap do Godot
	for action_name in InputMap.get_actions():
		InputMap.erase_action(action_name)

	# Aplica os novos mapeamentos de input
	for action_name in input_map_data:
		InputMap.add_action(action_name)
		var events_data: Array = input_map_data[action_name]
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
	print("[SettingsManager] Mapeamentos de input aplicados.")





# ==============================================================================
# Lógica Genérica de Validação
# ==============================================================================

func _validate_and_merge_data(loaded_data: Dictionary, default_data: Dictionary, template: Dictionary) -> Dictionary:
	print("[SettingsManager] Validando e mesclando dados. Carregados: %s, Padrão: %s" % [loaded_data, default_data])
	var final_data = default_data.duplicate(true)
	if loaded_data.is_empty():
		print("[SettingsManager] Dados carregados vazios. Retornando dados padrão.")
		return final_data

	for category in final_data:
		if not loaded_data.has(category) or typeof(loaded_data[category]) != TYPE_DICTIONARY:
			print("[SettingsManager] Categoria '%s' não encontrada ou não é um dicionário nos dados carregados. Pulando." % category)
			continue
		for key in final_data[category]:
			if not loaded_data[category].has(key):
				print("[SettingsManager] Chave '%s.%s' não encontrada nos dados carregados. Mantendo padrão." % [category, key])
				continue

			var loaded_value = loaded_data[category][key]
			var rule = template[category][key]
			var is_valid = true # Assume válido até que uma regra falhe

			var loaded_type = typeof(loaded_value)
			if rule.has("type") and loaded_type != rule.type:
				printerr("[SM] Validation FAILED for '%s.%s'. Type mismatch. Expected %s, got %s." % [category, key, TYPE_TO_STRING[rule.type], TYPE_TO_STRING[loaded_type]])
				is_valid = false

			if is_valid: # Only proceed with further validation if type is correct
				if key == "locale":
					var validated_locale = _get_validated_locale(loaded_value)
					if validated_locale in rule.valid_values:
						loaded_value = validated_locale
					else:
						printerr("[SM] Validation FAILED for '%s'. Not a valid locale: %s" % [key, loaded_value])
						is_valid = false
				elif rule.has("valid_values"):
					if loaded_value in rule.valid_values:
						pass # Already valid
					else:
						printerr("[SM] Validation FAILED for '%s.%s'. Value '%s' not in valid_values." % [category, key, loaded_value])
						is_valid = false
				elif rule.has("min") and rule.has("max"):
					if loaded_value >= rule.min and loaded_value <= rule.max:
						pass # Already valid
					else:
						printerr("[SM] Validation FAILED for '%s.%s'. Value '%s' out of range [%s, %s]." % [category, key, loaded_value, rule.min, rule.max])
						is_valid = false
				# No 'else' needed here, as is_valid remains true if no specific rule applies

			if is_valid:
				final_data[category][key] = loaded_value
				print("[SettingsManager] Validado e mesclado: %s.%s = %s" % [category, key, loaded_value])
			else:
				printerr("[SettingsManager] Falha na validação para %s.%s. Mantendo valor padrão: %s" % [category, key, final_data[category][key]])

	print("[SettingsManager] Validação e mesclagem concluídas. Dados finais: ", final_data)
	return final_data

func _get_validated_locale(locale_code: String) -> String:
	print("[SettingsManager] Validando locale: ", locale_code)
	# Lógica de middleware/fallback para locales
	if locale_code.begins_with("en") and locale_code not in ["en_US", "en_GB", "en_IN"]:
		print("[SettingsManager] Locale '%s' fallback para en_US." % locale_code)
		return "en_US"
	if locale_code.begins_with("es") and locale_code not in ["es_ES", "es_LA"]:
		print("[SettingsManager] Locale '%s' fallback para es_LA." % locale_code)
		return "es_LA"
	if locale_code.begins_with("pt") and locale_code not in ["pt_BR", "pt_PT"]:
		print("[SettingsManager] Locale '%s' fallback para pt_PT." % locale_code)
		return "pt_PT"
	if locale_code == "zh_CN" or locale_code == "zh":
		print("[SettingsManager] Locale '%s' fallback para zh_Hans." % locale_code)
		return "zh_Hans"
	if locale_code in ["zh_TW", "zh_HK"]:
		print("[SettingsManager] Locale '%s' fallback para zh_Hant." % locale_code)
		return "zh_Hant"
	print("[SettingsManager] Locale '%s' validado." % locale_code)
	return locale_code
