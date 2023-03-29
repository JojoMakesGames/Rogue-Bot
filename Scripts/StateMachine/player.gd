extends Node3D
class_name Player

@export var hacked_object: PossessableObject
var mouse_delta: Vector2
var camera: Camera3D

func _ready():
	hacked_object.hacked = true
	camera = hacked_object.get_node("Camera3D")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  
	
	
func _process(delta):
	hacked_object.rotation_degrees.x -= mouse_delta.y * 10.0 * delta
	hacked_object.rotation_degrees.x = clamp(hacked_object.rotation_degrees.x, -90, 90)
  
	hacked_object.rotation_degrees.y -= mouse_delta.x * 10.0 * delta
	mouse_delta = Vector2()
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

