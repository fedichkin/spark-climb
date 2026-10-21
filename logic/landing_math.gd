## Pure landing-quality math: decides whether a landing hit the platform's
## central zone. Has no state and no scene dependencies, so it is unit-tested.
class_name LandingMath
extends RefCounted

enum Quality { NORMAL, PERFECT }


## Returns PERFECT when the hero's center is within the central
## `perfect_zone_ratio` share of the platform width (zone edge included).
static func evaluate(player_x: float, platform_x: float, platform_width: float, perfect_zone_ratio: float) -> Quality:
	var half_zone: float = platform_width * perfect_zone_ratio / 2.0
	if absf(player_x - platform_x) <= half_zone:
		return Quality.PERFECT
	return Quality.NORMAL
