class_name VoidTile
extends TileDefinition

## A hole. You can step on it, and you fall.


func _init() -> void:
	walkable = true


func on_enter(actor: Node, _board: BoardController, _cell: Vector2i) -> void:
	if actor.has_method("request_death"):
		actor.call("request_death")
