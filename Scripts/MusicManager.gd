extends Node

@onready var music_player = $AudioStreamPlayer

var music_library = {
	"Maarten Schellekens - Autumn Leaves": preload("res://Music/Maarten Schellekens - Autumn Leaves.mp3"),

}


var current_track: String = ""

var current_volume : float

func _ready():
	current_volume = get_volume()

func play_music(track_name: String):
	if track_name == "none":
		music_player.stop()
		current_track = ""
		return

	if track_name == current_track or track_name not in music_library:
		return

	current_track = track_name
	music_player.stream = music_library[track_name]
	music_player.play()

func set_volume(db: float):
	if get_mute():
		return
	music_player.volume_db = db
	current_volume = db

func get_volume() -> float:
	return current_volume

func set_mute(mute: bool):
	if mute:
		current_volume = music_player.volume_db
		music_player.volume_db = -80
	else:
		music_player.volume_db = current_volume

func get_mute():
	return music_player.volume_db == -80
