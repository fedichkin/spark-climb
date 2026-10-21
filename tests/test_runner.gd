## Headless test runner:
##   godot --headless --path . -s res://tests/test_runner.gd
## Finds tests/test_*.gd, runs every `test_*` method of each TestCase,
## prints a summary and exits with code 0 (all passed) or 1 (failures).
extends SceneTree

const TESTS_DIR: String = "res://tests/"
## Infrastructure scripts that match test_*.gd but contain no tests.
const SKIPPED_FILES: Array[String] = ["test_runner.gd", "test_case.gd"]

var _passed: int = 0
var _failed: int = 0


func _initialize() -> void:
	var files: Array[String] = _find_test_files()
	if files.is_empty():
		push_error("No test files found in %s" % TESTS_DIR)
		quit(1)
		return
	for file_name: String in files:
		_run_file(file_name)
	print("Tests: %d passed, %d failed" % [_passed, _failed])
	quit(1 if _failed > 0 else 0)


func _find_test_files() -> Array[String]:
	var result: Array[String] = []
	for file_name: String in DirAccess.get_files_at(TESTS_DIR):
		if file_name.begins_with("test_") and file_name.ends_with(".gd") and file_name not in SKIPPED_FILES:
			result.append(file_name)
	result.sort()
	return result


func _run_file(file_name: String) -> void:
	var script: GDScript = load(TESTS_DIR + file_name) as GDScript
	if script == null or not _extends_test_case(script):
		push_warning("Skipping %s: not a TestCase script" % file_name)
		return
	var test_case: TestCase = script.new()
	print(file_name)
	for method: Dictionary in script.get_script_method_list():
		var method_name: String = method["name"]
		if method_name.begins_with("test_"):
			_run_test(test_case, method_name)


func _run_test(test_case: TestCase, method_name: String) -> void:
	test_case.reset_failures()
	test_case.call(method_name)
	if test_case.failures.is_empty():
		_passed += 1
		print("  ✓ %s" % method_name)
	else:
		_failed += 1
		print("  ✗ %s" % method_name)
		for failure: String in test_case.failures:
			print("      %s" % failure)


## Checks the inheritance chain without instantiating the script.
func _extends_test_case(script: Script) -> bool:
	var current: Script = script
	while current != null:
		if current == TestCase:
			return true
		current = current.get_base_script()
	return false
