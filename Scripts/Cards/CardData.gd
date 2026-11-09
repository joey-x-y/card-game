class_name CardData
extends Resource

enum Suit {
	HEARTS = 0,
	DIAMONDS = 1,
	SPADES = 2,
	CLUBS = 3,
	NONE = 4,
}

var Ranks = {  
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
	14: "ACE",
	0: "JOKER",
}

var suit: Suit = Suit.SPADES
var rank: int = 1
var id: String = ""

var front_texture
var back_texture

func _init(suit: Suit = Suit.SPADES, rank: int = 2):
	self.suit = suit
	self.rank = rank
	id = Ranks[rank] + "_" + String(Suit.find_key(suit))

	front_texture = DeckTextureSplitter.get_card_texture(rank, suit)
	back_texture = DeckTextureSplitter.get_back_texture()
