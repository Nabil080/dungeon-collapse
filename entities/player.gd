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

# onready
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# World / Grid positions
var world_position: Vector2:
	set(val):
		world_position = val
		position = val # visual only

var grid_pos: Vector2i:
	set(val):
		grid_pos = val

var previous_grid_pos: Vector2i


# Death state
var death_requested := false


func _ready() -> void:
	assert(board_controller, "Board controller reference missing from Player")
	assert(turn_manager, "Turn manager reference missing from Player")

	grid_pos = board_controller.global_to_map(position)
	world_position = board_controller.map_to_global(grid_pos)


## Calls the appropriate functions depending on the current turn
func _physics_process(_delta: float) -> void:
	if turn_manager.state != turn_manager.States.PLAYER_TURN:
		return
	_process_input()


## Listens to the player movement input
func _process_input() -> void:
	var direction := Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	) as Vector2i

	if direction == Vector2i.ZERO:
		return

	# Only move on one axis if both inputs
	if direction.x:
		direction.y = 0

	_try_move(direction)


## Tries to move in the given [param direction]
func _try_move(direction: Vector2i) -> bool:
	var target_cell := grid_pos + direction
	var tile := board_controller.get_tile_def(target_cell)

	if tile and tile.walkable:
		_commit_move(target_cell)
		return true

	return false


## Commits the move logically, then animates
func _commit_move(target_cell: Vector2i) -> void:
	action_started.emit()

	# Logical movement
	previous_grid_pos = grid_pos
	board_controller.on_tile_exited(self, previous_grid_pos)

	grid_pos = target_cell
	board_controller.on_tile_entered(self, grid_pos)

	# Environment resolution (crumbling, later conveyors, etc.)
	board_controller.resolve_environment()

	# Visual movement ALWAYS happens
	_animate_move(board_controller.map_to_global(grid_pos))


## Animates movement only
func _animate_move(target_position: Vector2, duration := 0.2) -> void:
	var tween := create_tween()
	tween.tween_property(
		self, "world_position", target_position, duration
	).set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(func ()->void:
		action_resolved.emit()

		if death_requested:
			_play_death()
	)


## Called by tiles to request player death (logic only)
func request_death() -> void:
	death_requested = true


## Plays the appropriate death presentation
func _play_death() -> void:
	dying.emit()
	_play_fall_animation()


## Default death animation (void)
func _play_fall_animation() -> void:
	const FALL_DURATION := 1.0
	const NUMBER_OF_SPINS := 2.0

	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		self, "rotation", rotation + TAU * NUMBER_OF_SPINS, FALL_DURATION
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	tween.tween_property(
		self, "scale", Vector2.ZERO, FALL_DURATION
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	tween.finished.connect(func ()->void:
		died.emit()
	)
