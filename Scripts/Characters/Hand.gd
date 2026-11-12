extends Node

var hand: Array[Card] = []
var activeCardSlots: Array[TextureRect] = []
@export var cardSlots: Array[TextureRect]
var selected_cards: Array[Card] = []

var showing = false

func _ready():
	Events.card_pressed.connect(on_card_pressed)
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
	showing = false
	hand.clear()
	activeCardSlots.clear()
	for slot in cardSlots:
		slot.visible = false
		slot.set_effect(false)

func select(card):
	if selected_cards.has(card):
		selected_cards.erase(card)
		print("Deselected ", card.card.id)
	else:
		selected_cards.append(card)
		print("Selected ", card.card.id)

func show_cards():
	for slot in activeCardSlots:
		slot.flip_front()
	showing = true

func hide_cards():
	for slot in activeCardSlots:
		slot.flip_back()
		slot.undo_press()
	showing = false

func enable_hand(enable):
	for slot in activeCardSlots:
		slot.set_enable(!enable)
		slot.undo_press()

func swap_card(old, new):
	var index = hand.find(old)
	hand[index] = new
	activeCardSlots[index].replace_card(new)

func swap_cards(old, new):
	for i in range(old.count()):
		swap_card(old[i], new[i])

func get_cards():
	return hand

func use_selected_cards():
	var c = selected_cards.duplicate()
	selected_cards.clear()
	return c

func get_card_by_index(indexes: Array[int]):
	var cards = []
	for i in indexes:
		cards.append(hand[i])

	return cards

func on_card_pressed(cardSlot: TextureRect):
	if activeCardSlots.has(cardSlot):
		var card = cardSlot.card
		select(card)
