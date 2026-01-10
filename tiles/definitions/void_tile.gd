class_name VoidTile
extends TileDefinition

func _init() -> void:
	walkable = true # stepping in is allowed, player may fall later

func on_enter(actor: Node, _board: BoardController)-> void:
	if actor.has_method("fall"):
		actor.call("fall")
