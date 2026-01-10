class_name CrumblingTile
extends TileDefinition

func _init() -> void:
	walkable = true


func on_exit(_actor: Node, board: BoardController, cell: Vector2i) -> void:
	board.request_collapse(cell)
