class_name TurnManager
extends Node

## Turn State Machine
# PLAYER_TURN
# PLAYER_RESOLVING
# ENVIRONMENT_RESOLVING
# ENEMY_TURN
# PAUSED

enum States {
	PLAYER_TURN,
	PLAYER_RESOLVING,
	ENVIRONMENT_RESOLVING,
	ENEMY_TURN,
	PAUSED
}

@export var player: Player
@export var board: BoardController

var state: States = States.PLAYER_TURN : set = _enter_state


func _ready() -> void:
	assert(player)
	assert(board)

	player.action_started.connect(_on_player_action_started)
	player.action_resolved.connect(_on_player_action_resolved)
	player.dying.connect(func ()->void: state = States.PAUSED)
	player.died.connect(func ()->void: get_tree().reload_current_scene())


## Player action started
func _on_player_action_started() -> void:
	if state == States.PLAYER_TURN:
		state = States.PLAYER_RESOLVING


## Player action finished (logic + animation)
func _on_player_action_resolved() -> void:
	if state == States.PLAYER_RESOLVING:
		state = States.PLAYER_TURN


func _enter_state(value: States) -> void:
	print(States.find_key(value), " Started")
	state = value
	match state:

		States.PLAYER_TURN:
			pass # Input allowed

		States.PLAYER_RESOLVING:
			pass # Player logic already ran

		States.ENVIRONMENT_RESOLVING:
			pass

		States.ENEMY_TURN:
			pass

		States.PAUSED:
			pass # Death / freeze
