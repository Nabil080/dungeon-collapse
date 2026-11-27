class_name Player
extends Node2D

signal action_started
signal action_resolved
signal dying
signal died

@export var board_controller: BoardController
@export var turn_manager: TurnManager

var world_position: Vector2:
	set(val):
		world_position = val
		position = val

## The logical position. It changes as soon as a move starts,
## the sprite catches up with a tween.
var grid_pos: Vector2i
var previous_grid_pos: Vector2i

var death_requested := false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D


func _ready() -> void:
	assert(board_controller, "Board controller reference missing from Player")
	assert(turn_manager, "Turn manager reference missing from Player")

	grid_pos = board_controller.global_to_map(position)
	world_position = board_controller.map_to_global(grid_pos)


func _physics_process(_delta: float) -> void:
	if turn_manager.state != turn_manager.States.PLAYER_TURN:
		return
	_process_input()


func _process_input() -> void:
	var direction := Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	) as Vector2i

	if direction == Vector2i.ZERO:
		return

	# Only move on one axis if both inputs
	if direction.x:
		direction.y = 0
		animated_sprite_2d.flip_h = direction.x == -1

	_try_move(direction)


func _try_move(direction: Vector2i) -> bool:
	var target_cell := grid_pos + direction
	var tile := board_controller.get_tile_def(target_cell)

	if tile and tile.walkable:
		_commit_move(target_cell)
		return true

	return false


## One turn: the board updates, the tiles react to the move, then the sprite moves.
func _commit_move(target_cell: Vector2i) -> void:
	action_started.emit()
	board_controller.start_of_turn()

	previous_grid_pos = grid_pos
	grid_pos = target_cell

	board_controller.on_tile_exited(self, previous_grid_pos)
	board_controller.on_tile_entered(self, grid_pos)

	board_controller.resolve_environment()

	_animate_move(board_controller.map_to_global(grid_pos))


func _animate_move(target_position: Vector2, duration := 0.2) -> void:
	animation_player.play("moving")
	var tween := create_tween()
	tween.tween_property(
		self, "world_position", target_position, duration
	).set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	action_resolved.emit()

	if death_requested:
		_play_death()
	else:
		_play_idle()


## Called by the tiles. The death plays once the move animation is over.
func request_death() -> void:
	death_requested = true
	GameManager.has_key = false


func _play_death(animation_name := "falling") -> void:
	dying.emit()
	animation_player.play(animation_name)
	await animation_player.animation_finished
	died.emit()


func _play_idle() -> void:
	animation_player.play("RESET")
	await animation_player.animation_finished
	animation_player.play("idle")
