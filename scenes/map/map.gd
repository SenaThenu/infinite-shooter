extends Node2D

const TOP_EXTRA_AREA = 100
@onready var SPAWN_AREA = get_viewport().size

# elements that should be on the map at a time
const required_elements = {
	"tanks": 1,
	"hp_power_ups": 1,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	SPAWN_AREA.y += TOP_EXTRA_AREA
	print(SPAWN_AREA)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
