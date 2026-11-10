extends Node

var save_path = "user://save_data.save"

var wins: int = 0
var losses: int = 0
var games_played: int = 0

var difficulty: int = 0
var best_win_difficulty: int = 0

var preferred_hand_sort: int = 0

func win():
	wins += 1
	if difficulty > best_win_difficulty:
		best_win_difficulty = difficulty
	games_played += 1

func lose():
	losses += 1
	games_played += 1


func save_game():
	var data = {
		"wins": wins,
		"losses": losses,
		"games_played": games_played,
		"best_win_difficulty": best_win_difficulty,
		"difficulty": difficulty,
		"preferred_hand_sort": preferred_hand_sort,	
	}

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_game() -> bool:
	if not FileAccess.file_exists(save_path):
		return false  # No save file yet

	var file = FileAccess.open(save_path, FileAccess.READ)

	if file == null:
		return false

	var data = file.get_var()
	if not data is Dictionary:
		return false

	wins = data.get("wins", 0)
	losses = data.get("losses", 0)
	games_played = data.get("games_played", 0)
	best_win_difficulty = data.get("best_win_difficulty", 0)
	difficulty = data.get("difficulty", 0)
	preferred_hand_sort = data.get("preferred_hand_sort", 0)

	return true

func wipe_data():
	wins = 0
	losses = 0
	games_played = 0
	best_win_difficulty = 0
	difficulty = 0
	preferred_hand_sort = 0
	save_game()