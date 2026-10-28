## Run scene root: owns the run state, tracks the height score and wires
## the systems together. READY while the hero bounces on the start platform;
## PLAYING from the first landing on a regular platform, which also starts
## camera auto-scroll. Scroll speed grows with the run's best height.
extends Node2D

enum RunState { READY, PLAYING }

@export var config: GameConfig

var _state: RunState = RunState.READY
## World Y of the hero center at rest on the start platform (0 m).
var _start_y: float = 0.0
## Best height reached in this run, meters (never decreases).
var _max_height_m: float = 0.0
## Last whole-meter value sent via Events.height_changed.
var _reported_meters: int = 0

@onready var _player: Player = $Player
@onready var _generator: PlatformGenerator = $PlatformGenerator
@onready var _camera: CameraController = $Camera


func _ready() -> void:
	var start_platform: Platform = _generator.start(randi())
	var platform_top_y: float = start_platform.position.y - config.platform_size.y / 2.0
	_start_y = platform_top_y - config.player_radius
	_player.position = Vector2(start_platform.position.x, _start_y)
	Events.player_landed.connect(_on_player_landed)
	Events.height_changed.emit(_reported_meters)


func _process(_delta: float) -> void:
	_update_height()
	if _state == RunState.PLAYING:
		_camera.scroll_speed = DifficultyCurve.scroll_speed(
			_max_height_m, config.scroll_base_speed, config.scroll_speed_per_meter, config.scroll_max_speed)


func _on_player_landed(platform: Platform, _quality: LandingMath.Quality) -> void:
	if _state == RunState.READY and platform.kind != Platform.Kind.START:
		_start_run()


func _start_run() -> void:
	_state = RunState.PLAYING
	_camera.start_scroll()
	Events.run_started.emit()


## Keeps the best height of the run and reports each new whole meter.
func _update_height() -> void:
	var height_m: float = (_start_y - _player.position.y) / config.pixels_per_meter
	_max_height_m = maxf(_max_height_m, height_m)
	var meters: int = floori(_max_height_m)
	if meters > _reported_meters:
		_reported_meters = meters
		Events.height_changed.emit(meters)
