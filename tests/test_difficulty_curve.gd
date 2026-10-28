## Tests for DifficultyCurve (GAME_SPEC §9, §10) and the difficulty tiers
## stored in config/game_config.tres.
extends TestCase

const CONFIG_PATH: String = "res://config/game_config.tres"
## Reachability invariant: max gap ≤ this share of the normal jump height.
const MAX_GAP_JUMP_RATIO: float = 0.8

var _config: GameConfig = load(CONFIG_PATH) as GameConfig


func test_config_has_four_tiers_starting_at_zero() -> void:
	assert_eq(_config.difficulty_tiers.size(), 4)
	assert_eq(_config.difficulty_tiers[0].min_height_m, 0.0)


func test_tiers_are_sorted_by_height() -> void:
	var tiers: Array[DifficultyTier] = _config.difficulty_tiers
	for i: int in range(1, tiers.size()):
		assert_true(tiers[i].min_height_m > tiers[i - 1].min_height_m, "tier %d" % i)


func test_tier_lower_bound_is_inclusive() -> void:
	assert_eq(_tier_index(0.0), 0, "0 m")
	assert_eq(_tier_index(29.9), 0, "29.9 m")
	assert_eq(_tier_index(30.0), 1, "30 m")
	assert_eq(_tier_index(99.9), 1, "99.9 m")
	assert_eq(_tier_index(100.0), 2, "100 m")
	assert_eq(_tier_index(199.9), 2, "199.9 m")
	assert_eq(_tier_index(200.0), 3, "200 m")
	assert_eq(_tier_index(5000.0), 3, "5000 m")


func test_negative_height_uses_first_tier() -> void:
	assert_eq(_tier_index(-5.0), 0)


func test_gaps_are_valid_and_reachable() -> void:
	var jump_height: float = _config.jump_velocity * _config.jump_velocity / (2.0 * _config.gravity)
	var limit: float = jump_height * MAX_GAP_JUMP_RATIO
	for tier: DifficultyTier in _config.difficulty_tiers:
		var label: String = "tier from %s m" % tier.min_height_m
		assert_true(tier.gap_min > 0.0, label + ": gap_min > 0")
		assert_true(tier.gap_min <= tier.gap_max, label + ": gap_min <= gap_max")
		assert_true(tier.gap_max <= limit, label + ": gap_max %s <= %s" % [tier.gap_max, limit])


func test_scroll_speed_starts_at_base() -> void:
	assert_almost_eq(_scroll_speed(0.0), 35.0)


func test_scroll_speed_grows_with_height() -> void:
	assert_almost_eq(_scroll_speed(50.0), 35.0 + 50.0 * 0.8)


func test_scroll_speed_is_capped() -> void:
	assert_almost_eq(_scroll_speed(156.25), 160.0, 0.0001, "exactly at cap")
	assert_almost_eq(_scroll_speed(1000.0), 160.0, 0.0001, "far above cap")


func test_scroll_speed_ignores_negative_height() -> void:
	assert_almost_eq(_scroll_speed(-10.0), 35.0)


func _tier_index(height_m: float) -> int:
	var tiers: Array[DifficultyTier] = _config.difficulty_tiers
	return tiers.find(DifficultyCurve.tier_for_height(tiers, height_m))


func _scroll_speed(height_m: float) -> float:
	return DifficultyCurve.scroll_speed(
		height_m, _config.scroll_base_speed, _config.scroll_speed_per_meter, _config.scroll_max_speed)
