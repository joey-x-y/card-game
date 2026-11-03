extends Node

@export var player: Node
@export var ally: Node
@export var op1: Node
@export var op2: Node

@export var deck: Node

@export var river: Node
var river_cards : Array[Card] = []

@export var handSize: int

var next_card_index: int = 0

func _ready():
	player.set_player()
	ally.set_ally()
	op1.set_op1()
	op2.set_op2()

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

	river.flip_card(1)

	draw_round()

	find_hands(player)
	find_hands(ally)
	find_hands(op1)
	find_hands(op2)

func draw_round():
	player.enable_hand()

func discard(p, cards):
	for card in cards:
		p.swap_card(card, get_next_card())

func find_hands(p):
	print(p.get_state_name())
	var cards = p.get_hand().duplicate()
	cards.append_array(river_cards)
	HandFinder.get_possible_hands(cards)


func end_round():
	next_card_index = 0

	river.reset()
	river_cards.clear()

	start_round()

func get_next_card():
	var c = deck.draw_card(next_card_index)
	next_card_index += 1
	return c

func deal_hand(p):
	for i in range(handSize):
		p.give_card(get_next_card())

func set_river():
	for i in range(river.get_river_size()):
		var c = get_next_card()
		river_cards.append(c)
		river.set_card(i, c)
