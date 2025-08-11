extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Panel/VBoxContainer/ResumeButton.pressed.connect(_on_resume_button_pressed)
	$Panel/VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # Geralmente a tecla Esc
		if get_tree().paused:
			_on_resume_button_pressed()
		else:
			get_tree().paused = true
			show()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_scene_to_file("res://Scenes/UI/main_menu.tscn")
