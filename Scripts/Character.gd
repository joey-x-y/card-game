extends Node

var State = {
	0: "Player",
	1: "Ally",
	2: "Opponent",
}

var state = 0
@export var hand: Node

func set_player():
	self.state = 0

func set_ally():
	self.state = 1

func set_opp():
	self.state = 2

func give_card(card):
	hand.add(card)