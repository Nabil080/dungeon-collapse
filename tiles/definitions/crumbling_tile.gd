class_name TileCrumbling
extends TileDefinition

func _init() -> void:
	walkable = true

func on_exit(actor: Node, board: BoardController)-> void:
	print("Tile should collapse")
