class_name CardSorter
extends RefCounted

static func sort_high_to_low(cards: Array):
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

static func sort_low_to_high(cards: Array):
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