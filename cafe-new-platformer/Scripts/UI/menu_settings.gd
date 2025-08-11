extends Control

# Referências aos nós da UI
@onready var resolution_button: OptionButton = $Panel/VBoxContainer/TabContainer/Video/ResolutionHBox/ResolutionOptionButton
@onready var fullscreen_checkbox: CheckBox = $Panel/VBoxContainer/TabContainer/Video/FullscreenCheckBox
@onready var vsync_checkbox: CheckBox = $Panel/VBoxContainer/TabContainer/Video/VSyncCheckBox
@onready var fps_limit_button: OptionButton = $Panel/VBoxContainer/TabContainer/Video/FPSLimitHBox/FPSLimitOptionButton
@onready var master_slider: HSlider = $Panel/VBoxContainer/TabContainer/Audio/MasterHSlider
@onready var music_slider: HSlider = $Panel/VBoxContainer/TabContainer/Audio/MusicHSlider
@onready var sfx_slider: HSlider = $Panel/VBoxContainer/TabContainer/Audio/SfxHSlider
@onready var apply_button: Button = $Panel/VBoxContainer/HBoxContainer/ApplyButton
@onready var back_button: Button = $Panel/VBoxContainer/HBoxContainer/BackButton

# Dicionários para armazenar as alterações pendentes
var pending_settings: Dictionary = {
	"audio": {},
	"video": {}
}

func _ready() -> void:
	populate_video_options()
	connect_signals()
	update_ui_from_settings()

func populate_video_options() -> void:
	resolution_button.add_item("1280x720")
	resolution_button.add_item("1920x1080")
	resolution_button.add_item("2560x1440")
	resolution_button.add_item("3840x2160")
	fps_limit_button.add_item("Ilimitado", 0)
	fps_limit_button.add_item("30", 30)
	fps_limit_button.add_item("60", 60)
	fps_limit_button.add_item("120", 120)
	fps_limit_button.add_item("144", 144)

func connect_signals() -> void:
	resolution_button.item_selected.connect(_on_video_setting_changed.bind("resolution"))
	fullscreen_checkbox.toggled.connect(_on_video_setting_changed.bind("fullscreen"))
	vsync_checkbox.toggled.connect(_on_video_setting_changed.bind("vsync"))
	fps_limit_button.item_selected.connect(_on_video_setting_changed.bind("fps_limit"))
	master_slider.value_changed.connect(_on_audio_slider_changed.bind("master_volume", "Master"))
	music_slider.value_changed.connect(_on_audio_slider_changed.bind("music_volume", "Music"))
	sfx_slider.value_changed.connect(_on_audio_slider_changed.bind("sfx_volume", "SFX"))
	apply_button.pressed.connect(_on_apply_pressed)
	back_button.pressed.connect(_on_back_pressed)

func update_ui_from_settings() -> void:
	# Limpa alterações pendentes ao recarregar a UI
	pending_settings.audio.clear()
	pending_settings.video.clear()

	# Atualiza UI de Vídeo com base nas configurações salvas
	var video_cfg = SettingsManager.settings.video
	for i in resolution_button.item_count:
		if resolution_button.get_item_text(i) == video_cfg.resolution:
			resolution_button.select(i)
			break
	fullscreen_checkbox.button_pressed = video_cfg.fullscreen
	vsync_checkbox.button_pressed = video_cfg.vsync
	for i in fps_limit_button.item_count:
		if fps_limit_button.get_item_id(i) == video_cfg.fps_limit:
			fps_limit_button.select(i)
			break

	# Atualiza UI de Áudio com base nas configurações salvas
	var audio_cfg = SettingsManager.settings.audio
	master_slider.value = audio_cfg.master_volume
	music_slider.value = audio_cfg.music_volume
	sfx_slider.value = audio_cfg.sfx_volume

# --- Handlers de Sinais ---

func _on_video_setting_changed(value, key: String) -> void:
	# Apenas armazena a intenção de mudança
	if key == "resolution":
		pending_settings.video[key] = resolution_button.get_item_text(value)
	elif key == "fps_limit":
		pending_settings.video[key] = fps_limit_button.get_item_id(value)
	else: # Checkboxes
		pending_settings.video[key] = value

func _on_audio_slider_changed(value: float, key: String, bus_name: StringName) -> void:
	# Aplica em tempo real para feedback do usuário
	AudioManager.set_bus_volume_db(bus_name, linear_to_db(value))
	# Armazena a intenção de mudança para salvar depois
	pending_settings.audio[key] = value

func _on_apply_pressed() -> void:
	# Aplica as alterações de vídeo pendentes
	if pending_settings.video.has("resolution"):
		SettingsManager.apply_resolution(pending_settings.video.resolution)
	if pending_settings.video.has("fullscreen"):
		SettingsManager.apply_fullscreen(pending_settings.video.fullscreen)
	if pending_settings.video.has("vsync"):
		SettingsManager.apply_vsync(pending_settings.video.vsync)
	if pending_settings.video.has("fps_limit"):
		SettingsManager.apply_fps_limit(pending_settings.video.fps_limit)

	# Atualiza o dicionário principal do SettingsManager com as alterações de áudio
	if pending_settings.audio.has("master_volume"):
		SettingsManager.set_master_volume(pending_settings.audio.master_volume)
	if pending_settings.audio.has("music_volume"):
		SettingsManager.set_music_volume(pending_settings.audio.music_volume)
	if pending_settings.audio.has("sfx_volume"):
		SettingsManager.set_sfx_volume(pending_settings.audio.sfx_volume)

	# Salva TODAS as configurações
	SettingsManager.save_settings()
	
	# Limpa as alterações pendentes após aplicar
	pending_settings.video.clear()
	pending_settings.audio.clear()

func _on_back_pressed() -> void:
	# Reverte as alterações de áudio não salvas para os valores originais
	SettingsManager.apply_settings()
	
	# Volta para o menu principal
	SceneManager.change_scene_to_file("res://Scenes/UI/main_menu.tscn")
