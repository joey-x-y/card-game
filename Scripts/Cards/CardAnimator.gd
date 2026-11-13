class_name CardAnimator
extends CanvasLayer

@export var duration: float = 0.25

func fly(texture: Texture2D, from: Control, to: Control) -> void:
	var ghost := TextureRect.new()
	ghost.texture = texture
	ghost.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ghost.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(ghost)
	ghost.global_position = from.global_position
	ghost.size = from.size

	var t := create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(ghost, "global_position", to.global_position, duration)
	t.tween_property(ghost, "size", to.size, duration)
	await t.finished
	ghost.queue_free()