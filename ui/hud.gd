## In-run HUD: shows the current height in meters (GAME_SPEC §11).
## Only listens to Events; never touches the game state.
extends Control

@onready var _height_label: Label = $HeightLabel


func _ready() -> void:
	Events.height_changed.connect(_on_height_changed)
	_on_height_changed(0)


func _on_height_changed(meters: int) -> void:
	_height_label.text = "%d м" % meters
