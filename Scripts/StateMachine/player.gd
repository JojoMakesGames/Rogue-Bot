extends Node3D
class_name Player

@export var hacked_object: PhysicsBody3D
var mouse_delta: Vector2
var camera: Camera3D
var current_scan: Node3D

func _ready():
	hacked_object.hacked = true
	camera = hacked_object.get_node("Camera3D")
	camera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  

func _physics_process(_delta):
	scan_for_hackables()
	
func _process(delta):
	hacked_object.rotation_degrees.x -= mouse_delta.y * 10.0 * delta
	hacked_object.rotation_degrees.x = clamp(hacked_object.rotation_degrees.x, -90, 90)
  
	hacked_object.rotation_degrees.y -= mouse_delta.x * 10.0 * delta
	mouse_delta = Vector2()
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
		

func change_hacked_object(new_hacked_object: Node3D):
	hacked_object.hacked = false
	new_hacked_object.look_at(hacked_object.position)
	hacked_object = new_hacked_object
	hacked_object.hacked = true
	hacked_object.mesh.mesh.material.albedo_color = hacked_object.base_color
	camera = new_hacked_object.get_node("Camera3D")
	camera.make_current()
	
func scan_for_hackables():
	var space_state = get_world_3d().direct_space_state
	var forward = hacked_object.global_transform.basis.z * -1000
	var query = PhysicsRayQueryParameters3D.create(hacked_object.position, forward)
	query.set_collision_mask(4)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var result = space_state.intersect_ray(query)
	if "collider" in result:
		current_scan = result["collider"].get_parent() as Node3D
		var mesh: Mesh = current_scan.mesh.mesh
		mesh.material.albedo_color = Color(255,0,0)
		if Input.is_action_just_pressed("hack"):
			change_hacked_object(current_scan)
	elif current_scan:
		current_scan.mesh.mesh.material.albedo_color = current_scan.base_color
		current_scan = null

