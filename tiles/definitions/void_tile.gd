class_name VoidTile
extends TileDefinition


func _init() -> void:
	walkable = true # stepping on it is allowed


## Requests death when entered
func on_enter(actor: Node, _board: BoardController, _cell: Vector2i) -> void:
	print("Void tile")
	if actor.has_method("request_death"):
		actor.call("request_death")
