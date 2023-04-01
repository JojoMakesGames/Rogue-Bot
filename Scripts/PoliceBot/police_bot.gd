extends CharacterBody3D

class_name PoliceBot

@export var SPEED = 2
var hacked: bool
@onready var camera_placement: Node3D = $CameraPlacement
@onready var state_machine: PoliceStateMachine = $PoliceStateMachine
var input_direction: Vector3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	hacked = false

func _process(delta):
	if hacked:
		state_machine.state.handle_input(delta)
		if input_direction != Vector3.ZERO:
			look_at(position + input_direction)

func _physics_process(delta):
	if hacked:
		state_machine.state.physics_update(delta)
	else:
		if not is_on_floor():
			velocity.y -= gravity * delta
		velocity.x = SPEED

		move_and_slide()
