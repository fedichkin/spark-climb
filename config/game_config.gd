## Single source of truth for gameplay balance parameters.
## Values come from docs/GAME_SPEC.md §13; tune them in config/game_config.tres
## via the inspector instead of editing code.
class_name GameConfig
extends Resource

@export_group("Player")
## Downward acceleration applied every physics frame, px/s².
@export var gravity: float = 2000.0
## Upward speed given on every landing (before the platform multiplier), px/s.
@export var jump_velocity: float = 1250.0
## Upper limit of horizontal hero speed, px/s.
@export var max_horizontal_speed: float = 900.0
## Radius of the hero circle (visual and collision), px.
@export var player_radius: float = 22.0
## When true, leaving one side of the screen brings the hero in from the other.
@export var screen_wrap: bool = true

@export_group("Controls")
## Hero offset per pixel of horizontal finger movement.
@export var drag_sensitivity: float = 1.4
## Keyboard speed as a fraction of max_horizontal_speed (PC only).
@export var keyboard_speed_ratio: float = 0.6

@export_group("Platforms")
## Default platform size (width set by the spawner, height used as is), px.
@export var platform_size: Vector2 = Vector2(140.0, 22.0)
## Bounce velocity multiplier of the spring platform.
@export var spring_multiplier: float = 1.8
## Duration of the crumbling platform's break-apart animation, s.
@export var crumble_duration: float = 0.25

@export_group("Landing")
## Share of platform width (centered) that counts as a PERFECT landing.
@export_range(0.0, 1.0) var perfect_zone_ratio: float = 0.35
