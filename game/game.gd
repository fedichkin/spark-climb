## Run scene root: wires the systems together and starts the run.
## Starts the generator, puts the hero at rest on the start platform and
## turns on camera auto-scroll after the first landing on a regular platform.
extends Node2D

@export var config: GameConfig

@onready var _player: Player = $Player
@onready var _generator: PlatformGenerator = $PlatformGenerator
@onready var _camera: CameraController = $Camera


func _ready() -> void:
	var start_platform: Platform = _generator.start(randi())
	var platform_top_y: float = start_platform.position.y - config.platform_size.y / 2.0
	_player.position = Vector2(start_platform.position.x, platform_top_y - config.player_radius)
	# Temporary: switches to Events.player_landed in M2 task 5.
	_player.landed.connect(_on_player_landed)


func _on_player_landed(platform: Platform, _quality: LandingMath.Quality) -> void:
	if platform.kind != Platform.Kind.START and not _camera.is_scrolling():
		_camera.scroll_speed = DifficultyCurve.scroll_speed(
			0.0, config.scroll_base_speed, config.scroll_speed_per_meter, config.scroll_max_speed)
		_camera.start_scroll()
