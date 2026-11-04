extends Node

@export var player: Node
@export var ally: Node
@export var op1: Node
@export var op2: Node

@export var deck: Node

@export var river: Node
var river_cards : Array[Card] = []

@export var handSize: int

@export var proceed_button: Button

var next_card_index: int = 0

var draw: bool = false
var trade: bool = false

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

	draw_round()

func draw_round():
	draw = true
	player.enable_hand()

	find_hands(player, [river_cards[0]])

	proceed_button.show()

func discard_round():
	player.enable_hand(false)
	var cards = player.hand.use_selected_cards()
	discard(player, cards)
	player.hand.show_cards()
	discard(ally, ally.pick_discard())
	discard(op1, op1.pick_discard())
	discard(op2, op2.pick_discard())

	trade_round()


func discard(p, cards):
	for card in cards:
		p.swap_card(card, get_next_card())

func trade_round():
	trade = true
	ally.hand.show_cards()
	player.enable_hand()
	ally.enable_hand()

	find_hands(player,[river_cards[0]])
	find_hands(ally,[river_cards[0]])

	proceed_button.show()

func do_trades():
	var p_cards = player.hand.use_selected_cards()
	var a_cards = ally.hand.use_selected_cards()
	trade_cards(p_cards, a_cards)

	player.hand.show_cards()
	ally.hand.show_cards()

	op1.hand.show_cards()
	op2.hand.show_cards()

	river.flip_card(1)

	find_best_hand()
	
	find_hands(player)
	find_hands(ally)
	find_hands(op1)
	find_hands(op2)

func trade_cards(p_cards, a_cards):
	for i in range(p_cards.size()):
		player.swap_card(p_cards[i], a_cards[i])
		ally.swap_card(a_cards[i], p_cards[i])

func find_best_hand():
	var hands = [player.get_hand(), ally.get_hand(), op1.get_hand(), op2.get_hand()]
	var best_hand = HandFinder.get_best_hand(hands, river_cards)
	print(best_hand)

func find_hands(p, rcards = river_cards):
	print(p.get_state_name())
	var cards = p.get_hand().duplicate()
	cards.append_array(rcards)
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


func _on_button_pressed():
	if draw:
		proceed_button.hide()
		draw = false
		discard_round()
	elif trade:
		if player.hand.selected_cards.size() == ally.hand.selected_cards.size():
			proceed_button.hide()
			trade = false
			do_trades()
		else:
			print("Invalid trade")
