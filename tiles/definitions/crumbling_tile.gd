class_name CrumblingTile
extends TileDefinition

func _init() -> void:
	walkable = true

func on_exit(actor: Node, board: BoardController)-> void:
	# Get cell coords
	var cell : Vector2i = actor.get("previous_grid_pos")
	if not cell:
		return
		
	# Crumble delay
	print("Crumbling cell")
	if actor.has_signal("action_resolved"):
		await actor["action_resolved"]
	_crumble(cell, board)


func _crumble(cell: Vector2i, board: BoardController)-> void:
	board.change_tile(cell, VoidTile.atlas_coords)
