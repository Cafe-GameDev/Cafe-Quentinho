extends Control

# --- Nós da UI ---
@onready var video_button: Button = $PanelContainer/MarginContainer/MainLayout/CategoryList/VideoButton
@onready var audio_button: Button = $PanelContainer/MarginContainer/MainLayout/CategoryList/AudioButton
@onready var language_button: Button = $PanelContainer/MarginContainer/MainLayout/CategoryList/LanguageButton
@onready var back_button: Button = $PanelContainer/MarginContainer/MainLayout/CategoryList/BackButton

@onready var video_settings_panel: VBoxContainer = $PanelContainer/MarginContainer/MainLayout/CategoryContent/VideoSettings
@onready var audio_settings_panel: VBoxContainer = $PanelContainer/MarginContainer/MainLayout/CategoryContent/AudioSettings
@onready var language_settings_panel: VBoxContainer = $PanelContainer/MarginContainer/MainLayout/CategoryContent/LanguageSettings
@onready var apply_button: Button = $PanelContainer/MarginContainer/MainLayout/CategoryContent/ApplyButton

# Controles Específicos
# Controles de Áudio
@onready var master_slider: HSlider = $PanelContainer/MarginContainer/MainLayout/CategoryContent/AudioSettings/MasterSlider
@onready var music_slider: HSlider = $PanelContainer/MarginContainer/MainLayout/CategoryContent/AudioSettings/MusicSlider
@onready var sfx_slider: HSlider = $PanelContainer/MarginContainer/MainLayout/CategoryContent/AudioSettings/SfxSlider
@onready var language_options_container: VBoxContainer = $PanelContainer/MarginContainer/MainLayout/CategoryContent/LanguageSettings/LanguageOptionsContainer

# Controles de Vídeo
@onready var monitor_option_button: OptionButton = $PanelContainer/MarginContainer/MainLayout/CategoryContent/VideoSettings/MonitorOptionButton
@onready var window_mode_option_button: OptionButton = $PanelContainer/MarginContainer/MainLayout/CategoryContent/VideoSettings/WindowModeOptionButton
@onready var resolution_option_button: OptionButton = $PanelContainer/MarginContainer/MainLayout/CategoryContent/VideoSettings/ResolutionOptionButton


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


func _ready() -> void:
	# Conecta os botões de categoria.
	video_button.pressed.connect(func(): _show_panel(video_settings_panel))
	audio_button.pressed.connect(func(): _show_panel(audio_settings_panel))
	language_button.pressed.connect(func(): _show_panel(language_settings_panel))

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
	
	apply_button.pressed.connect(_on_apply_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	# Conecta-se aos sinais globais.
	GlobalEvents.settings_loaded.connect(_on_settings_loaded)
	GlobalEvents.game_state_changed.connect(_on_game_state_changed)

	# Adiciona sons de hover.
	for button in [video_button, audio_button, language_button, apply_button, back_button]:
		button.mouse_entered.connect(_on_mouse_entered_interactive_element)
	for slider in [master_slider, music_slider, sfx_slider]:
		slider.mouse_entered.connect(_on_mouse_entered_interactive_element)
	for option_btn in [monitor_option_button, window_mode_option_button, resolution_option_button]:
		option_btn.mouse_entered.connect(_on_mouse_entered_interactive_element)


	# Pede para o SettingsManager nos enviar os dados atuais.
	if SettingsManager and SettingsManager.settings:
		_on_settings_loaded(SettingsManager.settings)
	
	# Garante que o painel de vídeo seja o primeiro a ser exibido.
	_show_panel(video_settings_panel)

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

func _show_panel(panel_to_show: VBoxContainer) -> void:
	GlobalEvents.play_sfx_by_key_requested.emit("ui_click")
	for child in $PanelContainer/MarginContainer/MainLayout/CategoryContent.get_children():
		if child is VBoxContainer:
			child.visible = (child == panel_to_show)


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
	GlobalEvents.window_mode_changed.emit(mode_id)
	# Desabilita o botão de resolução se não estiver em tela cheia
	resolution_option_button.disabled = (mode_id != DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_resolution_selected(index: int):
	var resolution_vec = resolution_option_button.get_item_metadata(index)
	GlobalEvents.resolution_changed.emit(resolution_vec)

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
			
	print("UI de Configurações atualizada com os dados carregados.")

func _update_language_buttons(current_locale: String) -> void:
	for button in language_options_container.get_children():
		if button is Button:
			button.disabled = (button.name == current_locale)
