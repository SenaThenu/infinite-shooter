extends CharacterBody2D

@export var SPEED: int = 500
@onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var screen_size: Vector2 = get_viewport().size
	
	if direction.x > 0:
		animation_player.play("right_yaw")
	elif direction.x < 0:
		animation_player.play("left_yaw")
	else:
		animation_player.play("RESET")
	
	velocity = direction * SPEED
	position = position.clamp(Vector2.ZERO, screen_size)
	
	move_and_slide()
