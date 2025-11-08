extends Node3D


var active_mesh: Mesh = null

@onready var grid_map: GridMap = $GridMap
@onready var ghost_mesh: CSGMesh3D = $GhostMesh


func _ready() -> void:
	active_mesh = grid_map.mesh_library.get_item_mesh(0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var cell_pos = _get_cell_coords()
		#var mesh_placeholder = grid_map.mesh_library.get_item_mesh(0)
		grid_map.set_cell_item(cell_pos, 0)
	elif event is InputEventMouseMotion:
		var cell_pos = _get_cell_coords()
		ghost_mesh.position = cell_pos as Vector3 * 2 + Vector3(1, 0, 1)


func _get_cell_coords():
	var collision_point = get_cursor_world_position()
	#print("world pos: ", collision_point)
	
	var cell_pos := grid_map.local_to_map(collision_point)
	print("corresponds to cell ", cell_pos)
	
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


func get_cursor_world_position() -> Vector3:
	const RAY_DISTANCE = 64.0
	
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not is_instance_valid(camera): return Vector3.ZERO
	var mouse_pos = get_viewport().get_mouse_position()
	
	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var to: Vector3 = from + camera.project_ray_normal(mouse_pos) * RAY_DISTANCE
	
	var ray_params := PhysicsRayQueryParameters3D.create(from, to)
	var ray_result: Dictionary = get_world_3d().direct_space_state.intersect_ray(ray_params)
	
	return ray_result.get("position", to) # return Vector3.ZERO if needed
