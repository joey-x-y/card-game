extends Node

var hand: Array[Card] = []
var activeCardSlots: Array[Node] = []
@export var cardSlots: Array[Node]

func _ready():
	clear()

func add(card):
	var current_slot = cardSlots[hand.size()]
	activeCardSlots.append(current_slot)
	current_slot.set_card(card)

	hand.append(card)
	current_slot.visible=true

func remove(i):
	hand.remove_at(i)
	activeCardSlots[i].visible = false
	activeCardSlots.remove_at(i)

func clear():
	hand.clear()
	activeCardSlots.clear()
	for slot in cardSlots:
		slot.visible = false

func select(i):
	return hand[i]

func show_cards():
	for slot in activeCardSlots:
		slot.flip_front()

func hide_cards():
	for slot in activeCardSlots:
		slot.flip_back()