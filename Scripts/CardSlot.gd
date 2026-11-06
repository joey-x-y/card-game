extends TextureButton

@export var card_image: TextureRect

var card: Card

func set_card(c):
	card = c
	flip_back()

func replace_card(c):
	card = c

func flip_front():
	card_image.texture = card.card.front_texture

func flip_back():
	card_image.texture = card.card.back_texture

func _on_pressed():
	Events.card_pressed.emit(self)
