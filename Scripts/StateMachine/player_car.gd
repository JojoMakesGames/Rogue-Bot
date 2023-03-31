extends VehicleBody3D

#@onready var mesh: MeshInstance3D = $MeshInstance3D
var hacked: bool
var base_color: Color
var input_direction: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	hacked = false
#	base_color = mesh.mesh.material.albedo_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hacked:
		steering = Input.get_axis("right", "left") * 0.4
		engine_force = Input.get_axis("down", "up") * 100
	
func handle_camera(mouse_delta, delta):
	pass
