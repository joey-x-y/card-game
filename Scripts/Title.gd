extends Node

@export var continue_button: Button
@export var stats_button: Button

var game_scene_path : String = "res://Scenes/Game.tscn"
var stats_scene_path : String = "res://Scenes/Stats.tscn"

func _ready():

	# MusicManager.play_music("Maarten Schellekens - Autumn Leaves")
	
	continue_button.pressed.connect(load_game)
	stats_button.pressed.connect(stats_menu)


func start_game():
	load_game()

func load_game():
	get_tree().change_scene_to_file(game_scene_path)

func stats_menu():
	get_tree().change_scene_to_file(stats_scene_path)
	


func _on_option_button_item_selected(index: int):
	GlobalTrackers.difficulty = index + 1
	print(GlobalTrackers.difficulty)
