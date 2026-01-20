class_name TileDefinition
extends Resource

@export var walkable := true


func on_enter(_actor: Node, _board: BoardController, _cell: Vector2i)-> void: pass
func on_exit(_actor: Node, _board: BoardController, _cell: Vector2i)-> void: pass
func on_stay(_actor: Node, _board: BoardController, _cell: Vector2i)-> void: pass

enum Type { 
	WALL,
	SOLID,
	CRUMBLING,
	VOID,
	CONVEYOR,
	ENABLED,
	DISABLED,
	BUTTON,
	BUTTON_ENABLED,
	BUTTON_DISABLED,
}

const atlas_coords : Dictionary[Type, Vector2i] = {
	Type.SOLID: Vector2i(10,0),
	Type.WALL: Vector2i(11,0),
	Type.CRUMBLING: Vector2i(12,0),
	Type.VOID: Vector2i(13,0),
	Type.ENABLED: Vector2i(14,0),
	Type.DISABLED: Vector2i(14,1),
	Type.BUTTON: Vector2i(10, 2),
	Type.BUTTON_DISABLED: Vector2i(11, 2),
	Type.BUTTON_ENABLED: Vector2i(12, 2),
}

static func get_atlas_coords(type: Type) -> Vector2i:
	return  atlas_coords.get(type)
