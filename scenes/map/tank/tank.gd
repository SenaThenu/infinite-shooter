extends Area2D

var TANK_MODEL = "red" # either red or green
var TANK_LEVEL = 1 # if the model is red, there's a second level
var TANK_PROPS = {
	"red": {
		"1": {
			"attack_range_radius": 190,
			"ammo_load_time": 0.7,
		},
		"2": {
			"attack_range_radius": 170,
			"ammo_load_time": 0.5,
			"distance_to_guns_from_center": 30,
		}
	},
	"green": {
		"1": {
			"attack_range_radius": 150,	
			"ammo_load_time": 0.9,
		}
	}
}

var PLAYER_INSIDE_ATTACK_RANGE = false
var CAN_FIRE = true
var AMMO_LOAD_TIME = null
var PAUSE_TILL_NEXT_FIRE = 0

@onready var attack_range = $AttackRange/CollisionShape2D
@onready var head_spirte = $HeadSpirte
const BULLET_SCENE = preload("res://scenes/bullet/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(TANK_MODEL != null, "Please set the tank model using set_tank_model()")
	attack_range.shape.radius = TANK_PROPS[TANK_MODEL][str(TANK_LEVEL)]["attack_range_radius"]
	AMMO_LOAD_TIME = TANK_PROPS[TANK_MODEL][str(TANK_LEVEL)]["ammo_load_time"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if PLAYER_INSIDE_ATTACK_RANGE:
		handle_rotation(delta)

func handle_rotation(delta):
	# rotating the head of the tank
	var delta_x = global_position.x - GameManager.player_position.x
	var delta_y = global_position.y - GameManager.player_position.y
	var angle = rad_to_deg(atan2(abs(delta_y), abs(delta_x)))

	if delta_x > 0 and delta_y > 0:
		# second quadrant
		angle = 180 - angle
	elif delta_x > 0 and delta_y < 0:
		# third qudrant
		angle = 180 + angle
	elif delta_x < 0 and delta_y > 0:
		# first quadrant
		pass
	else:
		# forth quadrant
		angle = 360 - angle
	
	set_tank_rotation(angle)
	handle_firing(delta, angle)

func set_tank_rotation(angle):
	var rotation_shifter = 270 # rotation = 0 is downwards due to spritesheet
	head_spirte.rotation_degrees = rotation_shifter-angle

func handle_firing(delta, angle):
	if not CAN_FIRE:
		PAUSE_TILL_NEXT_FIRE -= delta
		if PAUSE_TILL_NEXT_FIRE <= 0:
			CAN_FIRE = true
			PAUSE_TILL_NEXT_FIRE = AMMO_LOAD_TIME
	else:
		# instantiating and spawning a bullet
		fire_bullet(angle)
		
func fire_bullet(angle):
	var rotation_shifter = 90 # rotation = 0 is upwards due to spritesheet
	var bullet_state = null
	if TANK_MODEL=="red" and TANK_LEVEL == 2:
		bullet_state = "tank_bullet_level_2"
	else:
		bullet_state = "tank_bullet_level_1"
	
	var new_bullet = BULLET_SCENE.instantiate()
	new_bullet.set_bullet_state(bullet_state)
	new_bullet.set_bullet_speed(1000)
	new_bullet.global_position = head_spirte.global_position
	new_bullet.set_bullet_rotation(rotation_shifter-angle)
	
	var direction_x = cos(deg_to_rad(angle))
	var direction_y = -sin(deg_to_rad(angle))
	print(direction_x, direction_y)
	print(head_spirte.global_position)
	new_bullet.set_bullet_direction(Vector2(direction_x, direction_y))

	get_parent().add_child(new_bullet)
	CAN_FIRE = false

func set_tank_model(model):
	TANK_MODEL = model

func set_tank_level(level):
	TANK_LEVEL = level

func _on_attack_range_body_entered(body):
	if body.is_in_group("player"):
		PLAYER_INSIDE_ATTACK_RANGE = true

func _on_attack_range_body_exited(body):
	if body.is_in_group("player"):
		PLAYER_INSIDE_ATTACK_RANGE = false
