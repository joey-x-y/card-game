extends Node


var hand: Array[Card] = []

func add(card):
	hand.append(card)

func remove(i):
	hand.remove_at(i)

func clear():
	hand.clear()

func select(i):
	return hand[i]