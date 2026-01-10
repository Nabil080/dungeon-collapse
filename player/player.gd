class_name Player
extends Node2D

# enums
enum States { IDLE, MOVING, WAITING }

# attributes
var current_state : States = States.IDLE

# onready
@onready var board_controller: BoardController = $"../BoardController"

var grid_pos : Vector2i:
	get: return board_controller.global_to_map(position)


func _ready() -> void:
	position = board_controller.global_to_centered(position)


func _physics_process(_delta: float) -> void:
	match current_state:
		States.IDLE: _process_input() # movement
		States.MOVING: pass
		States.WAITING, _: pass


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
	print("============")
	print("Trying to move in this direction : ", direction)
	var target_grid_position := grid_pos + direction
	# TODO: wall check
	
	# Force move since there was no error
	_move(board_controller.map_to_global(target_grid_position))
	return true


## Moves toward world coordinates, using a tween of [param duration] seconds
func _move(target_position: Vector2, duration := 0.2) -> void:
	current_state = States.MOVING

	var tween : Tween = create_tween()
	tween.tween_property(
		self, "position", target_position, duration
	).set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(func () -> void: current_state = States.IDLE)
