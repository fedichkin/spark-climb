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

@export_group("Camera")
## Follow line as a share of screen height from the top: the camera rises
## whenever the hero is above it.
@export_range(0.0, 1.0) var camera_follow_ratio: float = 0.4
## Auto-scroll speed right after it starts, px/s.
@export var scroll_base_speed: float = 35.0
## Auto-scroll speed gained per meter of height, px/s.
@export var scroll_speed_per_meter: float = 0.8
## Auto-scroll speed cap (reached at ≈ 156 m), px/s.
@export var scroll_max_speed: float = 160.0

@export_group("Generation")
## World units: how many pixels make one meter of height.
@export var pixels_per_meter: float = 100.0
## How far above the camera top platforms are created, in screen heights.
@export var spawn_ahead_screens: float = 1.5
## Platforms this far below the camera bottom are freed, px.
@export var despawn_margin: float = 200.0
## Minimal gap between a platform and the screen edge, px.
@export var horizontal_margin: float = 10.0
## Distance from the visible area bottom to the start platform center, px.
@export var start_platform_bottom_offset: float = 120.0
## Difficulty steps by height, sorted by min_height_m (GAME_SPEC §10).
@export var difficulty_tiers: Array[DifficultyTier] = []

@export_group("Feel")
## Pause after losing before the game reacts to touches (and, from M5,
## before the game over screen appears), s.
@export var game_over_delay: float = 0.5
