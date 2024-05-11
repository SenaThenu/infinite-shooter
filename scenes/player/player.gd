extends CharacterBody2D

# Global variables
@export var SPEED: int = 500

const SPECS_FOR_EACH_LEVEL = {
	"1": {
		"damage_per_hit": 10,
		"ammo_load_time": 0.8, # in seconds
		"n_bullets_per_fire": 1, # from one side
		"bullet_speed": 200,
		"collision_range_radius": 30
	},
	"2": {
		"damage_per_hit": 20,
		"ammo_load_time": 0.6, # in seconds
		"n_bullets_per_fire": 1, # from one side
		"bullet_speed": 250,
		"collision_range_radius": 35
	},
	"3": {
		"damage_per_hit": 30,
		"ammo_load_time": 0.4, # in seconds
		"n_bullets_per_fire": 2, # from one side
		"bullet_speed": 300,
		"collision_range_radius": 45
	}
}
const RENDERING_SPECS_FOR_EACH_COLOR = {
	"blue": {
		"space_between_guns": 30,
		"distance_to_guns_from_center": 25, # the nearest end
		"latency_between_bullets": 15
	},
	"red": {
		"space_between_guns": 15,
		"distance_to_guns_from_center": 30, # the nearest end
		"latency_between_bullets": 0
	},
	"yellow": {
		"space_between_guns": 15,
		"distance_to_guns_from_center": 34, # the nearest end
		"latency_between_bullets": 0
	},
	"green": {
		"space_between_guns": 10,
		"distance_to_guns_from_center": 30, # the nearest end
		"latency_between_bullets": 0
	}
}

# Vars used in game logic
var HEALTH_POINTS = 5 # there are 5 lives by default
# firing related:
var CAN_FIRE = true
var PAUSE_TILL_NEXT_FIRE = 0
const BULLET_SCENE = preload("res://scenes/player/bullet/bullet.tscn")

# Scraped elements
@onready var animation_player = $AnimationPlayer
@onready var player = $"."
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.animation = GameManager.player_color
	animated_sprite_2d.frame = GameManager.player_level - 1

func _physics_process(delta):
	# Handle character movement
	var direction = handle_movement()
	
	# Handle character animations based on direction
	handle_animations(direction)
	
	handle_firing(delta)

func handle_movement():
	# Get input direction
	var direction = Vector2()
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	elif Input.is_action_pressed("move_left"):
		direction.x -= 1
	
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	elif Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	# Normalize direction and apply speed
	velocity = direction.normalized() * SPEED
	
	# Move the character
	move_and_slide()
	
	# clamping the character to the screen
	var screen_size: Vector2 = get_viewport().size
	position = position.clamp(Vector2.ZERO, screen_size)
	
	return direction

func handle_animations(direction):
	# Check horizontal movement for animations
	if direction.x > 0:
		animation_player.play("right_yaw")
	elif direction.x < 0:
		animation_player.play("left_yaw")
	else:
		animation_player.play("RESET")

func handle_firing(delta):
	if Input.is_action_just_pressed("fire") and CAN_FIRE:
		fire()
	
	if not CAN_FIRE:
		PAUSE_TILL_NEXT_FIRE -= delta
		if PAUSE_TILL_NEXT_FIRE <= 0:
			CAN_FIRE = true
			PAUSE_TILL_NEXT_FIRE = SPECS_FOR_EACH_LEVEL[str(GameManager.player_level)]["ammo_load_time"]
			
func fire():
	# spawning a bullet for each side of the plane (i will be either 1 or -1)
	for i in range(-1, 2, 2):
		for n_bullet in range(SPECS_FOR_EACH_LEVEL[str(GameManager.player_level)]["n_bullets_per_fire"]):
			var new_bullet = BULLET_SCENE.instantiate()
			new_bullet.set_bullet_speed(SPECS_FOR_EACH_LEVEL[str(GameManager.player_level)]["bullet_speed"])
			
			var x_pos = player.position.x + (i * RENDERING_SPECS_FOR_EACH_COLOR[GameManager.player_color]["distance_to_guns_from_center"]) + (i * n_bullet * RENDERING_SPECS_FOR_EACH_COLOR[GameManager.player_color]["space_between_guns"])
			var y_pos = player.position.y + (n_bullet * RENDERING_SPECS_FOR_EACH_COLOR[GameManager.player_color]["latency_between_bullets"])
			new_bullet.position = Vector2(x_pos, y_pos)
			
			get_parent().add_child(new_bullet)
	CAN_FIRE = false

# TODO: connect this to the signal
func level_up():
	if GameManager.player_level < 3:
		GameManager.player_level += 1
		animated_sprite_2d.frame = GameManager.player_level - 1
