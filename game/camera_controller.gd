## Run camera. Anchored at the top-left corner, so `position.y` is the top
## edge of the visible area. Follows the target upwards, auto-scrolls after
## start_scroll() and never moves down (GAME_SPEC §9, ARCHITECTURE §8).
class_name CameraController
extends Camera2D

@export var config: GameConfig
## Node the camera keeps at or below the follow line (the hero).
@export var target: Node2D

## Current auto-scroll speed, px/s. Set by Game as the height grows.
var scroll_speed: float = 0.0

var _scrolling: bool = false


func _ready() -> void:
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT


func _process(delta: float) -> void:
	if _scrolling:
		position.y -= scroll_speed * delta
	_follow_target()


## Turns on continuous auto-scroll. Called once by Game.
func start_scroll() -> void:
	_scrolling = true


func is_scrolling() -> bool:
	return _scrolling


## World Y of the top edge of the visible area.
func get_top_y() -> float:
	return global_position.y


## World Y of the bottom edge of the visible area.
func get_bottom_y() -> float:
	return global_position.y + _screen_height()


## Lifts the camera so the target stays on the follow line; never lowers it.
func _follow_target() -> void:
	var follow_offset: float = _screen_height() * config.camera_follow_ratio
	position.y = minf(position.y, target.global_position.y - follow_offset)


func _screen_height() -> float:
	return get_viewport().get_visible_rect().size.y
