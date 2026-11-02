extends Resource

enum Suit {
	HEARTS = 0,
	DIAMONDS = 1,
	CLUBS = 2,
	SPADES = 3,
	NONE = 4,
}

var Ranks = { 
	1: "ACE", 
	2: "TWO", 
	3: "THREE", 
	4: "FOUR", 
	5: "FIVE", 
	6: "SIX", 
	7: "SEVEN", 
	8: "EIGHT", 
	9: "NINE", 
	10: "TEN", 
	11: "JACK", 
	12: "QUEEN", 
	13: "KING", 
	0: "JOKER",
}

var suit: Suit = Suit.SPADES
var rank: int = 1
var id: String = ""

func _init(suit: Suit = Suit.SPADES, rank: int = 1):
	self.suit = suit
	self.rank = rank
	id = Ranks[rank] + "_" + String(Suit.find_key(suit))