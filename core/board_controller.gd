class_name BoardController
extends Node

## Interacts with the game grid (Floor tilemap)
## Converts between world and grid coordinates
## Owns tile mutation and environment resolution

const TILE_SIZE := Vector2i(16, 16)
const TILE_CENTER := Vector2i(8, 8)

@export var floor_tilemap: TileMapLayer

var pending_collapses: Array[Vector2i] = []
var forced_moves: Array[ConveyorTile.Movement] = []


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
	return data.get_custom_data("tile_def")

## Returns the custom_data [param data_name] of the cell
func get_tile_custom_data(cell: Vector2i, data_name: String) -> Variant:
	var data := floor_tilemap.get_cell_tile_data(cell)
	return data.get_custom_data(data_name)


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

func start_of_turn() -> void:
	# Alternating tiles
	for cell in floor_tilemap.get_used_cells():
		var tile_def : = get_tile_def(cell)
		if tile_def is EnabledTile: change_tile(cell, TileDefinition.get_atlas_coords(TileDefinition.Type.DISABLED))
		elif tile_def is DisabledTile: change_tile(cell, TileDefinition.get_atlas_coords(TileDefinition.Type.ENABLED))
	print("Done 1")


## Called once per action
func resolve_environment() -> void:
	# Crumbling tiles
	for cell in pending_collapses:
		change_tile(cell, TileDefinition.get_atlas_coords(TileDefinition.Type.VOID))
	pending_collapses.clear()

	# Conveyors tiles
	print("======== Conveyers =========")
	print(forced_moves.size())
	while forced_moves:
		var movement : ConveyorTile.Movement = forced_moves.pop_front()
		if movement.actor.has_method("_try_move"):
			movement.actor.call("_try_move", movement.direction)
	
	
	# Buttons / Toggleables (future)
	# Portals (future)

#endregion


#region Mutation Requests


func request_collapse(cell: Vector2i) -> void:
	if not pending_collapses.has(cell):
		pending_collapses.append(cell)

# Swapping collapsing to void
func change_tile(cell: Vector2i, atlas_coords: Vector2i) -> void:
	floor_tilemap.set_cell(cell, 0, atlas_coords, 0)
	floor_tilemap.update_internals()


func request_forced_move(movement: ConveyorTile.Movement) -> void:
	forced_moves.append(movement)

#endregion
