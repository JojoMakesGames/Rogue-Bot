extends Node3D
class_name Player

@export var hacked_object: PossessableObject
var mouse_delta: Vector2
var camera: Camera3D

func _ready():
	hacked_object.hacked = true
	camera = hacked_object.get_node("Camera3D")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var forward = hacked_object.global_transform.basis.z * -1000
	var query = PhysicsRayQueryParameters3D.create(hacked_object.position, forward)
	query.set_collision_mask(1)
	var result = space_state.intersect_ray(query)
	if "collider" in result:
		var new_hack = result["collider"] as PossessableObject
		var mesh: Mesh = new_hack.mesh.mesh
		mesh.material.albedo_color = Color(255,0,0)
		if Input.is_action_just_pressed("hack"):
			hacked_object.hacked = false
			hacked_object = new_hack
			hacked_object.hacked = true
			camera = new_hack.get_node("Camera3D")
			camera.make_current()
	
	
func _process(delta):
	hacked_object.rotation_degrees.x -= mouse_delta.y * 10.0 * delta
	hacked_object.rotation_degrees.x = clamp(hacked_object.rotation_degrees.x, -90, 90)
  
	hacked_object.rotation_degrees.y -= mouse_delta.x * 10.0 * delta
	mouse_delta = Vector2()
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

