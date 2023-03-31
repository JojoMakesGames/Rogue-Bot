extends CharacterBody3D

class_name PlayerRobot

@onready var state_machine: PlayerRobotStateMachine = $StateMachine
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var base_color: Color = mesh.mesh.material.albedo_color
@onready var animations: AnimationPlayer = $Robot/AnimationPlayer
@onready var camera_placement: Node3D = $CameraPlacement
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 
var input_direction: Vector3

@export var SPEED: float
@export var JUMP_VELOCITY: float
@export var acceleration: float

@export var hacked: bool

func _physics_process(delta):
	if hacked:
		state_machine.state.physics_update(delta)
	elif not is_on_floor():
		velocity.y -= gravity * delta
		move_and_slide()
	
func _process(delta):
	if hacked:
		state_machine.state.handle_input(delta)
		if input_direction != Vector3.ZERO:
			look_at(position + input_direction)
