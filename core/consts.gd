class_name Consts
extends RefCounted

const TILE_SIZE : int = 16
const GRID_WIDTH : int = 20
const GRID_HEIGHT : int = 15

enum TileType { FLOOR, WALL, DOOR, EMPTY }

class Tile:
	var type : TileType        # floor, wall, door, empty
	var has_floor : bool       # bool
	var collapse_timer : float # float or null

const COLLAPSE_TIME : float = 2.0
