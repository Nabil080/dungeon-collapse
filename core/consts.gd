class_name Consts
extends RefCounted

const TILE_SIZE := Vector2i(16, 16)
const TILE_CENTER := Vector2i(8, 8)
const GRID_SIZE := Vector2i(20, 15)

enum TileType { FLOOR, WALL, DOOR, EMPTY }

class Tile:
	var type : TileType        # floor, wall, door, empty
	var has_floor : bool       # bool
	var collapse_timer : float # float or null

const COLLAPSE_TIME : float = 2.0
