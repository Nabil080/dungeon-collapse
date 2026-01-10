class_name VoidTile
extends TileDefinition

const atlas_coords := Vector2i(9 , 6)

func _init() -> void:
	walkable = true # stepping in is allowed, player may fall later

func on_enter(actor: Node, _board: BoardController)-> void:
	if actor.has_method("fall"):
		actor.call("fall")
