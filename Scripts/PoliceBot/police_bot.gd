extends CharacterBody3D

class_name PoliceBot

@export var SPEED = 2
@export var SHOT_SPEED = 500
@onready var camera_placement: Node3D = $CameraPlacement
@onready var state_machine: PoliceStateMachine = $PoliceStateMachine
@onready var left_gun: Node3D = $LeftGun
@onready var right_gun: Node3D = $RightGun
@onready var animations: AnimationPlayer = $policebot/AnimationPlayer
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@export var target: Node3D
@export var laser: PackedScene
@export var texture: Texture2D
@onready var timer: Timer = $Timer
var input_direction: Vector3
var movement_delta: float
var looking_direction: Vector3
var player: Player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	ChaosTracker.player_hack.connect(_on_player_hack)
	ChaosTracker.player_direction.connect(_on_direction)
	ChaosTracker.looking_direction.connect(_on_look)
	nav.set_target_position(target.global_position)

func _process(delta):
	if player:
		state_machine.state.handle_input(delta)
		if input_direction != Vector3.ZERO:
			look_at(position + input_direction)

func _physics_process(delta):
	#if !is_on_floor(): 
		#velocity.y = gravity * delta * -10
		#move_and_slide()
	if player:
		state_machine.state.physics_update(delta)
	else:
		if nav.is_navigation_finished():
			print('finished')
			if timer.is_stopped():
				ai_shoot()
				nav.set_target_position(target.position)
				
			return
		movement_delta = SPEED * delta * .5
		var next_path_position: Vector3 = nav.get_next_path_position()
		var current_agent_position: Vector3 = global_transform.origin
		var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_delta
		nav.set_velocity(new_velocity)

		
func shoot(callback: Callable):
	var parent = get_parent()
	var laser1: RigidBody3D = laser.instantiate()
	laser1.position = left_gun.global_position
	parent.add_child(laser1)
	laser1.apply_force(looking_direction * SHOT_SPEED)
	
	await get_tree().create_timer(.2).timeout
	var laser2: RigidBody3D = laser.instantiate()
	laser2.position = right_gun.global_position
	parent.add_child(laser2)
	laser2.apply_force(looking_direction * SHOT_SPEED)
	
	await get_tree().create_timer(.2).timeout
	
	callback.call()
	
func ai_shoot():
	animations.play("Shoot1")
	timer.start()
	var parent = get_parent()
	var laser1: RigidBody3D = laser.instantiate()
	laser1.position = left_gun.global_position
	parent.add_child(laser1)
	laser1.apply_force((target.global_position - left_gun.global_position).normalized() * SHOT_SPEED)
	
	animations.play("Shoot2")
	await get_tree().create_timer(.2).timeout
	var laser2: RigidBody3D = laser.instantiate()
	laser2.position = right_gun.global_position
	parent.add_child(laser2)
	laser2.apply_force((target.global_position - right_gun.global_position).normalized() * SHOT_SPEED)
	
	await get_tree().create_timer(.2).timeout
	

func _on_player_hack(player: Player, hacked_instance_id: int):
	if hacked_instance_id == get_instance_id():
		self.player = player
	else:
		self.player = null

func _on_direction(direction: Vector3):
	input_direction = direction
	

func _on_look(direction: Vector3):
	looking_direction = direction
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	look_at(target.global_position)
	animations.play("Walk")
	rotation_degrees.x = clamp(rotation_degrees.x, 0, 0)
	global_transform.origin = global_transform.origin.move_toward(global_transform.origin + safe_velocity, movement_delta)


func _on_navigation_agent_3d_path_changed():
	pass


func _on_timer_timeout():
	print('reset')
	timer.stop()
