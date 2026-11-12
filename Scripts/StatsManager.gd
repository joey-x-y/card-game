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
	# games_played.text = "Games Played: " + str(GlobalTrackers.games_played)

	
	best_win_difficulty.text = "Highest Difficulty Won: "
	if GlobalTrackers.wins > 0:
		if GlobalTrackers.best_win_difficulty == 0:
			best_win_difficulty.text += "Easy"
		if GlobalTrackers.best_win_difficulty == 1:
			best_win_difficulty.text += "Medium"
		elif GlobalTrackers.best_win_difficulty == 2:
			best_win_difficulty.text += "Hard"
		else:
			best_win_difficulty.text += "This is bugged..."

	else:
		if GlobalTrackers.losses > 0:
			best_win_difficulty.text += "None. You're bad."
		else:
			best_win_difficulty.text += "None. Go play the game."

func main_menu():
	get_tree().change_scene_to_file(main_menu_string)

func wipe_stats():
	GlobalTrackers.wipe_data()
	set_menu()
