class_name HandFinder
extends RefCounted

static func get_possible_hands(cards):
	var new_cards = cards.duplicate()
	new_cards = CardSorter.sort_high_to_low(new_cards)

	var straight = straight_check(new_cards.duplicate())
	var pairings = pair_check(new_cards.duplicate())
	var flush = flush_check(new_cards.duplicate())

	print("Possible straights: ", straight)
	print("Possible pairings: ", pairings)
	print("Possible flushes: ", flush)

	return [pairings, straight, flush]

static func get_best_hand(hands, river_cards):
	var best_hand = null
	for hand in hands:
		strongest_hand(get_possible_hands(hand.append_array(river_cards)))

	return best_hand

static func strongest_hand(possible_hands):
	# if possible_hands[2].size() > 0:
	# 	if possible_hands[1].size() > 0:
	return null


static func pair_check(cards):
	var number_array = CardSorter.extract_ranks(cards)
	var indiv_number_arrays = []

	var i = 0

	while i < number_array.size():
		var current_num = number_array[i]
		var arr = [current_num]
		i += 1

		while i < number_array.size() and number_array[i] == current_num:
			arr.append(current_num)
			i += 1

		if arr.size() > 1:
			indiv_number_arrays.append(arr)

	var pairs = 0
	var threes = 0
	var fours = 0

	for a in indiv_number_arrays:
		var n = a.size()
		if n == 2:
			pairs += 1
		elif n == 3:
			threes += 1
		elif n == 4:
			fours += 1

	# if number_array.has(0):
		# Joker Logic


	if fours > 0:
		indiv_number_arrays.insert(0, "Four of a kind")
	elif threes > 0:
		if pairs > 0:
			indiv_number_arrays.insert(0, "Full house")
		else:
			indiv_number_arrays.insert(0, "Three of a kind")
	elif pairs > 0:
		if pairs > 1:
			indiv_number_arrays.insert(0, "Two pair")
		else:
			indiv_number_arrays.insert(0, "Pair")
	else:
		indiv_number_arrays.insert(0, "None")

	return indiv_number_arrays
	
static func straight_check(cards):
	var old_cards = cards
	cards = remove_jokers(cards)
	var jokers = old_cards.size() - cards.size()
	var straight_length = 5 - jokers

	var count = cards.size() - 4

	for i in range(count):
		var n = cards[i].card.rank
		var chain_ranks = [n]
		var chain = true

		if (n == 13 && CardSorter.check_contain_rank(1, cards)):
			chain_ranks.insert(0, 1)
			i += 1

		while chain:
			if (CardSorter.check_contain_rank(n-1, cards)):
				n -=1
				chain_ranks.append(n)
				i += 1
			else:
				chain = false

		if chain_ranks.size() >= straight_length:
			if jokers > 0:
				chain_ranks.append("Joker")
			return chain_ranks

	return []
	
static func flush_check(cards):
	var hearts = []
	var diamonds = []
	var spades = []
	var clubs = []

	var jokers = []

	for card in cards:
		var s = card.card.suit
		if s == 0:
			hearts.append(card.card.id)
		elif s == 1:
			diamonds.append(card.card.id)
		elif s == 2:
			spades.append(card.card.id)
		elif s == 3:
			clubs.append(card.card.id)
		elif s == 4:
			jokers.append(card.card.id)

	var flush_hands = []
	var flush_length = 5 - jokers.size()

	if hearts.size() > flush_length:
		flush_hands.append(hearts)
	elif diamonds.size() > flush_length:
		flush_hands.append(diamonds)
	elif spades.size() > flush_length:
		flush_hands.append(spades)
	elif clubs.size() > flush_length:
		flush_hands.append(clubs)

	if jokers.size() > 0 && flush_hands.size() > 0:
		flush_hands.append(jokers)

	return flush_hands
	
	
static func count_jokers(cards):
	var c = 0
	for card in cards:
		if card.card.rank == 0:
			c += 1
	return c

static func remove_jokers(cards):
	for i in range(cards.size()):
		if cards[i].card.rank == 0:
			cards.remove_at(i)
			i -= 1

	return cards
