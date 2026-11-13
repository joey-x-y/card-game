extends Node

@export var card_slots: Array[TextureRect]
@export var hand_name_display: RichTextLabel
@export var hand_description_display: RichTextLabel

func _ready():
	hide_hand()

func set_hand(cards: Array, hand: int):
	hide_hand()

	hand_name_display.text = HandFinder.Hands[hand]
	hand_description_display.text = HandFinder.get_hand_description(cards, hand)

	var i = 0
	while i < cards.size() && i < card_slots.size():
		card_slots[i].texture = cards[i].card.front_texture
		card_slots[i].show()
		i += 1

func hide_hand():
	hand_name_display.text = ""
	hand_description_display.text = ""

	for c in card_slots:
		c.hide()