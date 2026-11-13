extends Node

var hand: Array[Card] = []
@export var cardSlots: Array[TextureRect]
var selected_cards: Array[Card] = []

var showing = false

func _ready():
	Events.card_pressed.connect(on_card_pressed)
	clear()

func add(card):
	var current_slot = cardSlots[hand.size()]
	current_slot.set_card(card)

	hand.append(card)
	current_slot.self_modulate.a = 1

func remove(i):
	hand.remove_at(i)
	cardSlots[i].self_modulate.a = 0

func clear():
	showing = false
	hand.clear()
	for slot in cardSlots:
		slot.self_modulate.a = 0
		slot.set_effect(false)

func select(card):
	if selected_cards.has(card):
		selected_cards.erase(card)
		print("Deselected ", card.card.id)
	else:
		selected_cards.append(card)
		print("Selected ", card.card.id)

func show_cards():
	for slot in cardSlots:
		slot.flip_front()
	showing = true

func hide_cards():
	for slot in cardSlots:
		slot.flip_back()
		slot.undo_press()
	showing = false

func enable_hand(enable):
	for slot in cardSlots:
		slot.set_enable(!enable)
		slot.undo_press()

func swap_card(old, new):
	var index = hand.find(old)
	if index == -1:
		return
	hand[index] = new
	cardSlots[index].replace_card(new)

func swap_cards(old, new):
	for i in range(old.size()):
		swap_card(old[i], new[i])

func get_cards():
	return hand

func use_selected_cards():
	var c = selected_cards.duplicate()
	selected_cards.clear()
	return c

func get_slot(card):
	return cardSlots[hand.find(card)]

func on_card_pressed(cardSlot: TextureRect):
	if cardSlots.has(cardSlot) && cardSlot.card != null:
		select(cardSlot.card)
