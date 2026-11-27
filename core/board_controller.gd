class_name BoardController
extends Node

## Owns the Floor tilemap: converts between world and grid positions,
## runs the tile effects and changes tiles when they collapse or switch.

@export var floor_tilemap: TileMapLayer

var pending_collapses: Array[Vector2i] = []
var forced_moves: Array[ConveyorTile.Movement] = []


func _ready() -> void:
	assert(floor_tilemap, "Tilemap reference missing from BoardController")


#region Position

func global_to_map(global_pos: Vector2) -> Vector2i:
	var local_pos := floor_tilemap.to_local(global_pos)
	return floor_tilemap.local_to_map(local_pos)


func map_to_global(map_pos: Vector2i) -> Vector2:
	var local_pos := floor_tilemap.map_to_local(map_pos)
	return floor_tilemap.to_global(local_pos)

#endregion


#region Tiles

func get_tile_def(cell: Vector2i) -> TileDefinition:
	var data := floor_tilemap.get_cell_tile_data(cell)
	return data.get_custom_data("tile_def")


func get_tile_custom_data(cell: Vector2i, data_name: String) -> Variant:
	var data := floor_tilemap.get_cell_tile_data(cell)
	return data.get_custom_data(data_name)


func on_tile_exited(actor: Node, cell: Vector2i) -> void:
	var tile := get_tile_def(cell)
	if tile:
		tile.on_exit(actor, self, cell)


func on_tile_entered(actor: Node, cell: Vector2i) -> void:
	var tile := get_tile_def(cell)
	if tile:
		tile.on_enter(actor, self, cell)

#endregion


#region Environment resolution

## Called before each player move: alternating tiles switch.
func start_of_turn() -> void:
	for cell in floor_tilemap.get_used_cells():
		var tile_def := get_tile_def(cell)
		if tile_def is EnabledTile:
			change_tile(cell, TileDefinition.get_atlas_coords(TileDefinition.Type.DISABLED))
		elif tile_def is DisabledTile:
			change_tile(cell, TileDefinition.get_atlas_coords(TileDefinition.Type.ENABLED))


## Called after each player move, once the tiles have queued their effects.
func resolve_environment() -> void:
	for cell in pending_collapses:
		change_tile(cell, TileDefinition.get_atlas_coords(TileDefinition.Type.VOID))
	pending_collapses.clear()

	while forced_moves:
		var movement: ConveyorTile.Movement = forced_moves.pop_front()
		if movement.actor.has_method("_try_move"):
			movement.actor.call("_try_move", movement.direction)

#endregion


#region Mutation requests

func request_collapse(cell: Vector2i) -> void:
	if not pending_collapses.has(cell):
		pending_collapses.append(cell)


func change_tile(cell: Vector2i, atlas_coords: Vector2i) -> void:
	floor_tilemap.set_cell(cell, 0, atlas_coords, 0)
	floor_tilemap.update_internals()


func request_forced_move(movement: ConveyorTile.Movement) -> void:
	forced_moves.append(movement)


## Any button flips every button-controlled tile of the level.
func request_button(_cell: Vector2i) -> void:
	for cell in floor_tilemap.get_used_cells():
		var tile_def := get_tile_def(cell)
		if tile_def is ButtonEnabledTile:
			change_tile(cell, TileDefinition.get_atlas_coords(TileDefinition.Type.BUTTON_DISABLED))
		elif tile_def is ButtonDisabledTile:
			change_tile(cell, TileDefinition.get_atlas_coords(TileDefinition.Type.BUTTON_ENABLED))

#endregion
