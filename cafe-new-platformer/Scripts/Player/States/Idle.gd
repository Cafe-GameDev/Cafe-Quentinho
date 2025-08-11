extends State

func enter():
    # Assuming AnimatedSprite2D is a child of the owner (Player)
    owner.get_node("AnimatedSprite2D").play("idle")

func physics_update(_delta: float):
    # Transition to Run if moving
    if Input.get_axis("move_left", "move_right") != 0:
        transition_requested.emit("Run")
    # Transition to Jump if jumping
    if Input.is_action_just_pressed("jump"):
        transition_requested.emit("Jump")
