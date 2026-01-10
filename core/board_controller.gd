class_name BoardController
extends Node

## Interacts with the game grid (Floor tilemap)
## Converts between world and grid coordinates
## Owns tile mutation and environment resolution

const TILE_SIZE := Vector2i(16, 16)
const TILE_CENTER := Vector2i(8, 8)

@export var floor_tilemap: TileMapLayer
@export var void_atlas_coords := Vector2i(9, 6)

var pending_collapses: Array[Vector2i] = []


func _ready() -> void:
	assert(floor_tilemap, "Tilemap reference missing from BoardController")


#region Position

func global_to_map(global_pos: Vector2) -> Vector2i:
	return floor_tilemap.local_to_map(global_pos)

func map_to_global(map_pos: Vector2i) -> Vector2:
	return floor_tilemap.map_to_local(map_pos)

func global_to_centered(global_pos: Vector2) -> Vector2:
	return map_to_global(global_to_map(global_pos))

#endregion


#region Tiles

## Returns the [TileDefinition] of the cell
func get_tile_def(cell: Vector2i) -> TileDefinition:
	var data := floor_tilemap.get_cell_tile_data(cell)
	return data.get_custom_data("tile_def") if data else null


## Calls [TileDefinition.on_exit] for the given [param cell]
func on_tile_exited(actor: Node, cell: Vector2i) -> void:
	var tile := get_tile_def(cell)
	if tile:
		tile.on_exit(actor, self, cell)


## Calls [TileDefinition.on_enter] for the given [param cell]
func on_tile_entered(actor: Node, cell: Vector2i) -> void:
	var tile := get_tile_def(cell)
	if tile:
		tile.on_enter(actor, self, cell)


#endregion


#region Environment Resolution

## Called once per action
func resolve_environment() -> void:
	# Crumbling tiles
	for cell in pending_collapses:
		change_tile(cell, void_atlas_coords)

	pending_collapses.clear()

	# Conveyors (future)
	# Buttons / Toggleables (future)
	# Portals (future)

#endregion


#region Mutation Requests

func request_collapse(cell: Vector2i) -> void:
	if not pending_collapses.has(cell):
		pending_collapses.append(cell)


func change_tile(cell: Vector2i, atlas_coords: Vector2i) -> void:
	floor_tilemap.set_cell(cell, 0, atlas_coords, 0)
	floor_tilemap.update_internals()

#endregion
