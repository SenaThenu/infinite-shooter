extends Node

const start_screen_scene: PackedScene = preload("res://scenes/start_screen/start_screen.tscn")
const main_game_scene: PackedScene = preload("res://scenes/game/game.tscn")

func load_game_scene():
	get_tree().change_scene_to_packed(main_game_scene)

func load_start_screen():
	get_tree().change_scene_to_packed(start_screen_scene)

# player realted stuff
var player_level = 2
var player_color = "green"
