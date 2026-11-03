class_name Character
extends Node

var State = {
	0: "Player",
	1: "Ally",
	2: "Opponent 1",
	3: "Opponent 2",
}

var state = 0
@export var hand: Node

func set_player():
	state = 0

func set_ally():
	state = 1

func set_op1():
	state = 2

func set_op2():
	state = 3

func give_card(card):
	hand.add(card)
	print(State[state], " ", CardData.Suit.find_key(card.card.suit), " ", card.card.Ranks[card.card.rank])

func get_state_name():
	return State[state]

func swap_card(old, new):
	hand.swap_card(old, new)

func enable_hand(enable: bool = true):
	hand.enable_hand(enable)

func get_hand():
	return hand.get_cards()