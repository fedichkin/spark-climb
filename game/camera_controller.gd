## Run camera. Anchored at the top-left corner, so `position.y` is the top
## edge of the visible area. Exposes the visible bounds for other systems.
## Following the hero and auto-scroll are added in M2 task 4.
class_name CameraController
extends Camera2D


func _ready() -> void:
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT


## World Y of the top edge of the visible area.
func get_top_y() -> float:
	return global_position.y


## World Y of the bottom edge of the visible area.
func get_bottom_y() -> float:
	return global_position.y + get_viewport().get_visible_rect().size.y
