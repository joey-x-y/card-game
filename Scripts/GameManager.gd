extends Node

var title_scene_path : String = "res://Scenes/Main.tscn"

@export var player: Character
@export var ally: Character
@export var op1: Character
@export var op2: Character

@export var deck: Node

@export var river: Node
var river_cards : Array[Card] = []
var river_cards_active : Array[Card] = []

@export var handSize: int = 4
@export var wins_needed: int = 3

var team1_wins: int = 0
var team2_wins: int = 0

@export var instruction_text: RichTextLabel
@export var hand_sorter_button: OptionButton
@export var scoreboard: RichTextLabel
@export var hand_display: Node

@export var proceed_button: Button
@export var quit_button: Button

var next_card_index: int = 0

var draw: bool = false
var trade: bool = false
var round_ended: bool = false
var complete: bool = false

var last_winner = null

func _ready():
	quit_button.pressed.connect(return_to_title)
	proceed_button.hide()
	hand_sorter_button.item_selected.connect(set_hand_sort)
	hand_sorter_button.select(GlobalTrackers.preferred_hand_sort)

	player.set_player()
	ally.set_ally()
	op1.set_op1()
	op2.set_op2()

	start_round()

func start_round():
	clear_hand_displays()
	scoreboard_update()
	deck.shuffle()

	instruction_text.text = "Dealing..."

	deal_hand(player)
	sort_hand()
	deal_hand(ally)
	deal_hand(op1)
	deal_hand(op2)

	set_river()

	river.flip_card(0)
	river_cards_active.append(river_cards[0])
	player.hand.show_cards()

	draw_round()

func draw_round():
	draw = true
	player.enable_hand()

	instruction_text.text = "Pick which cards you'd like to discard."

	set_hand_helper()

	proceed_button.text = "Discard"
	proceed_button.show()

func discard_round():
	instruction_text.text = "Replacing Cards..."
	player.enable_hand(false)
	var cards = player.hand.use_selected_cards()
	discard(player, cards)
	player.hand.show_cards()
	set_hand_helper()
	sort_hand()
	discard(ally, ally.pick_discard([river_cards[0]], 1))
	discard(op1, op1.pick_discard([river_cards[0]], 1))
	discard(op2, op2.pick_discard([river_cards[0]], 1))

	trade_round()


func discard(p, cards):
	for card in cards:
		p.swap_card(card, get_next_card())

func trade_round():
	trade = true
	sort_hand()
	ally.hand.show_cards()
	player.enable_hand()
	ally.enable_hand()

	instruction_text.text = "Pick which cards you'd like to trade away and the cards you'd like to trade for. Must trade the same amount."

	proceed_button.text = "Trade"
	proceed_button.show()

func do_trades():
	instruction_text.text = "Trading..."
	player.enable_hand(false)
	ally.enable_hand(false)
	var p_cards = player.hand.use_selected_cards()
	var a_cards = ally.hand.use_selected_cards()
	trade_cards(player, ally, p_cards, a_cards)

	set_hand_helper()
	sort_hand()

	var opp_cards = op1.pick_trade(op2.get_hand(), [river_cards[0]], 1)
	trade_cards(op1, op2, opp_cards[0], opp_cards[1])

	player.hand.show_cards()
	ally.hand.show_cards()

	op1.hand.show_cards()
	op2.hand.show_cards()

	river.flip_card(1)
	river_cards_active.append(river_cards[1])

	var best_hand = find_best_hand_overall(get_and_show_hands())
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

	glow_hand(best_hand[1][1], last_winner)
	scoreboard_update()
	instruction_text.text = "Player " + str(n + 1) + ": wins!\n" + str(HandFinder.Hands[best_hand[1][0]])
	for i in best_hand[1][1]:
		print(i.card.id)

	end_round()

func trade_cards(char1, char2, c1_cards, c2_cards):
	for i in range(c1_cards.size()):
		char1.swap_card(c1_cards[i], c2_cards[i])
		char2.swap_card(c2_cards[i], c1_cards[i])

func find_best_hand(hand: Array):
	return HandFinder.get_best_hand_individual(hand, river_cards_active)

func find_best_hand_overall(hands):
	return HandFinder.get_best_hand(hands)

func glow_hand(cards: Array, winner: Character):
	for c in cards:
		if not winner.set_card_effect(c):
			river.set_card_effect(c)


func set_hand_helper():
	var h = find_best_hand(player.get_hand())
	hand_display.set_hand(h[1], HandFinder.Hands[h[0]])

	return h

func get_and_show_hands():
	var h = set_hand_helper()
	player.set_display_data_hand(HandFinder.Hands[h[0]])

	var a = find_best_hand(ally.get_hand())
	ally.set_display_data_hand(HandFinder.Hands[a[0]])

	var b = find_best_hand(op1.get_hand())
	op1.set_display_data_hand(HandFinder.Hands[b[0]])

	var c = find_best_hand(op2.get_hand())
	op2.set_display_data_hand(HandFinder.Hands[c[0]])

	return [h, a, b, c]

func find_hands(p, rcards: Array[Card] = river_cards):
	var cards = p.get_hand().duplicate()
	cards.append_array(rcards)
	HandFinder.get_possible_hands(cards)

func clear_hand_displays():
	hand_display.hide_hand()
	player.clear_display_data_hand()
	ally.clear_display_data_hand()
	op1.clear_display_data_hand()
	op2.clear_display_data_hand()


func end_round():
	next_card_index = 0

	if team1_wins >= wins_needed:
		print("Team 1 won it all!")
		GlobalTrackers.win()
		end_game(true)
	elif team2_wins >= wins_needed:
		print("Team 2 won it all!")
		GlobalTrackers.lose()
		end_game(false)
	else:
		print("Next round pending...")
		round_ended = true
		proceed_button.text = "Next Hand"
		proceed_button.show()

func end_game(win: bool):
	GlobalTrackers.save_game()
	complete = true
	proceed_button.text = "Restart"
	proceed_button.show()

func restart_round():
	player.wipe_hand()
	ally.wipe_hand()
	op1.wipe_hand()
	op2.wipe_hand()
	river.reset()
	river_cards.clear()
	river_cards_active.clear()

	start_round()


func return_to_title():
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

func sort_hand():
	var p_show = player.hand.showing
	var a_show = ally.hand.showing
	match GlobalTrackers.preferred_hand_sort:
		0:
			return
		1:
			player.set_hand(CardSorter.sort_high_to_low(player.get_hand()))
			ally.set_hand(CardSorter.sort_high_to_low(ally.get_hand()))
		2:
			player.set_hand(CardSorter.sort_low_to_high(player.get_hand()))
			ally.set_hand(CardSorter.sort_low_to_high(ally.get_hand()))
		3:
			player.set_hand(CardSorter.group_by_suit(player.get_hand()))
			ally.set_hand(CardSorter.group_by_suit(ally.get_hand()))


	if p_show:
		player.hand.show_cards()
	if a_show:
		ally.hand.show_cards()

func set_hand_sort(i: int):
	GlobalTrackers.preferred_hand_sort = i
	sort_hand()

func scoreboard_update():
	scoreboard.text = "First team to win " + str(wins_needed) + " hands is the winner!\n\nTeam 1 wins: " + str(team1_wins) + "\nTeam 2 wins: " + str(team2_wins)

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
	elif complete:
		print("Restarting")
		proceed_button.hide()
		complete = false
		round_ended = false
		last_winner = null
		team1_wins = 0
		team2_wins = 0
		scoreboard_update()
		restart_round()
	elif round_ended:
		print("Next Round")
		proceed_button.hide()
		round_ended = false
		restart_round()
