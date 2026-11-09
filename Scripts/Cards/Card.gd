class_name Card
extends Node

var card: CardData

func _init(card: CardData = CardData.new()):
	self.card = card

func is_joker():
	return card.rank == 0