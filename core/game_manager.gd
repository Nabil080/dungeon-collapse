#class_name Gamemanger
extends Node

## Autoload to manage the current game data

var has_key := false
var can_open_door: bool:
	get: return has_key

var score := 0

# Levels
var current_level := 0:
	set = _set_current_level
const LEVELS : Array[String] = [
	"res://levels/level_solid.tscn",
	"res://levels/level_crumble.tscn",
	"res://levels/level_alternating.tscn",
	"res://levels/level_conveyers.tscn",
	"res://levels/level_button.tscn",
	"res://levels/test_level.tscn",
]


func _ready() -> void:
	_set_current_level.call_deferred(0)

func _set_current_level(value: int) -> void:
	var level_path : String = LEVELS.get(value)
	if not level_path:
		return
	
	current_level = value
	has_key = false
	get_tree().change_scene_to_file(LEVELS[value])

func next_level() -> void:
	var next_index := current_level + 1
	if next_index >= LEVELS.size():
		print("No more levels")
		current_level = 0
	else:
		current_level += 1
