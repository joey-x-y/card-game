extends Node

@export var continue_button: Button
@export var stats_button: Button
@export var difficulty_button: OptionButton
@export var joker_choice: CheckBox
@export var mute_button: CheckBox
@export var skip_animations: CheckBox
@export var rules_menu: Node

@export var rules_open: Button
@export var rules_close: Button

var game_scene_path : String = "res://Scenes/Game Portraits.tscn"
var stats_scene_path : String = "res://Scenes/Stats.tscn"

func _ready():
	GlobalTrackers.load_game()

	MusicManager.set_volume(-10)
	MusicManager.play_music("title")

	rules_menu.hide()
	rules_open.pressed.connect(rules_menu.show)
	rules_close.pressed.connect(rules_menu.hide)

	continue_button.pressed.connect(load_game)
	stats_button.pressed.connect(stats_menu)
	difficulty_button.item_selected.connect(pick_difficulty)
	difficulty_button.select(GlobalTrackers.difficulty)
	joker_choice.toggled.connect(pick_jokers)
	joker_choice.set_pressed(GlobalTrackers.jokers == 1)
	mute_button.toggled.connect(pick_mute)
	mute_button.set_pressed(GlobalTrackers.mute)
	skip_animations.toggled.connect(pick_skip_animations)
	skip_animations.set_pressed(GlobalTrackers.skip_animations)

func start_game():
	load_game()

func load_game():
	MusicManager.play_music("game")
	get_tree().change_scene_to_file(game_scene_path)

func stats_menu():
	get_tree().change_scene_to_file(stats_scene_path)

func pick_difficulty(index: int):
	GlobalTrackers.difficulty = index

func pick_jokers(b: bool):
	GlobalTrackers.jokers = 1 if b else 0

func pick_mute(b: bool):
	GlobalTrackers.mute = b
	MusicManager.set_mute(b)

func pick_skip_animations(b: bool):
	GlobalTrackers.skip_animations = b
