## Tests for LandingMath.evaluate (GAME_SPEC §6).
extends TestCase

const PLATFORM_X: float = 360.0
const WIDTH: float = 140.0
const RATIO: float = 0.35
## Half of the perfect zone for the values above: 140 * 0.35 / 2.
const HALF_ZONE: float = 24.5


func test_center_is_perfect() -> void:
	assert_eq(_evaluate(PLATFORM_X), LandingMath.Quality.PERFECT)


func test_zone_edge_is_perfect() -> void:
	assert_eq(_evaluate(PLATFORM_X + HALF_ZONE), LandingMath.Quality.PERFECT, "right edge")
	assert_eq(_evaluate(PLATFORM_X - HALF_ZONE), LandingMath.Quality.PERFECT, "left edge")


func test_outside_zone_is_normal() -> void:
	assert_eq(_evaluate(PLATFORM_X + HALF_ZONE + 0.1), LandingMath.Quality.NORMAL, "right")
	assert_eq(_evaluate(PLATFORM_X - HALF_ZONE - 0.1), LandingMath.Quality.NORMAL, "left")


func test_platform_edge_is_normal() -> void:
	assert_eq(_evaluate(PLATFORM_X + WIDTH / 2.0), LandingMath.Quality.NORMAL)


func test_left_and_right_are_symmetric() -> void:
	for offset: float in [0.0, 10.0, 24.0, 24.5, 25.0, 60.0]:
		assert_eq(_evaluate(PLATFORM_X - offset), _evaluate(PLATFORM_X + offset), "offset %s" % offset)


func test_zone_scales_with_ratio() -> void:
	# With ratio 1.0 the whole platform is the perfect zone.
	assert_eq(LandingMath.evaluate(PLATFORM_X + 70.0, PLATFORM_X, WIDTH, 1.0), LandingMath.Quality.PERFECT)
	# With ratio 0.0 only the exact center counts.
	assert_eq(LandingMath.evaluate(PLATFORM_X + 1.0, PLATFORM_X, WIDTH, 0.0), LandingMath.Quality.NORMAL)


func _evaluate(player_x: float) -> LandingMath.Quality:
	return LandingMath.evaluate(player_x, PLATFORM_X, WIDTH, RATIO)
