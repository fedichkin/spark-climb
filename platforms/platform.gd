## Base class for every platform. Builds its own collision shape and visual
## from `width` and `config.platform_size.y`; subclasses override the hooks
## below to add behavior (moving, crumbling, spring).
class_name Platform
extends AnimatableBody2D

enum Kind { START, STATIC, MOVING, CRUMBLING, SPRING }

@export var kind: Kind = Kind.STATIC
@export var config: GameConfig

## Set by the spawner via setup() (GameConfig.platform_size.x,
## or the visible area width for the start platform).
var width: float = 0.0

@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _body: Polygon2D = $Body


func _ready() -> void:
	if width <= 0.0:
		width = config.platform_size.x
	_apply_size()


## Sets the platform width. Safe to call before or after adding to the tree.
func setup(new_width: float) -> void:
	width = new_width
	if is_node_ready():
		_apply_size()


## Velocity multiplier applied to the player's bounce.
func get_jump_multiplier() -> float:
	return 1.0


## Called by the player right after landing on this platform.
func on_player_landed() -> void:
	pass


## Whether landings on this platform count for the combo.
func counts_for_combo() -> bool:
	return kind != Kind.START


## Creates a fresh shape per instance so platforms never share one resource.
func _apply_size() -> void:
	var size: Vector2 = Vector2(width, config.platform_size.y)
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = size
	_collision.shape = shape
	var half: Vector2 = size / 2.0
	_body.polygon = PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x, half.y),
		Vector2(-half.x, half.y),
	])
