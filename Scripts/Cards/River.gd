extends Container

@export var card_slot: Array[TextureRect]

@export var slot_width: float = 48
var slot_height: float = 64

@export var slot_gap: float

var river_width = 0


func _ready():
	layout_slots()

func layout_slots():
	var count = get_river_size()
	slot_height = slot_width * (4.0/3.0)

	river_width = (slot_width * count) + (slot_gap * (count - 1))
	var start_x = (size.x - river_width) / 2.0
	var y = (size.y - slot_height) / 2.0

	for i in count:
		var slot = card_slot[i]
		var slot_rect = Rect2(
			start_x + i * (slot_width + slot_gap),
			y,
			slot_width,
			slot_height
		)
		fit_child_in_rect(slot, slot_rect)

func get_river_size():
	return card_slot.size()

func set_card(index, card):
	card_slot[index].get_child(0).set_card(card)
	# print("River ", index, " ", CardData.Suit.find_key(card.card.suit), " ", card.card.Ranks[card.card.rank])

func flip_card(index):
	card_slot[index].get_child(0).flip_front()

func reset():
	for slot in card_slot:
		slot.get_child(0).flip_back()
