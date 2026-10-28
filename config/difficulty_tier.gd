## One step of the difficulty curve (GAME_SPEC §10). A tier applies from
## `min_height_m` (inclusive) up to the next tier's `min_height_m` (exclusive).
## Type weights and moving platform speeds are added in M3.
class_name DifficultyTier
extends Resource

## Height where this tier starts, meters (inclusive).
@export var min_height_m: float = 0.0
## Smallest vertical gap between consecutive platforms, px.
@export var gap_min: float = 90.0
## Largest vertical gap between consecutive platforms, px.
## Must stay within 80% of the normal jump height (reachability invariant).
@export var gap_max: float = 150.0
