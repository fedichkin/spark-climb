## Pure difficulty math: picks the difficulty tier for a height and computes
## the camera auto-scroll speed (GAME_SPEC §9, §10). Values come in as
## parameters, so the class has no scene or config dependencies.
class_name DifficultyCurve
extends RefCounted


## Returns the tier whose range contains `height_m`. `tiers` must be sorted
## by min_height_m ascending; heights below the first tier use the first one.
static func tier_for_height(tiers: Array[DifficultyTier], height_m: float) -> DifficultyTier:
	assert(not tiers.is_empty(), "difficulty_tiers must not be empty")
	var result: DifficultyTier = tiers[0]
	for tier: DifficultyTier in tiers:
		if height_m >= tier.min_height_m:
			result = tier
		else:
			break
	return result


## Auto-scroll speed in px/s: grows linearly with height, capped at max_speed.
static func scroll_speed(height_m: float, base_speed: float, speed_per_meter: float, max_speed: float) -> float:
	return minf(base_speed + maxf(height_m, 0.0) * speed_per_meter, max_speed)
