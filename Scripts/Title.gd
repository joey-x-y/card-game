extends Node

@export var continue_button: Button

var game_scene_path : String = "res://Scenes/Game.tscn"

func _ready():

	# MusicManager.play_music("Maarten Schellekens - Autumn Leaves")
	
	continue_button.pressed.connect(load_game)

func start_game():
	load_game()

func load_game():
	get_tree().change_scene_to_file(game_scene_path)
	
