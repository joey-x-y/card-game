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
@export var display_data: RichTextLabel
@export var display_data_hand: RichTextLabel
## difficulty will probably be skill's implementation for free play
@export var difficulty: int = 0

func set_player():
	state = 0
	set_display_data("Player 1: Team 1")

func set_ally():
	state = 1
	difficulty = GlobalTrackers.difficulty
	set_display_data("Player 2: Team 1")

func set_op1():
	state = 2
	difficulty = GlobalTrackers.difficulty
	set_display_data("Player 3: Team 2")

func set_op2():
	state = 3
	difficulty = GlobalTrackers.difficulty
	set_display_data("Player 4: Team 2")

func set_display_data(s: String):
	display_data.text = s

func set_display_data_hand(s : String):
	display_data_hand.text = s

func clear_display_data_hand():
	display_data_hand.text = ""

func give_card(card):
	hand.add(card)
	# print(State[state], " ", CardData.Suit.find_key(card.card.suit), " ", card.card.Ranks[card.card.rank])

func set_card_effect(card):
	for i in range(hand.hand.size()):
		if hand.hand[i] == card:
			hand.cardSlots[i].set_effect(true)
			return true
	return false

func get_state_name():
	return State[state]

func swap_card(old, new):
	hand.swap_card(old, new)

func enable_hand(enable: bool = true):
	hand.enable_hand(enable)

func get_hand():
	return hand.get_cards()

func pick_discard(current_river: Array, hidden_river_cards: int):
	## 0 is easiest difficulty, 2 is hardest
	var rand = randi_range(0, 2)
	if difficulty < rand:
		return []

	# var unrevealed = river_length - current_river.size()
	var full_hand = hand.hand.duplicate()
	full_hand.append_array(current_river)
	var discard_cards = []

	var possible_hands = HandFinder.get_possible_hands(full_hand)
	var hand_value = HandFinder.get_hand_value(possible_hands)

	if hand_value[0] >= 4: return []

	## Will handle joker in river later

	## Pairings Check
	var ranks = CardSorter.extract_ranks(hand.hand)
	var river_ranks = CardSorter.extract_ranks(current_river)
	var strong_pairing = false

	for r in ranks:
		if not (ranks.count(r) > 1 || river_ranks.has(r) || r == 0):
			if ranks.count(r) + river_ranks.count(r) >= 3 || discard_cards.size() > 1:
				strong_pairing = true
			discard_cards.append(CardSorter.get_matching_rank(r, hand.hand)[0])

	if strong_pairing:
		print(State[state], " discarding ", HandFinder.print_hand(discard_cards))
		return discard_cards

	## Flush Check
	for card in current_river:
		if CardSorter.count_matching_suit(card.card.suit, hand.hand) + CardSorter.count_jokers(hand.hand) >= 3:
			discard_cards.clear()
			for c in hand.hand:
				if not (c.card.suit == card.card.suit || c.is_joker()):
					discard_cards.append(c)
			break

	print(State[state], " discarding ", HandFinder.print_hand(discard_cards))
	return discard_cards

func pick_trade(ally_hand: Array, current_river: Array, hidden_river_cards: int):
	## 0 is easiest difficulty, 2 is hardest
	var rand = randi_range(0, 2)
	if difficulty < rand:
		return [[], []]

	var self_trade = []
	var ally_trade = []

	var p1_hand = hand.hand + current_river
	var p1_hands = HandFinder.get_possible_hands(p1_hand)
	var p1_hand_value = HandFinder.get_hand_value(p1_hands)

	var p2_hand = ally_hand + current_river
	var p2_hands = HandFinder.get_possible_hands(p2_hand)
	var p2_hand_value = HandFinder.get_hand_value(p2_hands)

	var best_indiv_value = max(p1_hand_value[0], p2_hand_value[0])

	var all_cards = p1_hand + ally_hand
	var hands_overall = HandFinder.get_possible_hands(all_cards)
	var hand_value = HandFinder.get_hand_value(hands_overall)

	if hand_value[0] <= best_indiv_value:
		print("Best possible value only ", hand_value[0], " just like ", best_indiv_value, ", no trade necessary.")
		return [[], []]

	# if hand_value >= 

	var preferred_hands = [[], []]
	for n in range(hand.hand.size()):
		for i in range(hand.hand.size() - n):
			var hand_1 = p1_hand.duplicate()
			var hand_2 = p2_hand.duplicate()

			hand_1.set(n, p2_hand[i + n])
			hand_2.set(i + n, p1_hand[n])

			var hand_1_hands = HandFinder.get_possible_hands(hand_1)
			var hand_1_value = HandFinder.get_hand_value(hand_1_hands)
			var hand_2_hands = HandFinder.get_possible_hands(hand_2)
			var hand_2_value = HandFinder.get_hand_value(hand_2_hands)

			if hand_1_value[0] > best_indiv_value:
				preferred_hands = [hand_1, hand_2]
				best_indiv_value = hand_1_value[0]
			if hand_2_value[0] > best_indiv_value:
				preferred_hands = [hand_1, hand_2]
				best_indiv_value = hand_2_value[0]

	if preferred_hands[0].size() > 0:
		for c in hand.hand:
			if not preferred_hands[0].has(c):
				self_trade.append(c)
				print("Trading away ", c.card.id)
		for c in ally_hand:
			if not preferred_hands[1].has(c):
				ally_trade.append(c)
				print("Trading for ", c.card.id)

		if self_trade.size() != ally_trade.size():
			if self_trade.size() > ally_trade.size():
				self_trade.resize(ally_trade.size())
			else:
				ally_trade.resize(self_trade.size())
	else:
		print("No good trades")

	return [self_trade, ally_trade]

func set_hand(cards):
	wipe_hand()
	for c in cards:
		give_card(c)

func wipe_hand():
	hand.clear()
