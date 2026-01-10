class_name BoardController
extends Node

## Interacts with the game grid (Floor tilemap) [br]
## Converts from world coordinates to grid coordinates [br]
## Returns TileDefinitions of a given cell [br]
## Calls the tiles lifecycle hooks [br]

const TILE_SIZE := Vector2i(16, 16)
const TILE_CENTER := Vector2i(8, 8)

@export var floor_tilemap : TileMapLayer

func _ready() -> void:
	assert(floor_tilemap, "Tilemap reference missing from BoardController")


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

## Returns the [TileDefinition] of the cell
func get_tile_def(cell: Vector2i) -> TileDefinition:
	var data := floor_tilemap.get_cell_tile_data(cell)
	return data.get_custom_data("tile_def") if data else null


## Calls [method TileDefinition.on_enter] for the given [param cell]
func on_tile_entered(actor: Node, cell: Vector2i) -> void:
	#print("Entering tile ", cell)
	get_tile_def(cell).on_enter(actor, self)
	
## Calls [method TileDefinition.on_exit] for the given [param cell]
func on_tile_exited(actor: Node, cell: Vector2i) -> void:
	#print("Exiting tile ", cell)
	get_tile_def(cell).on_exit(actor, self)

#endregion
