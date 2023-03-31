extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 4.5
var hacked: bool
@onready var camera_placement: Node3D = $CameraPlacement
var input_direction: Vector3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	hacked = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	velocity.x = SPEED

	move_and_slide()
