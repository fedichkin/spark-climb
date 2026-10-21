## Base class for unit tests. A test file extends TestCase and defines
## methods whose names start with `test_`. Failed assertions are recorded
## in `failures` instead of stopping the test; the runner reads them.
class_name TestCase
extends RefCounted

## Failure messages collected during the current test method.
var failures: PackedStringArray = PackedStringArray()


## Clears recorded failures. Called by the runner before each test method.
func reset_failures() -> void:
	failures.clear()


func assert_eq(actual: Variant, expected: Variant, message: String = "") -> void:
	if not _values_equal(actual, expected):
		_fail("expected %s, got %s" % [_describe(expected), _describe(actual)], message)


func assert_true(condition: bool, message: String = "") -> void:
	if not condition:
		_fail("expected true, got false", message)


func assert_almost_eq(actual: float, expected: float, tolerance: float = 0.0001, message: String = "") -> void:
	if absf(actual - expected) > tolerance:
		_fail("expected %s ± %s, got %s" % [expected, tolerance, actual], message)


## Compares values without runtime errors on mismatched types
## (int and float are treated as comparable).
func _values_equal(a: Variant, b: Variant) -> bool:
	var a_type: int = typeof(a)
	var b_type: int = typeof(b)
	var numeric: Array[int] = [TYPE_INT, TYPE_FLOAT]
	if a_type != b_type and not (a_type in numeric and b_type in numeric):
		return false
	return a == b


func _describe(value: Variant) -> String:
	return "%s (%s)" % [str(value), type_string(typeof(value))]


func _fail(reason: String, message: String) -> void:
	failures.append(reason if message.is_empty() else "%s: %s" % [message, reason])
