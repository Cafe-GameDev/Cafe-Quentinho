extends Control

func _ready() -> void:
	$VBoxContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/SettingsButton.pressed.connect(_on_settings_button_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed() -> void:
	SceneManager.change_scene_to_file("res://Scenes/Levels/game.tscn")

func _on_settings_button_pressed() -> void:
	SceneManager.change_scene_to_file("res://Scenes/UI/menu_settings.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
