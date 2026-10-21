## Temporary M1 playground: hand-placed platforms, a full-width floor so the
## hero never falls off screen, and landing quality printed to the console.
## Replaced by the real Game scene in M2.
extends Node2D

@onready var _player: Player = $Player
@onready var _floor: Platform = $Platforms/Floor


func _ready() -> void:
	var screen_width: float = get_viewport().get_visible_rect().size.x
	_floor.position.x = screen_width / 2.0
	_floor.setup(screen_width)
	_player.landed.connect(_on_player_landed)


func _on_player_landed(platform: Platform, quality: LandingMath.Quality) -> void:
	var dx: float = _player.global_position.x - platform.global_position.x
	print("Landed on %s: %s (dx = %.1f px)" % [platform.name, LandingMath.Quality.keys()[quality], dx])
