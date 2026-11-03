extends Container

var hand: Array[Card] = []
var activeCardSlots: Array[TextureButton] = []
@export var cardSlots: Array[TextureButton]

@export var slot_width: float = 48
var slot_height: float
var hand_width : float
@export var card_gap: float = 5.0

func _ready():
	layout_slots()
	clear()

func add(card):
	var current_slot = cardSlots[hand.size()]
	activeCardSlots.append(current_slot)
	current_slot.set_card(card)

	hand.append(card)
	current_slot.visible=true

func remove(i):
	hand.remove_at(i)
	activeCardSlots[i].visible = false
	activeCardSlots.remove_at(i)

func clear():
	hand.clear()
	activeCardSlots.clear()
	for slot in cardSlots:
		slot.visible = false

func select(i):
	return hand[i]

func show_cards():
	for slot in activeCardSlots:
		slot.flip_front()

func hide_cards():
	for slot in activeCardSlots:
		slot.flip_back()

func enable_hand(enable):
	for slot in activeCardSlots:
		slot.disabled = !enable

func swap_card(old, new):
	var index = hand.find(old)
	hand[index] = new
	activeCardSlots[index].replace_card(new)

func swap_cards(old, new):
	for i in range(old.count()):
		swap_card(old[i], new[i])

func layout_slots():
	slot_height = slot_width * (4.0/3.0)
	var count = cardSlots.size()
	hand_width = count * slot_width + (card_gap * (count - 1))
	var start_x = (size.x - hand_width) / 2.0
	var y = (size.y - slot_height) / 2.0

	for i in count:
		var slot = cardSlots[i]
		var slot_rect = Rect2(
			start_x + i * (slot_width + card_gap),
			y,
			slot_width,
			slot_height
		)
		fit_child_in_rect(slot, slot_rect)

func get_cards():
	return hand