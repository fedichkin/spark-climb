## The hero: applies gravity, bounces automatically on every landing on a
## Platform and reports the landing quality via the `landed` signal.
## Horizontal offset comes from the TouchInput child node; the hero wraps
## around the screen edges when config.screen_wrap is on.
class_name Player
extends CharacterBody2D

## Emitted right after the bounce velocity has been applied.
signal landed(platform: Platform, quality: LandingMath.Quality)

## Number of vertices used to draw the hero circle.
const CIRCLE_SEGMENTS: int = 32

@export var config: GameConfig

@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _body: Polygon2D = $Body
@onready var _touch_input: TouchInput = $TouchInput


func _ready() -> void:
	_build_circle()


func _physics_process(delta: float) -> void:
	velocity.y += config.gravity * delta
	velocity.x = _horizontal_velocity(delta)
	move_and_slide()
	if config.screen_wrap:
		_wrap_horizontally()
	if is_on_floor():
		_bounce()


## Moves the hero to the opposite side once its center leaves the screen.
func _wrap_horizontally() -> void:
	var screen_width: float = get_viewport().get_visible_rect().size.x
	position.x = fposmod(position.x, screen_width)


## Converts this frame's input offset into velocity, capped by
## max_horizontal_speed. No input means no horizontal motion (no inertia).
func _horizontal_velocity(delta: float) -> float:
	var max_step: float = config.max_horizontal_speed * delta
	var dx: float = clampf(_touch_input.consume_dx(delta), -max_step, max_step)
	return dx / delta


func _bounce() -> void:
	var platform: Platform = get_last_slide_collision().get_collider() as Platform
	if platform == null:
		return
	platform.on_player_landed()
	velocity.y = -config.jump_velocity * platform.get_jump_multiplier()
	var quality: LandingMath.Quality = LandingMath.evaluate(
		global_position.x, platform.global_position.x, platform.width, config.perfect_zone_ratio)
	landed.emit(platform, quality)


## Builds the collision circle and its visual from config.player_radius.
func _build_circle() -> void:
	var shape: CircleShape2D = CircleShape2D.new()
	shape.radius = config.player_radius
	_collision.shape = shape
	var points: PackedVector2Array = PackedVector2Array()
	for i: int in CIRCLE_SEGMENTS:
		points.append(Vector2.from_angle(TAU * i / CIRCLE_SEGMENTS) * config.player_radius)
	_body.polygon = points
