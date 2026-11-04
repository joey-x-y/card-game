class_name HandFinder
extends RefCounted

var Hands = {
	0: "High Card",
	1: "Pair",
	2: "Two Pair",
	3: "Three of a Kind",
	4: "Straight",
	5: "Flush",
	6: "Full House",
	7: "Four of a Kind",
	8: "Straight Flush",
	9: "Royal Flush"
}

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
	var hands_dict = {}
	for i in range(hands.size()):
		var hand = hands[i]
		hands_dict[i] = get_possible_hands(hand.append_array(river_cards))

	best_hand = strongest_hand_group(hands_dict)

	return best_hand

static func strongest_hand_group(possible_hands):
	var best_hand = null
	var hand_values = []

	for hand in possible_hands:
		hand_values.append([hand, get_hand_value(possible_hands[hand])])

	best_hand = hand_values[0]
	for h in hand_values:
		if h[0] == best_hand[0]:
			continue
		if h[1][0] > best_hand[1][0]:
			v = h
		elif h[1][0] == best_hand[1][0]:
			if h[1][1][0] > best_hand[1][1][0]:
				v = h

	return best_hand

static func get_hand_value(hands):
	var hand_value = 0
	var best_hand = []

	# High Card Check
	if (hands[0].size() == 0 && hands[1].size() == 0 && hands[2].size() == 0):
		return [hand_value, best_hand]

	# Straight Flush Check
	if hands[2].size() > 0:
		if hands[1].size() > 0:
			var s_flush = straight_flush_check(hands[1], hands[2])
			if s_flush.size() > 0:
				var jokers = CardSorter.count_jokers(s_flush[0])
				best_hand = s_flush[0]
				if royal_flush_check(best_hand, jokers):
					hand_value = 9
					return [hand_value, best_hand]
				if s_flush.size() > 1:
					for h in s_flush:
						if h == best_hand:
							continue
						if royal_flush_check(h, jokers):
							hand_value = 9
							return [hand_value, h]
						else:
							if best_hand[0].card.rank < h[0].card.rank:
								best_hand = h
				hand_value = 8
				return [hand_value, best_hand]

	# Flush Check
		else:
			hand_value = 5
			best_hand = hands[2][0]
			if hands[2].size() > 1:
				for h in hands[2]:
					if CardSorter.check_contain_rank(1, h):
						best_hand = h
						break
					if h == best_hand:
						continue
					if best_hand[0].card.rank < h[0].card.rank:
						best_hand = h

	# Straight Check
	elif hands[1].size() > 0:
		hand_value = 4
		best_hand = hands[1][0]
		if hands[1].size()> 1:
			for h in hands[1]:
				if CardSorter.check_contain_rank(1, h):
					best_hand = h
					break
				if h == best_hand:
					continue
				if best_hand[0].card.rank < h[0].card.rank:
					best_hand = h

	# Pairing Checks
	if cards[0].size() > 0:
		var pair_is_best = hand_value < 4

		var h = cards[0][0]
		if h == 4:
			if hand_value < 7:
				hand_value = 7
				pair_is_best = true
		elif h == 32:
			if hand_value < 6:
				hand_value = 6
				pair_is_best = true
		elif hand_value < 4:
			if h == 3:
				if hand_value < 3:
					hand_value = 3
			elif h == 22:
				if hand_value < 2:
					hand_value = 2
			elif h == 2:
				if hand_value < 1:
					hand_value = 1

		if pair_is_best:
			var i = 1
			var n = cards[0].size()
			var groups = []
			var next_hand = []
			if hand_value == 7:
				while i < n:
					if cards[0][i].size() == 4:
						groups.append(cards[0][i])
					i += 1
				best_hand = groups[0]
				if groups.size() > 1:
					for g in groups:
						if g[0] > best_hand[0]:
							best_hand = g

			elif hand_value == 6:
				while i < n:
					if cards[0][i].size() == 3:
						groups.append(cards[0][i])
					i += 1
				best_hand = groups[0]
				if groups.size() > 1:
					for g in groups:
						if g[0] > best_hand[0]:
							best_hand = g

				i = 1
				groups.clear()
				while i < n:
					if cards[0][i].size() == 2:
						groups.append(cards[0][i])
					i += 1
				next_hand = groups[0]
				if groups.size() > 1:
					for g in groups:
						if g[0] > next_hand[0]:
							next_hand = g

				best_hand.append_array(next_hand)

			elif hand_value == 3:
				while i < n:
					if cards[0][i].size() == 3:
						groups.append(cards[0][i])
					i += 1
				best_hand = groups[0]
				if groups.size() > 1:
					for g in groups:
						if g[0] > best_hand[0]:
							best_hand = g

			elif hand_Value == 2:
				while i < n:
					if cards[0][i].size() == 2:
						groups.append(cards[0][i])
					i += 1
				best_hand = groups[0]
				next_hand = groups[1]
				if groups.size() > 2:
					for g in groups:
						if g[0] > best_hand[0]:
							best_hand = g
						elif g[0] > next_hand[0]:
							next_hand = g
				best_hand.append_array(next_hand)

			elif hand_value == 1:
				while i < n:
					if cards[0][i].size() == 2:
						groups.append(cards[0][i])
					i += 1
				best_hand = groups[0]
				if groups.size() > 1:
					for g in groups:
						if g[0] > best_hand[0]:
							best_hand = g

	return [hand_value, best_hand]
							
				
static func royal_flush_check(hand, jokers):
	return (hand[0].card.rank == 1 || hand[0].card.rank + jokers > 13)


static func pair_check(cards):
	var number_array = CardSorter.extract_ranks(CardSorter.remove_jokers(cards.duplicate()))
	var indiv_number_arrays = []
	var jokers = cards.size() - number_array.size()

	var i = 0

	while i < number_array.size():
		var current_num = number_array[i]
		var arr = CardSorter.get_matching_rank(current_num, cards)
		i += arr.size()

		if arr.size() > 1:
			indiv_number_arrays.append(arr)

	var pairs = 0
	var threes = 0
	var fours = 0

	for a in indiv_number_arrays:
		if a.has(0):
			continue
		var n = a.size()
		if n == 2:
			pairs += 1
		elif n == 3:
			threes += 1
		elif n == 4:
			fours += 1

	if jokers > 0:
		for i in range(jokers):
			var j = CardSorter.get_joker(cards)
			var groups = []
			if threes > 0:
				for g in indiv_number_arrays:
					if g.size() == 3:
						groups.append(g)
				if groups[-1][0] == 1:
					groups[-1].append(j)
				else:
					groups[0].append(j)
				fours += 1
				threes -= 1
			elif pairs > 0:
				for g in indiv_number_arrays:
					if g.size() == 2:
						groups.append(g)
				if groups[-1][0] == 1:
					groups[-1].append(j)
				else:
					groups[0].append(j)
				threes += 1
				pairs -= 1
			else:
				if number_array.has(1):
					for c in cards:
						if c.card.rank == 1:
							indiv_number_arrays.append_array([c, j])
							break
				else:
					indiv_number_arrays.append_array([cards[0], j])
				pairs += 1


	if fours > 0:
		indiv_number_arrays.insert(0, 4)
	elif threes > 0:
		if pairs > 0:
			indiv_number_arrays.insert(0, 32)
		else:
			indiv_number_arrays.insert(0, 3)
	elif pairs > 0:
		if pairs > 1:
			indiv_number_arrays.insert(0, 22)
		else:
			indiv_number_arrays.insert(0, 2)

	return indiv_number_arrays
	
static func straight_check(cards):
	var old_cards = cards.duplicate()
	cards = CardSorter.remove_jokers(cards)
	var jokers = old_cards.size() - cards.size()
	var straight_length = 5 - jokers

	var straight_hands = []

	var count = cards.size() - 4

	var i = 0
	while i < range(count):
		var n = cards[i].card.rank
		var chain_ranks = [cards[i]]
		var chain = true

		var aces = CardSorter.get_matching_rank(1, cards)
		if (n == 13 && aces.size() > 0):
			chain_ranks.insert(0, aces)
			i += aces.size()

		while chain:
			var next_rank = CardSorter.get_matching_rank(n-1, cards)
			if (next_rank.size() > 0):
				n -= 1
				chain_ranks.append(next_rank)
				i += next_rank.size()
			else:
				chain = false

		if chain_ranks.size() >= straight_length:
			for i in range(jokers):
				chain_ranks.insert(0, CardSorter.get_joker())
			straight_hands.append(chain_ranks)

	return straight_hands
	
static func flush_check(cards):
	var hearts = []
	var diamonds = []
	var spades = []
	var clubs = []

	var jokers = []

	for card in cards:
		var s = card.card.suit
		if s == 0:
			hearts.append(card)
		elif s == 1:
			diamonds.append(card)
		elif s == 2:
			spades.append(card)
		elif s == 3:
			clubs.append(card)
		elif s == 4:
			jokers.append(card)

	var flush_hands = []
	var flush_length = 5 - jokers.size()

	if hearts.size() >= flush_length:
		flush_hands.append(hearts)
	elif diamonds.size() >= flush_length:
		flush_hands.append(diamonds)
	elif spades.size() >= flush_length:
		flush_hands.append(spades)
	elif clubs.size() >= flush_length:
		flush_hands.append(clubs)

	if jokers.size() > 0 && flush_hands.size() > 0:
		for h in flush_hands:
			for j in jokers:
				h.append(j)

	return flush_hands

static func straight_flush_check(straight, flush):
	var needed = 5
	var matches = []

	for s in straight:
		for f in flush:
			var m = []
			for num in s:
				for card in num:
					for fcard in f:
						if card.card.id == fcard.card.id:
							m.append(card)
			if m.size() >= needed:
				matches.append(m)

	return matches