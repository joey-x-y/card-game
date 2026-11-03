class_name DeckTextureSplitter
extends RefCounted

const DECK = preload("res://Art/Poker cards/1.2 Poker cards.png")

const CARD_WIDTH = 48
const CARD_HEIGHT = 64

static func get_card_texture(rank: int, suit: int):
    var texture = AtlasTexture.new()

    texture.atlas = DECK

	# Joker check
    if (rank == 0):
        texture.region = Rect2(
			14 * CARD_WIDTH,
			0,
			CARD_WIDTH,
			CARD_HEIGHT
		)
        return texture

    texture.region = Rect2(
        (rank - 1) * CARD_WIDTH,
        suit * CARD_HEIGHT,
        CARD_WIDTH,
        CARD_HEIGHT
    )

    return texture

static func get_back_texture():
    var texture = AtlasTexture.new()

    texture.atlas = DECK

    texture.region = Rect2(
        CARD_WIDTH,
        4 * CARD_HEIGHT,
        CARD_WIDTH,
        CARD_HEIGHT
    )

    return texture