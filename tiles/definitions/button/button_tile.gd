class_name ButtonTile
extends TileDefinition

func _init() -> void:
	walkable = true


func on_enter(_actor: Node, board: BoardController, cell: Vector2i) -> void:
	board.request_button(cell)
