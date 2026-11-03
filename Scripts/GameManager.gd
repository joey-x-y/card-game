extends Node

@export var player: Node
@export var ally: Node
@export var op1: Node
@export var op2: Node

@export var deck: Node

@export var river: Node
var river_cards

@export var handSize: int

var next_card_index: int = 0

func _ready():
	player.set_player()
	ally.set_ally()
	op1.set_opp()
	op2.set_opp()

	start_round()

func start_round():
	deck.shuffle()

	deal_hand(player)
	deal_hand(ally)
	deal_hand(op1)
	deal_hand(op2)

	set_river()

	river.flip_card(0)
	player.hand.show_cards()

func end_round():
	next_card_index = 0

	river.reset()

	start_round()


func deal_hand(p):
	for i in range(handSize):
		p.give_card(deck.draw_card(next_card_index))
		next_card_index += 1

func set_river():
	for i in range(river.get_river_size()):
		river.set_card(i, deck.draw_card(next_card_index))
		next_card_index += 1
