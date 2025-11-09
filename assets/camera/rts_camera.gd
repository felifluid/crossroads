extends Node3D


@onready var rotation_x = $CameraRotX
@onready var zoom_pivot = $CameraRotX/CameraZoomPivot
@onready var camera = $CameraRotX/CameraZoomPivot/Camera3D

# variables
@export var floatyness : float = 0.10

@export var move_speed = 0.6
var move_target: Vector3

# rotation
@export var rotate_keys_speed = 1.5
var rotate_keys_target: float

# zoom
var zoom_target: float
@export var zoom_speed = 3.0
@export var min_zoom = -35.0
@export var max_zoom = -10.0

# mouse
@export var mouse_sensitivity = 0.3


func _ready() -> void:
	move_target = position
	rotate_keys_target = rotation_degrees.y
	zoom_target = camera.position.z
	
	#camera.look_at(position)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("rotate"):
		rotate_keys_target -= event.relative.x * mouse_sensitivity
		rotation_x.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_x.rotation_degrees.x = clamp(rotation_x.rotation_degrees.x, -40, 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rotate"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_released("rotate"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# get input directions
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	var rotate_keys_direction = Input.get_axis("rotate_left", "rotate_right")
	var zoom_direction = (int(Input.is_action_just_released("move_up")) - int(Input.is_action_just_released("move_down")))
	
	# set movement targets
	move_target += move_speed * movement_direction
	rotate_keys_target += rotate_keys_speed * rotate_keys_direction
	zoom_target += zoom_speed * zoom_direction
	zoom_target = clamp(zoom_target, min_zoom, max_zoom)
	
	# lerp to movement targets
	position = lerp(position, move_target, floatyness)
	rotation_degrees.y = lerp(rotation_degrees.y, rotate_keys_target, floatyness)
	camera.position.z = lerp(camera.position.z, zoom_target, floatyness)
