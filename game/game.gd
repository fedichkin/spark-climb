## Run scene root: wires the systems together and starts the run.
## For now places a temporary full-width floor (replaced by the generated
## start platform in M2 task 3) and the hero standing on it.
extends Node2D

@export var config: GameConfig

@onready var _floor: Platform = $Platforms/Floor
@onready var _player: Player = $Player
@onready var _generator: PlatformGenerator = $PlatformGenerator


func _ready() -> void:
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	var floor_y: float = screen_size.y - config.start_platform_bottom_offset
	_floor.position = Vector2(screen_size.x / 2.0, floor_y)
	_floor.setup(screen_size.x)
	var floor_top_y: float = floor_y - config.platform_size.y / 2.0
	_player.position = Vector2(screen_size.x / 2.0, floor_top_y - config.player_radius)
	_generator.start(floor_y, randi())
