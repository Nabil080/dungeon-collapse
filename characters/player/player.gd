class_name Player
extends CharacterBody2D

# States
enum States { IDLE, WALKING }
var current_state := States.IDLE


# Movement
@export_range(0, 1, 0.05) var move_duration := 0.25
var movement_tween : Tween

# References
@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D # For flipping and changing animation


func _ready() -> void:
	pass
	
	
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
	# Check if can move
	if not _can_move_to(direction):
		return
	
	# Change sprite orientation and animation
	if direction.x: 
		animated_sprite_2d.flip_h = (direction.x < 0)
	#animated_sprite_2d.play("walking")

	# Change state
	current_state = States.WALKING

	# Compute target position
	var target_position := position + Vector2(direction * Consts.TILE_SIZE)

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

	# Tween ended change state
	movement_tween.finished.connect(_stop_walking)


func _stop_walking() -> void:
	# Note: might want to snap to exact pixel position
	current_state = States.IDLE
	#animated_sprite_2d.play("idle")


# Raycasts
@onready var ray_up: RayCast2D = $Rays/Up
@onready var ray_right: RayCast2D = $Rays/Right
@onready var ray_down: RayCast2D = $Rays/Down
@onready var ray_left: RayCast2D = $Rays/Left

## Grid validation (not implemented)
func _can_move_to(direction: Vector2i) -> bool:
	var ray : RayCast2D

	match direction:
		Vector2i.RIGHT:
			ray = ray_right
		Vector2i.LEFT:
			ray = ray_left
		Vector2i.UP:
			ray = ray_up
		Vector2i.DOWN:
			ray = ray_down
		_:
			return false

	# Ensure raycast is updated
	ray.force_raycast_update()
	print(ray)
	# If ray hits something, it's a wall
	return not ray.is_colliding()
