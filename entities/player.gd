class_name Player
extends Node2D

# signals
signal action_started
signal action_resolved
signal dying
signal died

# exports
@export var board_controller: BoardController
@export var turn_manager: TurnManager


var grid_pos : Vector2i:
	get: return board_controller.global_to_map(position)


func _ready() -> void:
	assert(board_controller, "Board controller reference missing from Player")
	assert(turn_manager, "Turn manager reference missing from Player")
	position = board_controller.global_to_centered(position)


## Calls the appropiate functions depending on the current state and turn
func _physics_process(_delta: float) -> void:
	if turn_manager.current_state != turn_manager.States.PLAYER_TURN:
		return
	_process_input()

## Listens to the player movement input
func _process_input() -> void:
	# Get inputs
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down") as Vector2i
	if direction == Vector2i.ZERO:
		return # No input
	
	# Only move on one axis if both inputs, prioritizing horizontal
	if direction.x: 
		direction.y = 0
	_try_move(direction)


## Tries to move in the given [param direction] [br]
## Returns *true* if the movement was made
func _try_move(direction: Vector2i) -> bool:
	var target_cell := grid_pos + direction
	if board_controller.get_tile_def(target_cell).walkable:
		_move(board_controller.map_to_global(target_cell))
		return true
		
	return false


## Moves toward world coordinates, using a tween of [param duration] seconds
func _move(target_position: Vector2, duration := 0.2) -> void:
	# Start moving
	action_started.emit()
	board_controller.on_tile_exited(self, grid_pos)

	var tween : Tween = create_tween()
	tween.tween_property(
		self, "position", target_position, duration
	).set_ease(Tween.EASE_IN_OUT)

	# Finished moving
	await tween.finished
	action_resolved.emit()
	board_controller.on_tile_entered(self, grid_pos)


## Makes the [Player] fall and die
func fall()-> void:
	const FALL_DURATION := 1.0
	const NUMBER_OF_SPINS := 2.0
	
	# Start falling
	dying.emit()
	print("Player is falling")
	
	var tween := create_tween()
	tween.set_parallel(true)
	# Rotate
	tween.tween_property(
		self, "rotation", rotation + TAU * NUMBER_OF_SPINS, FALL_DURATION
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# Scale down
	tween.tween_property(
		self, "scale", Vector2.ZERO, FALL_DURATION
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	# Finished falling
	await tween.finished
	print("Player died")
	died.emit()
