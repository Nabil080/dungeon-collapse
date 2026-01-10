class_name TurnManager
extends Node

## Turn State Machine
# TURN START
# Player action
# Player movement resolves
# Tile enter / exit hooks
# Turn resolution
# TURN END

enum States { PLAYER_TURN, PLAYER_RESOLVING, PAUSED }

@export var player : Player

var current_state : States = States.PLAYER_TURN : set = _on_state_change


func _ready() -> void:
	assert(player, "Player reference missing in TurnManager")
	
	# Player hooks
	player.action_started.connect(
		func _on_player_action_started() -> void: current_state = States.PLAYER_RESOLVING
	)
	player.action_resolved.connect(
		func _on_player_action_resolved() -> void: current_state = States.PLAYER_TURN
	)
	player.dying.connect(
		func _on_player_dying() -> void: current_state = States.PAUSED
	)
	player.died.connect(
		func _on_player_dying() -> void: get_tree().reload_current_scene()
	)


## Turn Logger
func _on_state_change(value: States)-> void:
	print(States.find_key(value), " Started")
	current_state = value
