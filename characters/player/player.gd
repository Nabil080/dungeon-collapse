extends CharacterBody2D

# States
enum States { IDLE, WALKING }
var current_state := States.IDLE


# Movement
# Logical grid position (source of truth)
var tile_pos : Vector2i

# Visual movement
var move_duration := 0.25
var movement_tween : Tween

# References
@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D # For flipping and changing animation


func _ready() -> void:
	# Initialize tile position from starting world position
	tile_pos = Vector2i(position) / Consts.GRID_SIZE
	position = Vector2(tile_pos * Consts.GRID_SIZE + Consts.TILE_CENTER)

func _physics_process(_delta: float) -> void:
	match current_state:
		States.IDLE:
			_process_idle()
		States.WALKING:
			_process_walking()

func _process_idle() -> void:
	# Check if a direction is pressed
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down") as Vector2i
	if input_dir == Vector2i.ZERO:
		return

	# Only move on one axis, horizontal first
	var direction := Vector2i.ZERO
	if input_dir.x != 0:
		direction.x = input_dir.x
	elif input_dir.y != 0:
		direction.y = input_dir.y

	_try_start_walking(direction)

func _process_walking() -> void:
	# Input is locked while walking
	pass

## Check if the direction is walkable and walks toward it if possible
func _try_start_walking(direction: Vector2i) -> void:
	# check if can move
	if not _can_move_to(tile_pos + direction):
		return
	
	# change sprite orientation and animation
	if direction.x: 
		animated_sprite_2d.flip_h = (direction.x < 0)
	animated_sprite_2d.play("walking")
	# commit logical movement immediately
	tile_pos += direction

	# change state
	current_state = States.WALKING

	# compute target position
	var target_position := Vector2(tile_pos * Consts.GRID_SIZE + Consts.TILE_CENTER)

	# stop previous tween if any
	if movement_tween:
		movement_tween.kill()

	# apply move tween
	movement_tween = create_tween()
	movement_tween.tween_property(
		self,
		"position",
		target_position,
		move_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	# tween ended change state
	movement_tween.finished.connect(_stop_walking)


func _stop_walking() -> void:
	# note: might want to snap to exact pixel position
	current_state = States.IDLE
	animated_sprite_2d.play("idle")


## Grid validation (not implemented)
func _can_move_to(target_tile: Vector2i) -> bool:
	# TODO:
	# - check wall
	# - check floor exists
	return true
