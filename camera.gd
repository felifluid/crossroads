extends Node3D

@export var move_speed := 20.0
@export var rotation_speed := 120  # Degrees per second
@export var smoothness := 5.0       # Higher = faster interpolation

@onready var camera := $Camera3D

var _target_position: Vector3
var _target_rotation_y := 0.0

func _ready():
	_target_position = global_position
	_target_rotation_y = rotation_degrees.y
	
func _process(delta):
	handle_input(delta)
	smooth_update(delta)

func smooth_update(delta):
	global_position = global_position.lerp(_target_position, delta * smoothness)
	var current_y = _target_rotation_y
	current_y = lerp_angle(current_y, _target_rotation_y, delta * smoothness)
	rotation_degrees = Vector3(0, current_y, 0)
	
func handle_input(delta):
	var input_dir := Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_back"):
		input_dir.z += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if input_dir != Vector3.ZERO:
		input_dir = input_dir.normalized()
		var move_dir = transform.basis * input_dir
		move_dir.y = 0
		_target_position += move_dir * move_speed * delta
	
	if Input.is_action_pressed("rotate_left"):
		_target_rotation_y -= rotation_speed * delta
	if Input.is_action_pressed("rotate_right"):
		_target_rotation_y += rotation_speed * delta
