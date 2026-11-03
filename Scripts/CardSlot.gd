extends TextureRect

var card: Card

func set_card(c):
	card = c
	flip_back()

func flip_front():
	texture = card.card.front_texture

func flip_back():
	texture = card.card.back_texture