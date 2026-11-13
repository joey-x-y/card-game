extends Node

@export var card_slot: Array[TextureRect]

func get_river_size():
	return card_slot.size()

func set_card(index, card):
	card_slot[index].set_card(card)
	# print("River ", index, " ", CardData.Suit.find_key(card.card.suit), " ", card.card.Ranks[card.card.rank])

func flip_card(index):
	card_slot[index].flip_front()

func reset():
	for slot in card_slot:
		slot.flip_back()
		slot.set_effect(false)
		slot.self_modulate.a = 0

func set_card_effect(card):
	for slot in card_slot:
		if slot.card == card:
			slot.set_effect(true)
			return true
	return false

func get_slot(index):
	return card_slot[index]
