extends Node3D

var current_camera_mode: String = "first_person" # "first_person" or "third_person"
@onready var first_person_camera: Camera3D = %FirstPersonCamera
@onready var third_person_camera: Camera3D = %ThirdPersonCamera

func _ready() -> void:
	print("3D World Loaded!")
	_set_camera_mode(current_camera_mode)
	GlobalEvents.input_action_triggered.connect(_on_input_action_triggered)

func _on_input_action_triggered(action_data: Dictionary) -> void:
	if action_data.get("action") == "special" and action_data.get("state") == "pressed":
		if current_camera_mode == "first_person":
			_set_camera_mode("third_person")
		else:
			_set_camera_mode("first_person")

func _set_camera_mode(mode: String) -> void:
	current_camera_mode = mode
	if mode == "first_person":
		first_person_camera.current = true
		third_person_camera.current = false
		print("Camera Mode: First Person")
	elif mode == "third_person":
		first_person_camera.current = false
		third_person_camera.current = true
		print("Camera Mode: Third Person")