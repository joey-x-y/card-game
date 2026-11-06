class_name HandFinder
extends RefCounted

static var Hands = {
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

	# print("Possible straights: ", straight)
	# print("Possible pairings: " pairings)
	# print("Possible flushes: ", flush)

	return [pairings, straight, flush]

static func get_best_hand(hands, river_cards):
	var best_hand = null
	var best_hand_list = []
	var hands_dict = {}
	for i in range(hands.size()):
		var hand = hands[i]
		hand.append_array(river_cards)
		hands_dict[i] = get_possible_hands(hand)
		print("Player ", i, ": ", hands_dict[i])

	best_hand_list = strongest_hand_group(hands_dict)
	best_hand = best_hand_list[0]

	for i in range(best_hand_list.size()):
		print("Rank ", i, "! Player ", best_hand_list[i][0], ": ", best_hand_list[i][1])

	return best_hand

static func strongest_hand_group(possible_hands):
	var hand_values = [[0, get_hand_value(possible_hands[0])]]

	for i in possible_hands:
		if i == 0:
			continue
		var next = get_hand_value(possible_hands[i])
		var n = 0
		while n < hand_values.size():
			if next[0] > hand_values[n][1][0]:
				hand_values.insert(n, [i, next])
				break
			elif next[0] == hand_values[n][1][0]:
				var s = false
				if next[0] == 4:
					s = true
				var better = CardSorter.get_best_hand(next[1], hand_values[n][1][1], s)
				if better == next[1]:
					hand_values.insert(n, [i, next])
					break
			n += 1
		if n == hand_values.size():
			hand_values.append([i, next])

	return hand_values

static func get_hand_value(hands):
	var hand_value = 0
	var best_hand = []

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
							best_hand = CardSorter.get_best_hand(h, best_hand, true)
				hand_value = 8
				return [hand_value, best_hand]

	# Flush Check
		hand_value = 5
		best_hand = hands[2][0]
		if hands[2].size() > 1:
			for h in hands[2]:
				if h == best_hand:
					continue
				best_hand = CardSorter.get_best_hand(h, best_hand)

	# Straight Check
	elif hands[1].size() > 0:
		hand_value = 4
		var best_hand_array = hands[1][0]
		if hands[1].size() > 1:
			for h in hands[1]:
				if h[0] == best_hand_array:
					continue
				best_hand_array = [CardSorter.get_best_hand(h[0][0], best_hand_array[0], true)]
				if best_hand_array[0].card.rank < h[0][0].card.rank:
					best_hand_array = h[0]
		for a in best_hand_array:
			best_hand.append(a[0])

	# Pairing Checks
	if hands[0].size() > 0:
		var pair_is_best = hand_value < 4

		var h = hands[0][0]
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
			var n = hands[0].size()
			var groups = []
			var next_hand = []
			if hand_value == 7:
				while i < n:
					if hands[0][i].size() == 4:
						groups.append(hands[0][i])
					i += 1
				best_hand = groups[0]
				if groups.size() > 1:
					for g in groups:
						best_hand = CardSorter.get_best_hand(g, best_hand)

			elif hand_value == 6:
				while i < n:
					if hands[0][i].size() == 3:
						groups.append(hands[0][i])
					i += 1
				best_hand = groups[0]
				if groups.size() > 1:
					for g in groups:
						best_hand = CardSorter.get_best_hand(g, best_hand)

				i = 1
				groups.clear()
				while i < n:
					if hands[0][i].size() == 2:
						groups.append(hands[0][i])
					i += 1
				next_hand = groups[0]
				if groups.size() > 1:
					for g in groups:
						next_hand = CardSorter.get_best_hand(g, next_hand)

				best_hand.append_array(next_hand)

			elif hand_value == 3:
				while i < n:
					if hands[0][i].size() == 3:
						groups.append(hands[0][i])
					i += 1
				best_hand = groups[0]
				if groups.size() > 1:
					for g in groups:
						best_hand = CardSorter.get_best_hand(g, best_hand)

			elif hand_value == 2:
				while i < n:
					if hands[0][i].size() == 2:
						groups.append(hands[0][i])
					i += 1
				best_hand = groups[0]
				next_hand = groups[1]
				if groups.size() > 2:
					for g in groups:
						best_hand = CardSorter.get_best_hand(g, best_hand)
						if g != best_hand:
							next_hand = CardSorter.get_best_hand(g, next_hand)
				if CardSorter.get_best_hand(best_hand, next_hand) == best_hand:
					best_hand.append_array(next_hand)
				else:
					best_hand.insert(0, next_hand)

			elif hand_value == 1:
				while i < n:
					if hands[0][i].size() == 2:
						groups.append(hands[0][i])
					i += 1
				best_hand = groups[0]
				if groups.size() > 1:
					for g in groups:
						best_hand = CardSorter.get_best_hand(g, best_hand)

			elif hand_value == 0:
				best_hand = hands[0][1]

	return [hand_value, best_hand]
							
				
static func royal_flush_check(hand, jokers):
	return (hand[0].card.rank == 14 || (hand[0].card.rank == 0 && CardSorter.check_contain_rank(14 - jokers, hand)))


static func pair_check(cards):
	var number_array = CardSorter.extract_ranks(CardSorter.remove_jokers(cards.duplicate()))
	var indiv_number_arrays = []
	var jokers = cards.size() - number_array.size()

	var i = 0

	while i < number_array.size():
		var current_num = number_array[i]
		var arr = CardSorter.get_matching_rank(current_num, cards)
		i += max(arr.size(), 1)

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
		var j = CardSorter.get_joker(cards)
		for _i in range(jokers):
			var group = []
			if threes > 0:
				for g in indiv_number_arrays:
					if g.size() == 3:
						group = g
						break
				group.append(j)
				fours += 1
				threes -= 1
			elif pairs > 0:
				for g in indiv_number_arrays:
					if g.size() == 2:
						group = g
						break
				group.append(j)
				threes += 1
				pairs -= 1
			else:
				indiv_number_arrays.append([cards[0], j])
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
	else:
		indiv_number_arrays = [1, [cards[0]]]

	return indiv_number_arrays
	
static func straight_check(cards):
	var jokers = CardSorter.count_jokers(cards)
	var straight_length = 5

	var straight_hands = []

	var count = cards.size() - 4

	var i = 0
	while i < count:
		var n = cards[i].card.rank
		var chain_ranks = [CardSorter.get_matching_rank(n, cards)]
		var chain = true
		var usable_jokers = jokers

		while chain && n >= 2:
			var next_rank = CardSorter.get_matching_rank(n-1, cards)
			if (next_rank.size() > 0):
				n -= 1
				chain_ranks.append(next_rank)
				i += next_rank.size()
			# checks if can use a low ace
			elif n == 2 && CardSorter.check_contain_rank(14, cards):
				chain_ranks.append(CardSorter.get_matching_rank(14, cards))
				i = count
				chain = false
			elif usable_jokers > 0 && chain_ranks.size() < straight_length - usable_jokers:
				usable_jokers -= 1
				n -= 1
				chain_ranks.append([CardSorter.get_joker(cards)])
				i += 1
			else:
				chain = false

		if chain_ranks.size() >= straight_length - usable_jokers:
			var j = 0
			var biggest = chain_ranks[0][0].card.rank
			var joker_card = CardSorter.get_joker(cards)
			for _i in range(usable_jokers):
				if biggest < 14 - j:
					chain_ranks.insert(0, joker_card)
				else:
					chain_ranks.append(joker_card)
				i += 1
				j += 1
			straight_hands.append(chain_ranks)
		i += 1

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
	if diamonds.size() >= flush_length:
		flush_hands.append(diamonds)
	if spades.size() >= flush_length:
		flush_hands.append(spades)
	if clubs.size() >= flush_length:
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