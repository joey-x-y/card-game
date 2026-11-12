class_name Card
extends Node

var card: CardData

func _init(c: CardData = CardData.new()):
	card = c

func is_joker():
	return card.rank == 0
