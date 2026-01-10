class_name BoardController
extends Node

@export var floor_tilemap : TileMapLayer

func _physics_process(_delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var map_pos := _global_to_map(mouse_pos)
	print(map_pos)


## Returns the map position equivalent of [param global_pos]
func _global_to_map(global_pos: Vector2) -> Vector2i:
	return floor_tilemap.local_to_map(global_pos)
