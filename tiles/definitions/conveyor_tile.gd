class_name ConveyorTile
extends TileDefinition

class Movement:
	var actor: Node
	var direction: Vector2i

func _init() -> void:
	walkable = true # stepping on it is allowed


## Requests death when entered
func on_enter(actor: Node, board: BoardController, cell: Vector2i) -> void:
	var movement := Movement.new()
	movement.actor = actor
	movement.direction = board.get_tile_custom_data(cell, "direction")
	board.request_forced_move(movement)
