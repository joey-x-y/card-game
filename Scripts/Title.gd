extends Node

@export var continue_button: Button
@export var stats_button: Button
@export var difficulty_button: OptionButton
@export var joker_choice: CheckBox

var game_scene_path : String = "res://Scenes/Game.tscn"
var stats_scene_path : String = "res://Scenes/Stats.tscn"

func _ready():
	GlobalTrackers.load_game()

	# MusicManager.play_music("Maarten Schellekens - Autumn Leaves")
	
	continue_button.pressed.connect(load_game)
	stats_button.pressed.connect(stats_menu)
	difficulty_button.item_selected.connect(pick_difficulty)
	difficulty_button.select(GlobalTrackers.difficulty)
	joker_choice.toggled.connect(pick_jokers)
	joker_choice.set_pressed_no_signal(GlobalTrackers.jokers == 1)


func start_game():
	load_game()

func load_game():
	get_tree().change_scene_to_file(game_scene_path)

func stats_menu():
	get_tree().change_scene_to_file(stats_scene_path)

func pick_difficulty(index: int):
	GlobalTrackers.difficulty = index

func pick_jokers(b: bool):
	GlobalTrackers.jokers = 1 if b else 0
