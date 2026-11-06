class_name CardSorter
extends RefCounted

static func sort_high_to_low(cards):
	var remaining = cards.duplicate()
	var sorted: Array = [remaining[0]]
	remaining.remove_at(0)

	for card in remaining:
		var inserted = false
		for i in sorted.size():
			if card.card.rank >= sorted[i].card.rank:
				sorted.insert(i, card)
				inserted = true
				break
		if not inserted:
			sorted.append(card)

	return sorted

static func sort_low_to_high(cards):
	var remaining = cards.duplicate()
	var sorted: Array = [remaining[0]]
	remaining.remove_at(0)

	for card in remaining:
		var inserted = false
		for i in sorted.size():
			if card.card.rank <= sorted[i].card.rank:
				sorted.insert(i, card)
				inserted = true
				break
		if not inserted:
			sorted.append(card)

	return sorted

static func extract_ranks(cards):
	var ranks = []

	for card in cards:
		ranks.append(card.card.rank)

	return ranks

static func check_all_same_suit(cards):
	# will be false if joker first
	var suit = cards[0].card.suit
	var i = 1
	while i < cards.size():
		if cards[i].card.suit != suit && cards[i].card.suit != 4:
			return false

	return true

static func check_all_same_rank(cards):
	# will be false if joker first
	var rank = cards[0].card.rank
	var i = 1
	while i < cards.size():
		if cards[i].card.rank != rank && cards[i].card.rank != 0:
			return false

	return true



static func check_contain_rank(rank, cards):
	for card in cards:
		if card.card.rank == rank:
			return true

	return false

static func get_matching_rank(rank: int, cards):
	var matching = []
	for card in cards:
		if card.card.rank == rank:
			matching.append(card)

	return matching

static func get_matching_suit(suit: int, cards):
	var matching = []
	for card in cards:
		if card.card.suit == suit:
			matching.append(card)

	return matching

static func get_joker(cards):
	for card in cards:
		if card.card.rank == 0:
			return card

	return ""

static func count_jokers(cards):
	var c = 0
	for card in cards:
		if card.card.rank == 0:
			c += 1
	return c

static func remove_jokers(cards):
	var new_array = []
	for c in cards:
		if c.card.rank != 0:
			new_array.append(c)

	return new_array

static func get_best_hand(a, b, straight = false):
	var hand = min(a.size(), 5)
	for i in range(hand):
		var an = a[i].card.rank
		var bn = b[i].card.rank
		# Joker Check
		if an == 0:
			an = find_expected_joker_rank(a, straight)
		if bn  == 0:
			bn = find_expected_joker_rank(b, straight)
		
		# normal check
		if an > bn:
			return a
		elif an < bn:
			return b

	# for now, hand a wins ties until i implement pushes
	return a

static func find_expected_joker_rank(cards, straight):
	# questoinable with multiple jokers, may need to pass in variable, for 1st, 2nd, etc
	if count_jokers(cards) == 0:
		return 0
	if straight:
		if cards[0].card.rank == 0:
			if cards[1].card.rank == 0:
				var i = 2
				while i < cards.size():
					if cards[i].card.rank == 0:
						i += 1
					else:
						return cards[i].card.rank + i
			else:
				return cards[1].card.rank + 1

		else:
			var i = 1
			while i < cards.size():
				if cards[i].card.rank == 0:
					return cards[0].card.rank - i
				else:
					i += 1

	elif CardSorter.check_all_same_suit(cards):
		var i = 14
		while i > 0:
			if CardSorter.check_contain_rank(i, cards):
				i -= 1
			else:
				return i
	
		return cards[0].card.rank
	else:
		if cards.size() == 5:
			if cards[4].card.rank == 0:
				return cards[2].card.rank
		return cards[0].card.rank

	return 0