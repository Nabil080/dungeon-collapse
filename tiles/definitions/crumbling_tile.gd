class_name TileCrumbling
extends TileDefinition

func _init() -> void:
	walkable = true

func on_exit(actor: Variant, board: BoardController):
	print("Tile should collapse")
