#class_name Gamemanger
extends Node

## Autoload to manage the current game data

var has_key := false
var can_open_door: bool:
	get: return has_key

var score := 0
