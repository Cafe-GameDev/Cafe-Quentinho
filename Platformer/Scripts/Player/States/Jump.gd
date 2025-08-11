extends State

func enter():
    owner.get_node("AnimatedSprite2D").play("jump")

func physics_update(_delta: float):
    # Transition to Idle/Run when landing
    if owner.is_on_floor():
        if Input.get_axis("move_left", "move_right") != 0:
            transition_requested.emit("Run")
        else:
            transition_requested.emit("Idle")
