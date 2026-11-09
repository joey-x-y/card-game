extends Node

var title_scene_path : String = "res://Scenes/Main.tscn"

@export var player: Node
@export var ally: Node
@export var op1: Node
@export var op2: Node

@export var deck: Node

@export var river: Node
var river_cards : Array[Card] = []

@export var handSize: int = 4
@export var wins_needed: int = 3

var team1_wins: int = 0
var team2_wins: int = 0

@export var proceed_button: Button

var next_card_index: int = 0

var draw: bool = false
var trade: bool = false

var last_winner = null

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
	discard(ally, ally.pick_discard([river_cards[0]], 1))
	discard(op1, op1.pick_discard([river_cards[0]], 1))
	discard(op2, op2.pick_discard([river_cards[0]], 1))

	trade_round()


func discard(p, cards):
	for card in cards:
		p.swap_card(card, get_next_card())

func trade_round():
	trade = true
	ally.hand.show_cards()
	player.enable_hand()
	ally.enable_hand()

	find_hands(player, [river_cards[0]])
	find_hands(ally, [river_cards[0]])

	proceed_button.show()

func do_trades():
	player.enable_hand(false)
	ally.enable_hand(false)
	var p_cards = player.hand.use_selected_cards()
	var a_cards = ally.hand.use_selected_cards()
	trade_cards(player, ally, p_cards, a_cards)

	var opp_cards = op1.pick_trade(op2.get_hand(), [river_cards[0]], 1)
	trade_cards(op1, op2, opp_cards[0], opp_cards[1])

	player.hand.show_cards()
	ally.hand.show_cards()

	op1.hand.show_cards()
	op2.hand.show_cards()

	river.flip_card(1)

	var best_hand = find_best_hand()
	var n = best_hand[0]

	if ally.state == n:
		last_winner = ally
		team1_wins += 1
	elif op1.state == n:
		last_winner = op1
		team2_wins += 1
	elif op2.state == n:
		last_winner = op2
		team2_wins += 1
	else:
		last_winner = player
		team1_wins += 1

	print("River: ", HandFinder.print_hand(river_cards))
	print("Player ", n, ": wins!")
	print(HandFinder.Hands[best_hand[1][0]])
	for i in best_hand[1][1]:
		print(i.card.id)
	print("Team 1 Wins: ", team1_wins)
	print("Team 2 Wins: ", team2_wins)

	end_round()

func trade_cards(char1, char2, c1_cards, c2_cards):
	for i in range(c1_cards.size()):
		char1.swap_card(c1_cards[i], c2_cards[i])
		char2.swap_card(c2_cards[i], c1_cards[i])

func find_best_hand():
	var hands = [player.get_hand(), ally.get_hand(), op1.get_hand(), op2.get_hand()]
	var best_hand = HandFinder.get_best_hand(hands, river_cards)
	return best_hand

func find_hands(p, rcards: Array[Card] = river_cards):
	var cards = p.get_hand().duplicate()
	cards.append_array(rcards)
	HandFinder.get_possible_hands(cards)


func end_round():
	next_card_index = 0

	if team1_wins >= wins_needed:
		print("Team 1 won it all!")
		await get_tree().create_timer(5).timeout
		end_game(true)
	elif team2_wins >= wins_needed:
		print("Team 2 won it all!")
		await get_tree().create_timer(5).timeout
		end_game(false)
	else:
		print("Next round pending...")
		await get_tree().create_timer(5).timeout
		player.wipe_hand()
		ally.wipe_hand()
		op1.wipe_hand()
		op2.wipe_hand()
		river.reset()
		river_cards.clear()
		print("Go!")
		start_round()

func end_game(win: bool):
	# for now winning just returns to title
	get_tree().change_scene_to_file(title_scene_path)


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
		print("Discarding and Redrawing")
		proceed_button.hide()
		draw = false
		discard_round()
	elif trade:
		if player.hand.selected_cards.size() == ally.hand.selected_cards.size():
			print("Trading")
			proceed_button.hide()
			trade = false
			do_trades()
		else:
			print("Invalid trade")
