class_name VoidTile
extends TileDefinition

func _init() -> void:
	walkable = true # stepping in is allowed, player may fall later

func on_enter(actor: Variant, board: BoardController):
	print("Player should fall")
