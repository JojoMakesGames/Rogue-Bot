extends Node3D
class_name Player

@onready var camera: Camera3D = $Camera3D

@export var hacked_object: PhysicsBody3D
var mouse_delta: Vector2
var current_scan: Node3D
var direction: Vector3

func _ready():
	camera.target = self
	change_hacked_object(hacked_object)	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  

func _physics_process(_delta):
	scan_for_hackables()
	
func _process(delta):
	position = hacked_object.position
	rotation_degrees.x -= mouse_delta.y * 10.0 * delta
	rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
  
	rotation_degrees.y -= mouse_delta.x * 10.0 * delta
	mouse_delta = Vector2()
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	direction = (forward * input_dir.y + right * input_dir.x).normalized()
	direction.y = 0
	hacked_object.input_direction = direction
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

func change_hacked_object(new_hacked_object: Node3D):
	if hacked_object != null:
		hacked_object.hacked = false
	hacked_object = new_hacked_object
	hacked_object.hacked = true
	camera.offset = hacked_object.camera_placement.position
	#hacked_object.mesh.mesh.material.albedo_color = hacked_object.base_color
	
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
		#var mesh: Mesh = current_scan.mesh.mesh
		#mesh.material.albedo_color = Color(255,0,0)
		if Input.is_action_just_pressed("hack"):
			change_hacked_object(current_scan)
	elif current_scan:
		#current_scan.mesh.mesh.material.albedo_color = current_scan.base_color
		current_scan = null

