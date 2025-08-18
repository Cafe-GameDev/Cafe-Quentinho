extends Control

# --- Nós da UI ---
@onready var video_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/VideoButton
@onready var audio_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/AudioButton
@onready var language_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/LanguageButton
@onready var back_button: Button = $PanelContainer/Margin/Box/BottomButtonsContainer/BackButton

@onready var video_settings_panel: VBoxContainer = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings
@onready var audio_settings_panel: VBoxContainer = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings
@onready var language_settings_panel: VBoxContainer = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings
@onready var apply_button: Button = $PanelContainer/Margin/Box/BottomButtonsContainer/ApplyButton

@onready var video_label: Label = $PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel
@onready var audio_label: Label = $PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel
@onready var language_label: Label = $PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel

# Controles Específicos
# Controles de Áudio
@onready var master_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings/MasterSlider
@onready var music_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings/MusicSlider
@onready var sfx_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings/SfxSlider
@onready var language_options_container: VBoxContainer = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings/LanguageOptionsContainer

# Controles de Vídeo
@onready var monitor_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Monitor/MonitorOptionButton
@onready var window_mode_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Window/WindowModeOptionButton
@onready var resolution_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Resolution/ResolutionOptionButton
@onready var field_of_view_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Field/FieldOfViewSlider
@onready var aspect_ratio_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Aspect/AspectRatioOptionButton
@onready var dynamic_render_scale_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/DynamicRender/DynamicRenderScaleOptionButton
@onready var render_scale_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/RenderScale/RenderScaleSlider
@onready var frame_rate_limit_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/FrameRate/FrameRateLimitOptionButton
@onready var max_frame_rate_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/MaxFrame/MaxFrameRateSlider
@onready var vsync_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/VSync/VSyncOptionButton
@onready var triple_buffering_check_box: CheckBox = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/TripleBuffering/TripleBufferingCheckBox
@onready var reduce_buffering_check_box: CheckBox = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/ReduceBuffering/ReduceBufferingCheckBox
@onready var low_latency_mode_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/LowLatency/LowLatencyModeOptionButton
@onready var gamma_correction_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/GammaCorrection/GammaCorrectionSlider
@onready var contrast_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Contrast/ContrastSlider
@onready var brightness_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Brightness/BrightnessSlider
@onready var hdr_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/HDR/HDROptionButton
@onready var hdr_calibration_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/HDRCalibrationButton
@onready var shaders_quality_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Shaders/ShadersQualityOptionButton
@onready var effects_quality_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/EffectsQuality/EffectsQualityOptionButton
@onready var colorblind_mode_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Colorblind/ColorblindModeOptionButton
@onready var reduce_screen_shake_check_box: CheckBox = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/ReduceScreenShake/ReduceScreenShakeCheckBox
@onready var ui_scale_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/UIScale/UIScaleOptionButton


# Mapeia códigos de localidade para nomes de exibição
const _locales = {
	"pt_BR": "Português",
	"en": "English",
	"es": "Español",
	"fr": "Français"
}

# Mapeia enums para nomes de exibição
const _window_modes = {
	DisplayServer.WINDOW_MODE_WINDOWED: "UI_WINDOW_MODE_WINDOWED",
	DisplayServer.WINDOW_MODE_FULLSCREEN: "UI_WINDOW_MODE_FULLSCREEN",
}

const _aspect_ratios = {
	0: "16:9",
	1: "4:3",
	2: "21:9",
	# Adicione mais se necessário
}

const _dynamic_render_scale_modes = {
	0: "UI_DRS_OFF",
	1: "UI_DRS_CUSTOM",
}

const _frame_rate_limits = {
	0: "UI_FPS_CUSTOM",
	1: "30",
	2: "60",
	3: "144",
	4: "240",
	5: "360",
}

const _vsync_modes = {
	DisplayServer.VSYNC_DISABLED: "UI_VSYNC_OFF",
	DisplayServer.VSYNC_ENABLED: "UI_VSYNC_ON",
	DisplayServer.VSYNC_ADAPTIVE: "UI_VSYNC_ADAPTIVE",
}

const _low_latency_modes = {
	0: "UI_LOW_LATENCY_OFF",
	1: "UI_LOW_LATENCY_ENABLED",
	2: "UI_LOW_LATENCY_ENABLED_BOOST",
}

const _hdr_modes = {
	0: "UI_HDR_OFF",
	1: "UI_HDR_ON",
}

const _quality_levels = {
	0: "UI_QUALITY_LOW",
	1: "UI_QUALITY_MEDIUM",
	2: "UI_QUALITY_HIGH",
}

const _colorblind_modes = {
	0: "UI_COLORBLIND_OFF",
	1: "UI_COLORBLIND_PROTANOPIA",
	2: "UI_COLORBLIND_DEUTERANOPIA",
	3: "UI_COLORBLIND_TRITANOPIA",
}

const _ui_scale_presets = {
	"small": "UI_SCALE_SMALL",
	"medium": "UI_SCALE_MEDIUM",
	"large": "UI_SCALE_LARGE",
}


func _ready() -> void:
	# Conecta os botões de categoria.
	video_button.pressed.connect(func(): _show_panel(video_settings_panel, video_label))
	audio_button.pressed.connect(func(): _show_panel(audio_settings_panel, audio_label))
	language_button.pressed.connect(func(): _show_panel(language_settings_panel, language_label))

	# Popula os botões de opção
	_populate_language_buttons()
	_populate_video_buttons()

	# Conecta os sinais dos outros controles.
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	
	monitor_option_button.item_selected.connect(_on_monitor_selected)
	window_mode_option_button.item_selected.connect(_on_window_mode_selected)
	resolution_option_button.item_selected.connect(_on_resolution_selected)
	
	# NOVAS CONEXÕES DE SINAL DE VÍDEO
	field_of_view_slider.value_changed.connect(_on_field_of_view_changed)
	aspect_ratio_option_button.item_selected.connect(_on_aspect_ratio_selected)
	dynamic_render_scale_option_button.item_selected.connect(_on_dynamic_render_scale_selected)
	render_scale_slider.value_changed.connect(_on_render_scale_changed)
	frame_rate_limit_option_button.item_selected.connect(_on_frame_rate_limit_selected)
	max_frame_rate_slider.value_changed.connect(_on_max_frame_rate_changed)
	vsync_option_button.item_selected.connect(_on_vsync_mode_selected)
	triple_buffering_check_box.toggled.connect(_on_triple_buffering_toggled)
	reduce_buffering_check_box.toggled.connect(_on_reduce_buffering_toggled)
	low_latency_mode_option_button.item_selected.connect(_on_low_latency_mode_selected)
	gamma_correction_slider.value_changed.connect(_on_gamma_correction_changed)
	contrast_slider.value_changed.connect(_on_contrast_changed)
	brightness_slider.value_changed.connect(_on_brightness_changed)
	hdr_option_button.item_selected.connect(_on_hdr_mode_selected)
	hdr_calibration_button.pressed.connect(_on_hdr_calibration_button_pressed)
	shaders_quality_option_button.item_selected.connect(_on_shaders_quality_selected)
	effects_quality_option_button.item_selected.connect(_on_effects_quality_selected)
	colorblind_mode_option_button.item_selected.connect(_on_colorblind_mode_selected)
	reduce_screen_shake_check_box.toggled.connect(_on_reduce_screen_shake_toggled)
	ui_scale_option_button.item_selected.connect(_on_ui_scale_selected) # Nova conexão
	
	apply_button.pressed.connect(_on_apply_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	# Conecta-se aos sinais globais.
	GlobalEvents.settings_loaded.connect(_on_settings_loaded)
	GlobalEvents.game_state_changed.connect(_on_game_state_changed)

	# Adiciona sons de hover.
	for button in [video_button, audio_button, language_button, apply_button, back_button, hdr_calibration_button]:
		button.mouse_entered.connect(_on_mouse_entered_interactive_element)
	for slider in [master_slider, music_slider, sfx_slider, field_of_view_slider, render_scale_slider, max_frame_rate_slider, gamma_correction_slider, contrast_slider, brightness_slider]:
		slider.mouse_entered.connect(_on_mouse_entered_interactive_element)
	for option_btn in [monitor_option_button, window_mode_option_button, resolution_option_button, aspect_ratio_option_button, dynamic_render_scale_option_button, frame_rate_limit_option_button, vsync_option_button, low_latency_mode_option_button, hdr_option_button, shaders_quality_option_button, effects_quality_option_button, colorblind_mode_option_button, ui_scale_option_button]:
		option_btn.mouse_entered.connect(_on_mouse_entered_interactive_element)
	for check_box in [triple_buffering_check_box, reduce_buffering_check_box, reduce_screen_shake_check_box]:
		check_box.mouse_entered.connect(_on_mouse_entered_interactive_element)


	# Pede para o SettingsManager nos enviar os dados atuais.
	if SettingsManager and SettingsManager.settings:
		_on_settings_loaded(SettingsManager.settings)
	
	# Garante que o painel de vídeo seja o primeiro a ser exibido.
	_show_panel(video_settings_panel, video_label)

func _exit_tree():
	GlobalEvents.settings_loaded.disconnect(_on_settings_loaded)
	GlobalEvents.game_state_changed.disconnect(_on_game_state_changed)


# --- Funções de População de Botões ---

func _populate_language_buttons():
	for locale_code in _locales:
		var button = Button.new()
		button.text = _locales[locale_code]
		button.name = locale_code # Usa o código como nome para fácil identificação
		button.pressed.connect(_on_language_button_pressed.bind(locale_code))
		button.mouse_entered.connect(_on_mouse_entered_interactive_element)
		language_options_container.add_child(button)

func _populate_video_buttons():
	# Monitores
	monitor_option_button.clear()
	var display_options = SettingsManager.get_display_options()
	for i in range(display_options.monitors.size()):
		monitor_option_button.add_item("Monitor " + str(i + 1), i)

	# Modo de Janela
	window_mode_option_button.clear()
	for mode_enum in _window_modes:
		window_mode_option_button.add_item(_window_modes[mode_enum], mode_enum)

	# Resoluções (inicialmente populado para o monitor 0)
	_update_resolution_options(0)

	# Aspect Ratio
	aspect_ratio_option_button.clear()
	for ratio_enum in _aspect_ratios:
		aspect_ratio_option_button.add_item(_aspect_ratios[ratio_enum], ratio_enum)

	# Dynamic Render Scale
	dynamic_render_scale_option_button.clear()
	for mode_enum in _dynamic_render_scale_modes:
		dynamic_render_scale_option_button.add_item(_dynamic_render_scale_modes[mode_enum], mode_enum)

	# Frame Rate Limit
	frame_rate_limit_option_button.clear()
	for limit_enum in _frame_rate_limits:
		frame_rate_limit_option_button.add_item(_frame_rate_limits[limit_enum], limit_enum)

	# VSync
	vsync_option_button.clear()
	for mode_enum in _vsync_modes:
		vsync_option_button.add_item(_vsync_modes[mode_enum], mode_enum)

	# Low Latency Mode
	low_latency_mode_option_button.clear()
	for mode_enum in _low_latency_modes:
		low_latency_mode_option_button.add_item(_low_latency_modes[mode_enum], mode_enum)

	# HDR
	hdr_option_button.clear()
	for mode_enum in _hdr_modes:
		hdr_option_button.add_item(_hdr_modes[mode_enum], mode_enum)

	# Shaders Quality
	shaders_quality_option_button.clear()
	for level_enum in _quality_levels:
		shaders_quality_option_button.add_item(_quality_levels[level_enum], level_enum)

	# Effects Quality
	effects_quality_option_button.clear()
	for level_enum in _quality_levels:
		effects_quality_option_button.add_item(_quality_levels[level_enum], level_enum)

	# Colorblind Mode
	colorblind_mode_option_button.clear()
	for mode_enum in _colorblind_modes:
		colorblind_mode_option_button.add_item(_colorblind_modes[mode_enum], mode_enum)

	# UI Scale
	ui_scale_option_button.clear()
	for preset_key in _ui_scale_presets:
		ui_scale_option_button.add_item(_ui_scale_presets[preset_key], ui_scale_option_button.get_item_count())
		ui_scale_option_button.set_item_metadata(ui_scale_option_button.get_item_count() - 1, preset_key)


func _update_resolution_options(monitor_index: int):
	resolution_option_button.clear()
	var display_options = SettingsManager.get_display_options()
	if monitor_index < display_options.monitors.size():
		var resolutions = display_options.monitors[monitor_index].resolutions
		for res_vec in resolutions:
			var res_text = "%dx%d" % [res_vec.x, res_vec.y]
			resolution_option_button.add_item(res_text)
			resolution_option_button.set_item_metadata(resolution_option_button.get_item_count() - 1, res_vec)


# --- Handlers dos Botões de Categoria ---

func _show_panel(panel_to_show: VBoxContainer, label_to_show: Label) -> void:
	GlobalEvents.play_sfx_by_key_requested.emit("ui_click")
	# Esconde todos os painéis de conteúdo
	for child in $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent.get_children():
		if child is VBoxContainer:
			child.visible = (child == panel_to_show)
	# Esconde todos os labels de categoria no UPButtons
	for label_child in $PanelContainer/Margin/Box/UPButtons/LabelContainer.get_children():
		if label_child is Label:
			label_child.visible = (label_child == label_to_show)


# --- Handlers de Sinais da UI (Emitem Sinais Globais) ---

func _on_master_volume_changed(value: float):
	GlobalEvents.audio_setting_changed.emit("Master", value)

func _on_music_volume_changed(value: float):
	GlobalEvents.audio_setting_changed.emit("Music", value)

func _on_sfx_volume_changed(value: float):
	GlobalEvents.audio_setting_changed.emit("SFX", value)

func _on_monitor_selected(index: int):
	var monitor_id = monitor_option_button.get_item_id(index)
	GlobalEvents.monitor_changed.emit(monitor_id)
	_update_resolution_options(monitor_id)

func _on_window_mode_selected(index: int):
	var mode_id = window_mode_option_button.get_item_id(index)
	GlobalEvents.video_window_mode_changed.emit(mode_id) # Corrigido o nome do sinal
	# Desabilita o botão de resolução se não estiver em tela cheia
	resolution_option_button.disabled = (mode_id != DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_resolution_selected(index: int):
	var resolution_vec = resolution_option_button.get_item_metadata(index)
	GlobalEvents.resolution_changed.emit(resolution_vec)

func _on_field_of_view_changed(value: float) -> void:
	GlobalEvents.field_of_view_changed.emit(value)

func _on_aspect_ratio_selected(index: int) -> void:
	var ratio_id = aspect_ratio_option_button.get_item_id(index)
	GlobalEvents.aspect_ratio_changed.emit(ratio_id)

func _on_dynamic_render_scale_selected(index: int) -> void:
	var mode_id = dynamic_render_scale_option_button.get_item_id(index)
	GlobalEvents.dynamic_render_scale_changed.emit(mode_id)
	render_scale_slider.visible = (mode_id == 1)
	render_scale_slider.get_parent().get_node("RenderScaleLabel").visible = (mode_id == 1)

func _on_render_scale_changed(value: float) -> void:
	GlobalEvents.render_scale_changed.emit(value)

func _on_frame_rate_limit_selected(index: int) -> void:
	var mode_id = frame_rate_limit_option_button.get_item_id(index)
	GlobalEvents.frame_rate_limit_changed.emit(mode_id)
	max_frame_rate_slider.visible = (mode_id == 0)
	max_frame_rate_slider.get_parent().get_node("MaxFrameRateLabel").visible = (mode_id == 0)

func _on_max_frame_rate_changed(value: float) -> void:
	GlobalEvents.max_frame_rate_changed.emit(int(value))

func _on_vsync_mode_selected(index: int) -> void:
	var mode_id = vsync_option_button.get_item_id(index)
	GlobalEvents.vsync_mode_changed.emit(mode_id)

func _on_triple_buffering_toggled(button_pressed: bool) -> void:
	GlobalEvents.triple_buffering_changed.emit(button_pressed)

func _on_reduce_buffering_toggled(button_pressed: bool) -> void:
	GlobalEvents.reduce_buffering_changed.emit(button_pressed)

func _on_low_latency_mode_selected(index: int) -> void:
	var mode_id = low_latency_mode_option_button.get_item_id(index)
	GlobalEvents.low_latency_mode_changed.emit(mode_id)

func _on_gamma_correction_changed(value: float) -> void:
	GlobalEvents.gamma_correction_changed.emit(value)

func _on_contrast_changed(value: float) -> void:
	GlobalEvents.contrast_changed.emit(value)

func _on_brightness_changed(value: float) -> void:
	GlobalEvents.brightness_changed.emit(value)

func _on_hdr_mode_selected(index: int) -> void:
	var mode_id = hdr_option_button.get_item_id(index)
	GlobalEvents.hdr_mode_changed.emit(mode_id)

func _on_hdr_calibration_button_pressed() -> void:
	GlobalEvents.play_sfx_by_key_requested.emit("ui_click")
	print("HDR Calibration button pressed (placeholder).")

func _on_shaders_quality_selected(index: int) -> void:
	var quality_id = shaders_quality_option_button.get_item_id(index)
	GlobalEvents.shaders_quality_changed.emit(quality_id)

func _on_effects_quality_selected(index: int) -> void:
	var quality_id = effects_quality_option_button.get_item_id(index)
	GlobalEvents.effects_quality_changed.emit(quality_id)

func _on_colorblind_mode_selected(index: int) -> void:
	var mode_id = colorblind_mode_option_button.get_item_id(index)
	GlobalEvents.colorblind_mode_changed.emit(mode_id)

func _on_reduce_screen_shake_toggled(button_pressed: bool) -> void:
	GlobalEvents.reduce_screen_shake_changed.emit(button_pressed)

func _on_ui_scale_selected(index: int) -> void:
	var preset_key = ui_scale_option_button.get_item_metadata(index)
	GlobalEvents.ui_scale_preset_changed.emit(preset_key)

func _on_language_button_pressed(locale_code: String):
	GlobalEvents.play_sfx_by_key_requested.emit("ui_click")
	GlobalEvents.locale_setting_changed.emit(locale_code)
	_update_language_buttons(locale_code)

func _on_apply_button_pressed() -> void:
	GlobalEvents.play_sfx_by_key_requested.emit("ui_click")
	GlobalEvents.save_settings_requested.emit()
	print("Solicitação para salvar configurações enviada.")

func _on_back_button_pressed() -> void:
	GlobalEvents.play_sfx_by_key_requested.emit("ui_click")
	GlobalEvents.load_settings_requested.emit() # Descarta mudanças não salvas
	GlobalEvents.return_to_previous_state_requested.emit()

func _on_mouse_entered_interactive_element():
	GlobalEvents.play_sfx_by_key_requested.emit("ui_rollover")


# --- Handlers de Sinais Globais ---

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	visible = (new_state == GameManager.GameState.SETTINGS)

func _on_settings_loaded(settings_data: Dictionary) -> void:
	# Áudio
	master_slider.value = settings_data.get("master_volume", 1.0)
	music_slider.value = settings_data.get("music_volume", 1.0)
	sfx_slider.value = settings_data.get("sfx_volume", 1.0)
	
	# Idioma
	var current_locale = settings_data.get("locale", "pt_BR")
	_update_language_buttons(current_locale)
	
	# Vídeo
	var monitor_index = settings_data.get("monitor_index", 0)
	if monitor_option_button.get_item_index(monitor_index) != -1:
		monitor_option_button.select(monitor_option_button.get_item_index(monitor_index))
	
	var window_mode = settings_data.get("window_mode", DisplayServer.WINDOW_MODE_WINDOWED)
	if window_mode_option_button.get_item_index(window_mode) != -1:
		window_mode_option_button.select(window_mode_option_button.get_item_index(window_mode))
	resolution_option_button.disabled = (window_mode != DisplayServer.WINDOW_MODE_FULLSCREEN)

	_update_resolution_options(monitor_index)
	var res_dict = settings_data.get("resolution", {"x": 1920, "y": 1080})
	var current_res = Vector2i(res_dict.x, res_dict.y)
	for i in range(resolution_option_button.get_item_count()):
		if resolution_option_button.get_item_metadata(i) == current_res:
			resolution_option_button.select(i)
			break
	
	# NOVAS CONFIGURAÇÕES DE VÍDEO
	field_of_view_slider.value = settings_data.get("field_of_view", field_of_view_slider.min_value)
	
	var aspect_ratio_mode = settings_data.get("aspect_ratio", 0)
	if aspect_ratio_option_button.get_item_index(aspect_ratio_mode) != -1:
		aspect_ratio_option_button.select(aspect_ratio_option_button.get_item_index(aspect_ratio_mode))

	var dynamic_render_scale_mode = settings_data.get("dynamic_render_scale_mode", 0)
	if dynamic_render_scale_option_button.get_item_index(dynamic_render_scale_mode) != -1:
		dynamic_render_scale_option_button.select(dynamic_render_scale_option_button.get_item_index(dynamic_render_scale_mode))
	render_scale_slider.visible = (dynamic_render_scale_mode == 1)
	render_scale_slider.get_parent().get_node("RenderScaleLabel").visible = (dynamic_render_scale_mode == 1)
	render_scale_slider.value = settings_data.get("render_scale", 1.0)

	var frame_rate_limit_mode = settings_data.get("frame_rate_limit_mode", 0)
	if frame_rate_limit_option_button.get_item_index(frame_rate_limit_mode) != -1:
		frame_rate_limit_option_button.select(frame_rate_limit_option_button.get_item_index(frame_rate_limit_mode))
	max_frame_rate_slider.visible = (frame_rate_limit_mode == 0)
	max_frame_rate_slider.get_parent().get_node("MaxFrameRateLabel").visible = (frame_rate_limit_mode == 0)
	max_frame_rate_slider.value = settings_data.get("max_frame_rate", 60)

	var vsync_mode = settings_data.get("vsync_mode", DisplayServer.VSYNC_ENABLED)
	if vsync_option_button.get_item_index(vsync_mode) != -1:
		vsync_option_button.select(vsync_option_button.get_item_index(vsync_mode))

	triple_buffering_check_box.button_pressed = settings_data.get("triple_buffering", false)
	reduce_buffering_check_box.button_pressed = settings_data.get("reduce_buffering", false)

	var low_latency_mode = settings_data.get("low_latency_mode", 0)
	if low_latency_mode_option_button.get_item_index(low_latency_mode) != -1:
		low_latency_mode_option_button.select(low_latency_mode_option_button.get_item_index(low_latency_mode))

	gamma_correction_slider.value = settings_data.get("gamma_correction", 2.2)
	contrast_slider.value = settings_data.get("contrast", 1.0)
	brightness_slider.value = settings_data.get("brightness", 1.0)

	var hdr_mode = settings_data.get("hdr_mode", 0)
	if hdr_option_button.get_item_index(hdr_mode) != -1:
		hdr_option_button.select(hdr_option_button.get_item_index(hdr_mode))

	var shaders_quality = settings_data.get("shaders_quality", 2)
	if shaders_quality_option_button.get_item_index(shaders_quality) != -1:
		shaders_quality_option_button.select(shaders_quality_option_button.get_item_index(shaders_quality))

	var effects_quality = settings_data.get("effects_quality", 2)
	if effects_quality_option_button.get_item_index(effects_quality) != -1:
		effects_quality_option_button.select(effects_quality_option_button.get_item_index(effects_quality))

	var colorblind_mode = settings_data.get("colorblind_mode", 0)
	if colorblind_mode_option_button.get_item_index(colorblind_mode) != -1:
		colorblind_mode_option_button.select(colorblind_mode_option_button.get_item_index(colorblind_mode))

	reduce_screen_shake_check_box.button_pressed = settings_data.get("reduce_screen_shake", false)

	var ui_scale_preset = settings_data.get("ui_scale_preset", "medium")
	for i in range(ui_scale_option_button.get_item_count()):
		if ui_scale_option_button.get_item_metadata(i) == ui_scale_preset:
			ui_scale_option_button.select(i)
			break
			
	print("UI de Configurações atualizada com os dados carregados.")

func _update_language_buttons(current_locale: String) -> void:
	for button in language_options_container.get_children():
		if button is Button:
			button.disabled = (button.name == current_locale)
