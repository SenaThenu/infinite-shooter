extends Area2D

var BULLET_SPEED = 0
var BULLET_STATE = null
var BULLET_VELOCITY = Vector2(0, 0) # direction of motion

@onready var bullet_skins_sprite = $BulletSkinsSprite

func _ready():
	if BULLET_STATE == "player_bullet":
		# changing the skin of the bullet to differentiate from enemy bullets
		bullet_skins_sprite.self_modulate = Color(1,1,1)
	elif BULLET_STATE == "tank_bullet_level_2":
		bullet_skins_sprite.frame = 2
	else:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x += delta * BULLET_VELOCITY.x
	position.y += delta * BULLET_VELOCITY.y
	
	# automatically deleting the bullet instance once it goes out of the screen
	var screen_size = get_viewport().size
	if global_position.y < 0 or global_position.y > screen_size.y:
		queue_free()
	elif global_position.x < 0 or global_position.x > screen_size.x:
		queue_free()
	else:
		pass

func set_bullet_speed(new_speed: int):
	BULLET_SPEED = new_speed
	
func set_bullet_state(state: String):
	BULLET_STATE = state

func set_bullet_direction(direction: Vector2):
	BULLET_VELOCITY = direction.normalized() * BULLET_SPEED

func set_bullet_rotation(new_rotation_in_degrees: float):
	rotation_degrees = new_rotation_in_degrees
