class_name TileDefinition
extends Resource

@export var walkable := true

func on_enter(_actor: Node, _board: BoardController)-> void: pass
func on_exit(_actor: Node, _board: BoardController)-> void: pass
func on_stay(_actor: Node, _board: BoardController)-> void: pass
