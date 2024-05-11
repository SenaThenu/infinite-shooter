extends Area2D

var BULLET_SPEED = 0	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.y -= BULLET_SPEED * delta
	if position.y < 0:
		queue_free()

func set_bullet_speed(new_speed):
	BULLET_SPEED = new_speed
