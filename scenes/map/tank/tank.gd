extends CharacterBody2D

var TANK_MODEL = "red" # either red or green
var TANK_LEVEL = 1 # if the model is red, there's a second level
var TANK_PROPS = {
	"red": {
		"1": {
			"attack_range_radius": 190,	
		},
		"2": {
			"attack_range_radius": 170
		}
	},
	"green": {
		"1": {
			"attack_range_radius": 150	
		}
	}
}

var PLAYER_INSIDE_ATTACK_RANGE = false

@onready var attack_range = $AttackRange/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(TANK_MODEL != null, "Please set the tank model using set_tank_model()")
	attack_range.shape.radius = TANK_PROPS[TANK_MODEL][str(TANK_LEVEL)]["attack_range_radius"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	
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
