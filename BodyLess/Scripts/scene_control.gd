extends Node

# O SceneControl é o maestro da UI e das cenas.
# Ele ouve as mudanças de estado da GlobalMachine e atualiza a cena visível.
# Ele também gerencia o carregamento e descarregamento de cenas de jogo.

@onready var main_menu: Control = $CanvasLayer/MainMenu
@onready var options_menu: Control = $CanvasLayer/OptionsMenu
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var quit_dialog: PanelContainer = $CanvasLayer/QuitConfirmationDialog
@onready var game_viewport: SubViewport = $GameViewportContainer/GameViewport
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var colorblind_filter: ColorRect = $CanvasLayer/ColorblindFilter # Assumindo que existe um ColorRect para o filtro

var _current_game_scene: Node = null

func _ready() -> void:
	# Conecta-se ao sinal de mudança de estado para poder reagir.
	GlobalEvents.game_state_changed.connect(_on_game_state_changed)
	# Conecta-se a sinais de gerenciamento de cena.
	GlobalEvents.scene_changed.connect(_on_scene_changed)
	GlobalEvents.request_game_selection_scene.connect(_on_request_game_selection_scene)
	
	# Conexões para configurações de vídeo e idioma
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)
	GlobalEvents.setting_changed.connect(func(change_data: Dictionary): _on_setting_changed(change_data))
	GlobalEvents.language_changed.connect(func(change_data: Dictionary): _on_language_changed(change_data))

	# Garante que o estado inicial da UI esteja correto.
	_on_game_state_changed(GlobalMachine.State.keys()[GlobalMachine.current_state], GlobalMachine.State.keys()[GlobalMachine.current_state])

	# Solicita o carregamento inicial das configurações para que o SceneControl possa aplicá-las
	GlobalEvents.request_loading_settings_changed.emit()


# A função central que controla qual UI está visível.
func _on_game_state_changed(new_state: String, _old_state: String) -> void:
	# Esconde todas as UIs de sobreposição por padrão.
	options_menu.visible = false
	pause_menu.visible = false
	quit_dialog.visible = false
	
	# Mostra a UI correta com base no novo estado.
	match new_state:
		"MENU":
			main_menu.visible = true
		"PLAYING":
			main_menu.visible = false
		"PAUSED":
			pause_menu.visible = true
		"SETTINGS":
			options_menu.visible = true
		"QUIT_CONFIRMATION":
			quit_dialog.visible = true


# Gerencia a troca de cenas de "nível" ou "mundo".
func _on_scene_changed(scene_path: String) -> void:
	# Se já houver uma cena de jogo, remove-a.
	if _current_game_scene:
		_current_game_scene.queue_free()
		_current_game_scene = null

	# Se o caminho for vazio, estamos apenas voltando para o menu.
	if scene_path.is_empty():
		return

	# Carrega e instancia a nova cena como filha do viewport.
	var scene_resource: PackedScene = load(scene_path)
	if scene_resource:
		_current_game_scene = scene_resource.instantiate()
		game_viewport.add_child(_current_game_scene)
	else:
		printerr("SceneControl: Falha ao carregar a cena em: %s" % scene_path)


# ==============================================================================
# Lógica de Aplicação de Configurações (Vídeo e Idioma)
# ==============================================================================

func _on_loading_settings_changed(settings: Dictionary) -> void:
	# Aplica todas as configurações de vídeo e idioma quando elas são carregadas inicialmente.
	if settings.has("video"):
		var video_settings = settings["video"]
		_apply_monitor_index(video_settings.get("monitor_index", 0))
		_apply_window_mode(video_settings.get("window_mode", DisplayServer.WINDOW_MODE_WINDOWED))
		_apply_resolution(video_settings.get("resolution", Vector2i(1920, 1080)))
		_apply_aspect_ratio(video_settings.get("aspect_ratio", 0))
		_apply_upscaling_mode(video_settings.get("upscaling_mode", 0), video_settings.get("upscaling_quality", 2))
		_apply_frame_rate_limit_mode(video_settings.get("frame_rate_limit_mode", 0))
		_apply_max_frame_rate(video_settings.get("max_frame_rate", 60))
		_apply_vsync_mode(video_settings.get("vsync_mode", DisplayServer.VSYNC_ENABLED))
		_apply_gamma_correction(video_settings.get("gamma_correction", 2.2))
		_apply_contrast(video_settings.get("contrast", 1.0))
		_apply_brightness(video_settings.get("brightness", 1.0))
		_apply_shaders_quality(video_settings.get("shaders_quality", 2))
		_apply_effects_quality(video_settings.get("effects_quality", 2))
		_apply_colorblind_mode(video_settings.get("colorblind_mode", 0))
		_apply_reduce_screen_shake(video_settings.get("reduce_screen_shake", false))
		_apply_ui_scale(video_settings.get("ui_scale", 1.0))


func _on_setting_changed(change_data: Dictionary) -> void:
	# Aplica uma configuração de vídeo específica quando ela é alterada.
	if change_data.has("video"):
		var video_changes = change_data["video"]
		for key in video_changes:
			var value = video_changes[key]
			match key:
				"monitor_index": call_deferred("_apply_monitor_index", value)
				"window_mode": call_deferred("_apply_window_mode", value)
				"resolution": call_deferred("_apply_resolution", value)
				"aspect_ratio": call_deferred("_apply_aspect_ratio", value)
				"upscaling_mode": call_deferred("_apply_upscaling_mode", value, video_changes.get("upscaling_quality", 2)) # Passa a qualidade também
				"upscaling_quality": call_deferred("_apply_upscaling_mode", video_changes.get("upscaling_mode", 0), value) # Chama com o modo atual e a nova qualidade
				"frame_rate_limit_mode": call_deferred("_apply_frame_rate_limit_mode", value)
				"max_frame_rate": call_deferred("_apply_max_frame_rate", value)
				"vsync_mode": call_deferred("_apply_vsync_mode", value)
				"gamma_correction": call_deferred("_apply_gamma_correction", value)
				"contrast": call_deferred("_apply_contrast", value)
				"brightness": call_deferred("_apply_brightness", value)
				"shaders_quality": call_deferred("_apply_shaders_quality", value)
				"effects_quality": call_deferred("_apply_effects_quality", value)
				"colorblind_mode": call_deferred("_apply_colorblind_mode", value)
				"reduce_screen_shake": call_deferred("_apply_reduce_screen_shake", value)
				"ui_scale": call_deferred("_apply_ui_scale", value)


func _on_language_changed(change_data: Dictionary) -> void:
	# Aplica a mudança de idioma em tempo real.
	if change_data.has("language") and change_data.language.has("locale"):
		TranslationServer.set_locale(change_data.language.locale)


func _apply_monitor_index(monitor_index: int) -> void:
	DisplayServer.window_set_current_screen(monitor_index)


func _apply_window_mode(new_mode: int) -> void:
	DisplayServer.window_set_mode(new_mode)


func _apply_resolution(new_resolution: Vector2i) -> void:
	game_viewport.size = new_resolution # Ajusta o tamanho do viewport do jogo


func _apply_aspect_ratio(aspect_ratio_index: int) -> void:
	# Mapeia o índice para o modo de aspecto correspondente.
	var aspect_mode: int
	match aspect_ratio_index:
		0: aspect_mode = Window.CONTENT_SCALE_ASPECT_IGNORE # Free
		1: aspect_mode = Window.CONTENT_SCALE_ASPECT_KEEP # Keep
		2: aspect_mode = Window.CONTENT_SCALE_ASPECT_KEEP_WIDTH # Keep Width
		3: aspect_mode = Window.CONTENT_SCALE_ASPECT_KEEP_HEIGHT # Keep Height
		4: aspect_mode = Window.CONTENT_SCALE_ASPECT_EXPAND # Expand
		_:
			printerr("SceneControl: Modo de aspecto inválido: %s" % aspect_ratio_index)
			return
	ProjectSettings.set_setting("display/window/stretch/aspect", aspect_mode)


func _apply_upscaling_mode(mode: int, quality: int) -> void:
	# Mapeamento de qualidade FSR para escala de renderização 3D
	const FSR_SCALES = [
		0.77, # Ultra Quality
		0.67, # Quality
		0.59, # Balanced
		0.50, # Performance
		0.42  # Ultra Performance
	]

	# Aplica o modo de upscaling (FSR, etc.).
	ProjectSettings.set_setting("rendering/scaling_3d/mode", mode)
	ProjectSettings.set_setting("rendering/scaling_3d/scale", FSR_SCALES[quality])
	_update_fsr_sharpness(quality) # Atualiza a nitidez baseada na qualidade

func _update_fsr_sharpness(quality: int) -> void:
	# Ajusta a nitidez do FSR com base na qualidade selecionada.
	# Estes valores são exemplos e podem precisar de ajuste fino.
	const FSR_SHARPNESS_VALUES = [
		0.2, # Ultra Quality (menos nitidez, mais próximo do original)
		0.3, # Quality
		0.5, # Balanced
		0.7, # Performance
		0.9  # Ultra Performance (mais nitidez para compensar a escala agressiva)
	]
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/fsr_sharpness", FSR_SHARPNESS_VALUES[quality])


func _apply_frame_rate_limit_mode(mode: int) -> void:
	# 0: No Limit, 1: VSync, 2: Adaptive VSync, 3: Custom
	match mode:
		0: Engine.max_fps = 0 # No limit
		1: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		2: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
		3: pass # Custom max_frame_rate will be applied separately


func _apply_max_frame_rate(fps_value: int) -> void:
	Engine.max_fps = fps_value


func _apply_vsync_mode(mode: int) -> void:
	DisplayServer.window_set_vsync_mode(mode)


func _apply_gamma_correction(gamma_value: float) -> void:
	# Ajusta o valor V (Value) do HSV para controlar o brilho/gama.
	# O valor padrão de gamma é 2.2. Um valor de 1.0 significa sem correção.
	# Mapeamos o slider (ex: 1.0 a 3.0) para um ajuste visual.
	# Isso é uma simplificação; um shader seria mais preciso.
	var normalized_gamma = (gamma_value - 1.0) / 2.0 # Normaliza para 0-1 (se slider for 1-3)
	canvas_modulate.color = Color(1, 1, 1, 1).from_hsv(0, 0, 1.0 + (normalized_gamma * 0.5)) # Ajuste visual


func _apply_contrast(contrast_value: float) -> void:
	# Ajusta o contraste usando o CanvasModulate.
	# Isso é uma simplificação; um shader seria mais preciso.
	canvas_modulate.color = canvas_modulate.color.lerp(Color(0.5, 0.5, 0.5, 1.0), 1.0 - contrast_value)


func _apply_brightness(brightness_value: float) -> void:
	# Ajusta o brilho usando o CanvasModulate.
	# Isso é uma simplificação; um shader seria mais preciso.
	canvas_modulate.color = canvas_modulate.color.lerp(Color(0, 0, 0, 1), 1.0 - brightness_value)


func _apply_shaders_quality(quality_level: int) -> void:
	# Define a qualidade dos shaders.
	ProjectSettings.set_setting("rendering/quality/shader_quality", quality_level)


func _apply_effects_quality(quality_level: int) -> void:
	# Define a qualidade dos efeitos.
	match quality_level:
		0: # Baixa
			ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_filter", 0) # Nearest
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 0) # MSAA Off
		1: # Média
			ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_filter", 1) # Linear
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 1) # MSAA 2x
		2: # Alta
			ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_filter", 2) # Bilinear
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 2) # MSAA 4x


func _apply_colorblind_mode(mode: int) -> void:
	# Ativa/desativa e configura um shader de correção de daltonismo.
	if colorblind_filter and colorblind_filter.material is ShaderMaterial:
		var shader_material: ShaderMaterial = colorblind_filter.material
		match mode:
			0: # Nenhum
				colorblind_filter.visible = false
			1: # Protanopia
				colorblind_filter.visible = true
				shader_material.set_shader_parameter("colorblind_type", 0) # Exemplo: 0 para Protanopia
			2: # Deuteranopia
				colorblind_filter.visible = true
				shader_material.set_shader_parameter("colorblind_type", 1) # Exemplo: 1 para Deuteranopia
			3: # Tritanopia
				colorblind_filter.visible = true
				shader_material.set_shader_parameter("colorblind_type", 2) # Exemplo: 2 para Tritanopia
	else:
		printerr("SceneControl: ColorblindFilter ou ShaderMaterial não encontrado/configurado corretamente.")


func _apply_reduce_screen_shake(enabled: bool) -> void:
	# Define uma flag global para reduzir tremores de tela.
	ProjectSettings.set_setting("game/camera/reduce_screen_shake", enabled)


func _apply_ui_scale(scale_value: float) -> void:
	# Ajusta a escala do CanvasLayer ou de elementos da UI.
	# Isso pode ser feito ajustando a propriedade 'scale' do CanvasLayer ou de um nó pai da UI.
	# Por enquanto, apenas um placeholder.
	$CanvasLayer.set_scale(Vector2(scale_value, scale_value))


func _on_request_game_selection_scene() -> void:
	# Libera a cena de jogo atual, se houver.
	if _current_game_scene:
		_current_game_scene.queue_free()
		_current_game_scene = null

	# Altera o estado do jogo para o menu principal.
	GlobalEvents.request_game_state_change.emit(GlobalMachine.State.MENU)
	# Garante que o menu principal esteja visível.
	main_menu.visible = true