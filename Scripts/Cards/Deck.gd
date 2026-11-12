class_name Deck
extends Node

var cards: Array[Card] = []
var joker_amount: int = 1

func fill_deck():
	set_joker_amount(GlobalTrackers.jokers)

	cards.clear()

	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 2)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 3)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 4)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 5)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 6)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 7)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 8)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 9)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 10)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 11)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 12)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 13)))
	cards.append(Card.new(CardData.new(CardData.Suit.SPADES, 14)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 2)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 3)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 4)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 5)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 6)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 7)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 8)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 9)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 10)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 11)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 12)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 13)))
	cards.append(Card.new(CardData.new(CardData.Suit.HEARTS, 14)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 2)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 3)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 4)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 5)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 6)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 7)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 8)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 9)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 10)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 11)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 12)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 13)))
	cards.append(Card.new(CardData.new(CardData.Suit.DIAMONDS, 14)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 2)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 3)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 4)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 5)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 6)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 7)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 8)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 9)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 10)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 11)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 12)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 13)))
	cards.append(Card.new(CardData.new(CardData.Suit.CLUBS, 14)))

	for i in range(joker_amount):
		cards.append(Card.new(CardData.new(CardData.Suit.NONE, 0)))

func shuffle():
	fill_deck()
	cards.shuffle()

func draw_card(index = 0):
	if (check_legal_index(index)):
		return cards[index]
	else:
		return cards[0]

func swap(i1, i2):
	if (check_legal_index(i1) && check_legal_index(i2)):
		var c = cards[i1]
		cards[i1] = cards[i2]
		cards[i2] = c
		return true
	return false

func check_legal_index(i):
	return i < cards.size()

func set_joker_amount(i: int):
	joker_amount = i
