extends TextureButton

var card: Card

func set_card(c):
	card = c
	flip_back()

func replace_card(c):
	card = c
	flip_front()

func flip_front():
	texture_normal = card.card.front_texture

func flip_back():
	texture_normal = card.card.back_texture