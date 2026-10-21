## Placeholder tests proving the test framework works.
## Remove once real tests (e.g. test_landing_math.gd) exist.
extends TestCase


func test_equality() -> void:
	assert_eq(2 + 2, 4)
	assert_eq("Іскра".length(), 5)


func test_condition() -> void:
	assert_true([1, 2, 3].has(2))


func test_float_comparison() -> void:
	assert_almost_eq(0.1 + 0.2, 0.3)
