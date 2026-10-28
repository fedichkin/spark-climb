## Builds the endless tower: creates platforms ahead of the camera, one row
## at a time from bottom to top, and frees the ones that fell below it.
## Vertical gaps come from DifficultyCurve; only static platforms for now.
class_name PlatformGenerator
extends Node

@export var config: GameConfig
@export var camera: CameraController
## Parent node for spawned platforms.
@export var platforms_root: Node2D
@export var static_platform_scene: PackedScene

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
## World Y where height is 0 m.
var _start_y: float = 0.0
## World Y of the most recently spawned platform.
var _last_y: float = 0.0
var _running: bool = false


## Starts generation above `start_y`. The same seed gives the same tower.
func start(start_y: float, seed_value: int) -> void:
	_rng.seed = seed_value
	_start_y = start_y
	_last_y = start_y
	_running = true


func _process(_delta: float) -> void:
	if not _running:
		return
	_spawn_ahead()
	_despawn_below()


func _spawn_ahead() -> void:
	var screen_height: float = get_viewport().get_visible_rect().size.y
	var spawn_limit_y: float = camera.get_top_y() - config.spawn_ahead_screens * screen_height
	var spawned: int = 0
	while _last_y > spawn_limit_y:
		_spawn_next()
		spawned += 1
	if spawned > 0:
		print("Spawned %d platforms, alive: %d" % [spawned, platforms_root.get_child_count()])


func _spawn_next() -> void:
	var tier: DifficultyTier = DifficultyCurve.tier_for_height(config.difficulty_tiers, _height_m(_last_y))
	_last_y -= _rng.randf_range(tier.gap_min, tier.gap_max)
	var platform: Platform = static_platform_scene.instantiate() as Platform
	platform.setup(config.platform_size.x)
	platform.position = Vector2(_random_x(config.platform_size.x), _last_y)
	platforms_root.add_child(platform)


## Random X that keeps the whole platform `horizontal_margin` away from the edges.
func _random_x(platform_width: float) -> float:
	var screen_width: float = get_viewport().get_visible_rect().size.x
	var half: float = platform_width / 2.0
	return _rng.randf_range(config.horizontal_margin + half, screen_width - config.horizontal_margin - half)


func _despawn_below() -> void:
	var despawn_y: float = camera.get_bottom_y() + config.despawn_margin
	for child: Node in platforms_root.get_children():
		var platform: Node2D = child as Node2D
		if platform != null and platform.global_position.y > despawn_y:
			platform.queue_free()


func _height_m(y: float) -> float:
	return (_start_y - y) / config.pixels_per_meter
