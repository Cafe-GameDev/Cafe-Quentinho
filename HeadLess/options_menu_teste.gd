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



func _on_video_button_pressed() -> void:
	pass # Replace with function body.


func _on_audio_button_pressed() -> void:
	pass # Replace with function body.


func _on_language_button_pressed() -> void:
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	pass # Replace with function body.


func _on_apply_button_pressed() -> void:
	pass # Replace with function body.
