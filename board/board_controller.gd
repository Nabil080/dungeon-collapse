class_name BoardController
extends Node

const TILE_SIZE := Vector2i(16, 16)
const TILE_CENTER := Vector2i(8, 8)

@export var floor_tilemap : TileMapLayer

#region testing

func _process(_delta: float) -> void:
	#var pos := get_viewport().get_mouse_position()
	#print(is_walkable(global_to_map(pos)))
	pass
	
#endregion

#region position

## Returns the map position equivalent of [param global_pos]
func global_to_map(global_pos: Vector2) -> Vector2i:
	return floor_tilemap.local_to_map(global_pos)

## Returns the global position equivalent of [param map_pos]
func map_to_global(map_pos: Vector2) -> Vector2i:
	return floor_tilemap.map_to_local(map_pos)

## Returns the centered position equivalent of [param global_pos]
func global_to_centered(global_pos: Vector2) -> Vector2:
	return map_to_global(global_to_map(global_pos))

#endregion
#region Tiles

## returns true if [param cell] is walkable based on the tile custom data 'walkable'
func is_walkable(cell: Vector2i) -> bool:
	var data := floor_tilemap.get_cell_tile_data(cell)
	return data.get_custom_data("walkable") if data else false

#endregion
