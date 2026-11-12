extends Node

@export var card_slots: Array[TextureRect]
@export var hand_name_display: RichTextLabel

func _ready():
	hide_hand()

func set_hand(cards: Array, hand: String):
	hide_hand()

	hand_name_display.text = hand

	var i = 0
	while i < cards.size() && i < card_slots.size():
		card_slots[i].texture = cards[i].card.front_texture
		card_slots[i].show()
		i += 1

func hide_hand():
	hand_name_display.text = ""

	for c in card_slots:
		c.hide()