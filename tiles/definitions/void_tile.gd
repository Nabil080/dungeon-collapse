class_name VoidTile
extends TileDefinition

const atlas_coords := Vector2i(9, 6)

func _init() -> void:
	walkable = true # stepping on it is allowed


## Requests death when entered
func on_enter(actor: Node, _board: BoardController, _cell: Vector2i) -> void:
	if actor.has_method("request_death"):
		actor.call("request_death")
