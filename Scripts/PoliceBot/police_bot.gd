extends CharacterBody3D

class_name PoliceBot

@export var SPEED = 2
var hacked: bool
@onready var camera_placement: Node3D = $CameraPlacement
@onready var state_machine: PoliceStateMachine = $PoliceStateMachine
@onready var left_gun: Node3D = $LeftGun
@onready var right_gun: Node3D = $RightGun
@onready var animations: AnimationPlayer = $policebot/AnimationPlayer
@export var target: Player
@export var laser: PackedScene
var input_direction: Vector3
var movement_delta: float

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
	elif !is_on_floor(): 
		velocity.y = gravity * delta * -10
		move_and_slide()
	else:
		velocity.x = 5
		move_and_slide()

		
func shoot(callback: Callable):
	var parent = get_parent()
	var direction = (-global_transform.basis.z).normalized()
	var laser1: RigidBody3D = laser.instantiate()
	laser1.position = left_gun.global_position
	parent.add_child(laser1)
	laser1.apply_force(direction * 5000)
	
	await get_tree().create_timer(.2).timeout
	var laser2: RigidBody3D = laser.instantiate()
	laser2.position = right_gun.global_position
	parent.add_child(laser2)
	laser2.apply_force(direction * 5000)
	
	await get_tree().create_timer(.2).timeout
	
	callback.call()
