extends Area2D

var BULLET_SPEED = 0
var BULLET_STATE = null
var BULLET_VELOCITY = Vector2(0, 0) # direction of motion

@onready var sprite_2d = $Sprite2D

func _ready():
	if BULLET_STATE == "player_bullet":
		# changing the skin of the bullet to differentiate from enemy bullets
		sprite_2d.self_modulate = Color(1,1,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x += delta * BULLET_VELOCITY.x
	position.y += delta * BULLET_VELOCITY.y
	if position.y < 0:
		queue_free()

func set_bullet_speed(new_speed: int):
	BULLET_SPEED = new_speed
	
func set_bullet_state(state: String):
	BULLET_STATE = state

func set_bullet_direction(direction: Vector2):
	BULLET_VELOCITY = direction.normalized() * BULLET_SPEED
