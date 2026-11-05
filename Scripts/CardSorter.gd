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

static func count_jokers_by_id(cards: Array[String]):
	return cards.count("JOKER_NONE")

static func remove_jokers(cards):
	for i in range(cards.size()):
		if cards[i].card.rank == 0:
			cards.remove_at(i)
			i -= 1

	return cards