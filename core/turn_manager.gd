class_name TurnManager
extends Node

## The player can only act during PLAYER_TURN. A move switches to
## PLAYER_RESOLVING until its animation is over, so inputs pressed
## in the meantime are ignored.
## ENVIRONMENT_RESOLVING and ENEMY_TURN were planned for enemies and never used.

enum States {
	PLAYER_TURN,
	PLAYER_RESOLVING,
	ENVIRONMENT_RESOLVING,
	ENEMY_TURN,
	PAUSED,
}

@export var player: Player
@export var board: BoardController

var state: States = States.PLAYER_TURN


func _ready() -> void:
	assert(player)
	assert(board)

	player.action_started.connect(_on_player_action_started)
	player.action_resolved.connect(_on_player_action_resolved)
	player.dying.connect(func() -> void: state = States.PAUSED)
	player.died.connect(func() -> void: get_tree().reload_current_scene())


func _on_player_action_started() -> void:
	if state == States.PLAYER_TURN:
		state = States.PLAYER_RESOLVING


func _on_player_action_resolved() -> void:
	if state == States.PLAYER_RESOLVING:
		state = States.PLAYER_TURN
