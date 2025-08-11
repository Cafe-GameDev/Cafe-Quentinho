extends State

func enter():
    owner.get_node("AnimatedSprite2D").play("run")

func physics_update(_delta: float):
    # Transition to Idle if not moving
    if Input.get_axis("move_left", "move_right") == 0:
        transition_requested.emit("Idle")
    # Transition to Jump if jumping
    if Input.is_action_just_pressed("jump"):
        transition_requested.emit("Jump")
