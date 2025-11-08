extends Node3D


enum rotations {
	NORTH = 16,
	EAST = 0,
	SOUTH = 22,
	WEST = 10
}

enum modes {
	BUILD,
	DELETE
}

const CELL_SIZE = 1

@export var mesh_offset = Vector3(CELL_SIZE as float / 2, 0, CELL_SIZE as float / 2)

var active_mesh: Mesh = null
var active_mesh_idx: int = 0
var rotation_counter: int = rotations.EAST
var mode: int = modes. BUILD

@onready var grid_map: GridMap = $GridMap
@onready var ghost_mesh: MeshInstance3D = $GhostMesh
@onready var hud: HUD = $HUD


func _ready() -> void:
	active_mesh = grid_map.mesh_library.get_item_mesh(0)
	hud.new_mesh_selected.connect(_select_new_mesh)
	hud.rotate_plus_pressed.connect(_increment_rotation)
	hud.rotate_minus_pressed.connect(_decrement_rotation)
	hud.delete_pressed.connect(_enter_delete_mode)
	
	hud.init_buttons(grid_map.mesh_library, grid_map.mesh_library.get_item_list().size())
	
	ghost_mesh.mesh.size = Vector3(CELL_SIZE, 0.04, CELL_SIZE)


func _process(_delta: float) -> void:
	#NOTE: crungo implementation
	ghost_mesh.visible = not GameManager.placing_locked


func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("place_object")
	and not GameManager.placing_locked):
		var cell_pos = _get_cell_coords()
		$Label.text = str(cell_pos)
		match mode:
			modes.BUILD:
				grid_map.set_cell_item(cell_pos, active_mesh_idx, rotation_counter)
			modes.DELETE:
				grid_map.set_cell_item(cell_pos, GridMap.INVALID_CELL_ITEM, rotation_counter)
	elif event is InputEventMouseMotion:
		var cell_pos = _get_cell_coords()
		$Label.text = str(cell_pos)
		ghost_mesh.position = cell_pos as Vector3 * CELL_SIZE + mesh_offset
	elif event.is_action_pressed("rotate_object_plus"):
		_increment_rotation()
	elif event.is_action_pressed("rotate_object_minus"):
		_decrement_rotation()



func _get_cell_coords():
	var collision_point = get_cursor_world_position()
	#print("world pos: ", collision_point)
	
	var cell_pos := grid_map.local_to_map(collision_point)
	#print("corresponds to cell ", cell_pos)
	
	return cell_pos


func get_point_under_cursor() -> Vector3:
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return  Vector3()

	var origin: Vector3 = camera.global_position     

	#Get a point projected away from the camera, offset by the cursor, extended to 1000 units
	var target: Vector3 = camera.project_ray_normal( get_viewport().get_mouse_position() * 1000 )   

	#Perform a raycast across the 3D space    
	var ray_params := PhysicsRayQueryParameters3D.create(origin, target)    
	var ray_result: Dictionary = get_world_3d().direct_space_state.intersect_ray(ray_params)    

	#Try to get the position of the collision, if there was no collision, return Vector3.ZERO  
	var hit_position: Vector3 = ray_result.get("position", Vector3.ZERO)   

	return hit_position  


func _increment_rotation():
	var key = (rotations.values().find(rotation_counter) + 1) % rotations.size()
	rotation_counter = rotations.values()[key]
	ghost_mesh.global_rotation.y -= deg_to_rad(90)
	print(rotation_counter)


func _decrement_rotation():
	var key = (rotations.values().find(rotation_counter) - 1) % rotations.size()
	ghost_mesh.global_rotation.y += deg_to_rad(90)
	rotation_counter = rotations.values()[key]


func _select_new_mesh(idx: int) -> void:
	print("new index: ", idx)
	active_mesh_idx = idx
	var new_mesh: Mesh = grid_map.mesh_library.get_item_mesh(idx)
	ghost_mesh.mesh = new_mesh
	print(ghost_mesh.mesh)
	#ghost_mesh.material = null
	ghost_mesh.set_surface_override_material(0, null)


func _enter_delete_mode():
	if mode == modes.DELETE:
		_enter_build_mode()
		return
	
	mode = modes.DELETE
	ghost_mesh.mesh = BoxMesh.new()
	ghost_mesh.mesh.size = Vector3.ONE * CELL_SIZE
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.RED
	ghost_mesh.set_surface_override_material(0, mat)
	mesh_offset.y = CELL_SIZE as float / 2


func _enter_build_mode():
	if mode == modes.BUILD:
		return
	
	mode = modes.BUILD
	_select_new_mesh(active_mesh_idx)



func get_cursor_world_position2() -> Vector3:
	const RAY_DISTANCE = 64.0
	
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not is_instance_valid(camera): return Vector3.ZERO
	var mouse_pos = get_viewport().get_mouse_position()
	
	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var to: Vector3 = from + camera.project_ray_normal(mouse_pos) * RAY_DISTANCE
	
	var ray_params := PhysicsRayQueryParameters3D.create(from, to)
	var ray_result: Dictionary = get_world_3d().direct_space_state.intersect_ray(ray_params)
	
	return ray_result.get("position", to) # return Vector3.ZERO if needed


func get_cursor_world_position():
	var drop_plane = Plane(Vector3(0, 1, 0), 0)
	var camera: Camera3D = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	
	
	var pos_3d = drop_plane.intersects_ray(
		camera.project_ray_origin(mouse_pos),
		camera.project_ray_normal(mouse_pos)
	)
	
	return pos_3d
