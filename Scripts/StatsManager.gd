extends Node

@export var back_button: Button
var main_menu_string: String = "res://Scenes/Main.tscn"
@export var wipe_button: Button

@export var wins: Label
@export var losses: Label
@export var games_played: Label
@export var best_win_difficulty: Label

func _ready():
	back_button.pressed.connect(main_menu)
	wipe_button.pressed.connect(wipe_stats)

	set_menu()

func set_menu():
	wins.text = "Wins: " + str(GlobalTrackers.wins)
	losses.text = "Losses: " + str(GlobalTrackers.losses)
	games_played.text = "Games Played: " + str(GlobalTrackers.games_played)
	
	if GlobalTrackers.wins > 0:
		var best_win_string: String
		if GlobalTrackers.best_win_difficulty == 0:
			best_win_string = "Easy"
		if GlobalTrackers.best_win_difficulty == 1:
			best_win_string = "Medium"
		elif GlobalTrackers.best_win_difficulty == 2:
			best_win_string = "Hard"
		else:
			best_win_string = "This is bugged..."
			

		best_win_difficulty.text = "Highest Difficulty Won: " + best_win_string

func main_menu():
	get_tree().change_scene_to_file(main_menu_string)

func wipe_stats():
	GlobalTrackers.wipe_data()
	set_menu()
