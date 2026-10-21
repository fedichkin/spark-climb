## Turns player input into a horizontal offset per physics frame:
## relative drag of the first finger (mouse on PC via touch emulation)
## plus the move_left / move_right keyboard actions. Does not move the hero.
class_name TouchInput
extends Node

@export var config: GameConfig

## Horizontal finger movement accumulated since the last consume_dx(), px.
var _pending_drag_x: float = 0.0


func _input(event: InputEvent) -> void:
	# Only the first finger steers; vertical movement is ignored.
	var drag: InputEventScreenDrag = event as InputEventScreenDrag
	if drag != null and drag.index == 0:
		_pending_drag_x += drag.relative.x


## Returns the desired hero offset for this frame (not yet clamped)
## and resets the accumulated drag.
func consume_dx(delta: float) -> float:
	var drag_dx: float = _pending_drag_x * config.drag_sensitivity
	_pending_drag_x = 0.0
	var key_speed: float = config.max_horizontal_speed * config.keyboard_speed_ratio
	var key_dx: float = Input.get_axis("move_left", "move_right") * key_speed * delta
	return drag_dx + key_dx
