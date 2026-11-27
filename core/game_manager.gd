extends Node

## Autoload: the current level and whether the player holds the key.

const LEVELS: Array[String] = [
	"res://levels/level_solid.tscn",
	"res://levels/level_crumble.tscn",
	"res://levels/level_alternating.tscn",
	"res://levels/level_conveyers.tscn",
	"res://levels/level_button.tscn",
	"res://levels/test_level.tscn",
]

var has_key := false
var can_open_door: bool:
	get: return has_key

var current_level := 0:
	set = _set_current_level


func _ready() -> void:
	_set_current_level.call_deferred(0)


func _set_current_level(value: int) -> void:
	var level_path: String = LEVELS.get(value)
	if not level_path:
		return

	current_level = value
	has_key = false
	get_tree().change_scene_to_file(level_path)


## After the last level the game starts over from the first one.
func next_level() -> void:
	if current_level + 1 >= LEVELS.size():
		current_level = 0
	else:
		current_level += 1
