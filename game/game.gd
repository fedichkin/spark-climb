## Run scene root: wires the systems together and starts the run.
## Starts the generator and puts the hero at rest on the start platform.
extends Node2D

@export var config: GameConfig

@onready var _player: Player = $Player
@onready var _generator: PlatformGenerator = $PlatformGenerator


func _ready() -> void:
	var start_platform: Platform = _generator.start(randi())
	var platform_top_y: float = start_platform.position.y - config.platform_size.y / 2.0
	_player.position = Vector2(start_platform.position.x, platform_top_y - config.player_radius)
