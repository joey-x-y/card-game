extends Node

@export var portrait: Texture2D
@export var texture: TextureRect

func _ready():
	if portrait == null:
		return
	texture.texture = portrait
