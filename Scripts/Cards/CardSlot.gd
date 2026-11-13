extends TextureRect

@export var button: TextureButton
@export var effect: ColorRect
var card: Card

func _ready():
	button.pressed.connect(on_pressed)
	effect.visible = false

func set_card(c):
	card = c
	flip_back()

func replace_card(c):
	card = c

func undo_press():
	button.button_pressed = false
	set_effect(false)

func set_enable(enable):
	button.disabled = enable

func flip_front():
	if card != null:
		texture = card.card.front_texture

func flip_back():
	if card != null:
		texture = card.card.back_texture

func refresh(showing: bool):
	if showing:
		flip_front()
	else:
		flip_back()

func on_pressed():
	Events.card_pressed.emit(self)

func set_effect(enable):
	effect.visible = enable
