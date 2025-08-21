extends CharacterBody2D

const SPEED = 100.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()

func _ready() -> void:
	print("TopDown Player Loaded!")
	var camera = Camera2D.new()
	add_child(camera)
	camera.make_current()