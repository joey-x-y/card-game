extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var music_library = {
	"title": preload("res://Music/slippy_merged.mp3"),
	"game": preload("res://Music/Lobo Loco - Der Kommissar Blech im Sumpf (The Commissar) (ID 179).mp3"),
}

var sfx_library = {
	"card_flip": preload("res://Music/SFX/card-flip.wav"),
	"win": preload("res://Music/SFX/yay.wav"),
	"lose": preload("res://Music/SFX/pot.wav"),
	"mouse_hover": preload("res://Music/SFX/button_hover.mp3"),
	"mouse_click": preload("res://Music/SFX/button-hover-click.mp3"),
}


var current_track: String = ""
var current_volume : float

func _ready():
	music_player.bus = "Music"
	set_mute(GlobalTrackers.mute)

	get_tree().node_added.connect(_on_node_added)
	connect_button_sfx(get_tree().root)

func play_music(track_name: String):
	if track_name == "none":
		stop_music()
		return

	if track_name == current_track or track_name not in music_library:
		return

	current_track = track_name
	music_player.stream = music_library[track_name]
	music_player.stream.loop = true
	music_player.play()

func stop_music():
	music_player.stop()
	current_track = ""

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
		music_player.stop()
	else:
		music_player.volume_db = current_volume
		music_player.play()

func get_mute():
	return music_player.volume_db == -80


func play_sfx(sfx_name: String):
	if sfx_name not in sfx_library:
		return

	var player = AudioStreamPlayer.new()
	player.stream = sfx_library[sfx_name]
	player.bus = "SFX"

	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()

func _on_node_added(node: Node):
	if node is BaseButton:
		connect_button_sfx(node)


func connect_button_sfx(node: Node):
	if node is BaseButton:
		if not node.mouse_entered.is_connected(_on_button_hover.bind(node)):
			node.mouse_entered.connect(_on_button_hover.bind(node))

		if not node.pressed.is_connected(_on_button_click):
			node.pressed.connect(_on_button_click)

	for child in node.get_children():
		connect_button_sfx(child)


func _on_button_hover(node: BaseButton):
	if node.disabled:
		return
	play_sfx("mouse_hover")


func _on_button_click():
	play_sfx("mouse_click")
