extends CharacterBody3D

class_name PoliceBot

signal set_health(percentage: float)

@export var SPEED = 2
@export var HEALTH: float = 500
@export var SHOT_SPEED = 500
@export var target: Node3D
@export var laser: PackedScene
@export var texture: Texture2D
@export var POINTS: int = 1000

@onready var explosion = load("res://Scenes/Assets/particles/parts_explode.tscn")
@onready var camera_placement: Node3D = $CameraPlacement
@onready var state_machine: PoliceStateMachine = $PoliceStateMachine
@onready var left_gun: Node3D = $LeftGun
@onready var right_gun: Node3D = $RightGun
@onready var animations: AnimationPlayer = $policebot/AnimationPlayer
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var timer: Timer = $Timer
@onready var shooting_range: Area3D = $ShootingRange
@onready var shooting: AudioStreamPlayer3D = $Shooting
@onready var hitbox: Area3D = $Hitbox

var rng = RandomNumberGenerator.new()
var input_direction: Vector3
var movement_delta: float
var looking_direction: Vector3
var player: Player
var health: float
var can_hack: bool

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	ChaosTracker.player_hack.connect(_on_player_hack)
	ChaosTracker.player_direction.connect(_on_direction)
	ChaosTracker.looking_direction.connect(_on_look)
	if target != null:
		nav.set_target_position(target.global_position)
	timer.start()
	health = HEALTH

func _process(delta):
	can_hack = health / HEALTH < .5
	if player:
		state_machine.state.handle_input(delta)
		if input_direction != Vector3.ZERO:
			look_at(position + input_direction)

func _physics_process(delta):
	if !is_on_floor(): 
		velocity.y = gravity * delta * -10
		move_and_slide()
	if player:
		state_machine.state.physics_update(delta)
	else:
		if nav.is_navigation_finished():
			nav.set_target_position(target.position)
			return
		if target != null:
			nav.set_target_position(target.position)
			movement_delta = SPEED * delta * .5
			var next_path_position: Vector3 = nav.get_next_path_position()
			var current_agent_position: Vector3 = global_transform.origin
			var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_delta
			nav.set_velocity(new_velocity)

		
func shoot(callback: Callable):
	health += 40
	var parent = get_parent()
	var laser1: RigidBody3D = laser.instantiate()
	laser1.position = left_gun.global_position
	parent.add_child(laser1)
	laser1.parent = get_node("CollisionShape3D")
	shooting.play()	
	laser1.apply_force(looking_direction * SHOT_SPEED)
	
	await get_tree().create_timer(.2).timeout
	var laser2: RigidBody3D = laser.instantiate()
	laser2.parent = get_node("CollisionShape3D")
	laser2.position = right_gun.global_position
	shooting.play()
	parent.add_child(laser2)
	laser2.apply_force(looking_direction * SHOT_SPEED)
	
	await get_tree().create_timer(.2).timeout
	
	callback.call()
	
func ai_shoot():
	animations.play("Shoot1")
	timer.start()
	var parent = get_parent()
	var laser1: RigidBody3D = laser.instantiate()
	laser1.parent = get_node("CollisionShape3D")
	parent.add_child(laser1)
	shooting.play()
	laser1.position = left_gun.global_position
	laser1.apply_force((target.global_position - left_gun.global_position).normalized() * SHOT_SPEED)
	
	animations.play("Shoot2")
	await get_tree().create_timer(.2).timeout
	var laser2: RigidBody3D = laser.instantiate()
	laser2.parent = get_node("CollisionShape3D")
	parent.add_child(laser2)
	shooting.play()
	laser2.position = right_gun.global_position
	laser2.apply_force((target.global_position - right_gun.global_position).normalized() * SHOT_SPEED)
	
	await get_tree().create_timer(.2).timeout
	

func _on_player_hack(player: Player, hacked_instance_id: int):
	if hacked_instance_id == get_instance_id():
		self.player = player
		health = 500
	else:
		self.player = null
		animations.stop()

func _on_direction(direction: Vector3):
	input_direction = direction
	

func _on_look(direction: Vector3):
	looking_direction = direction
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	animations.play("Walk")
	look_at(nav.get_final_position())
	rotation_degrees.x = clamp(rotation_degrees.x, 0, 0)
	
	global_transform.origin = global_transform.origin.move_toward(global_transform.origin + safe_velocity, movement_delta)

func _on_timer_timeout():
	if !player:
		if target != null and target.hacked_object in shooting_range.get_overlapping_bodies():
			look_at(target.global_position)
			rotation_degrees.x = clamp(rotation_degrees.x, 0, 0)
			ai_shoot()
	var my_random_number = rng.randf_range(1, 1.5)
	timer.wait_time = my_random_number
	timer.start()


func _on_hitbox_body_entered(body):
	health = health - 20
	set_health.emit(health/HEALTH)
	if health < 0:
		ChaosTracker.object_destroyed.emit(self)
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		var explode = explosion.instantiate() as Node3D
		get_tree().get_root().add_child(explode)
		explode.global_position = global_position
		tween.tween_property(explode, "scale", Vector3(5,5,5), 1)
		tween.set_parallel(false)
		if player:
			ChaosTracker.lose.emit()
		queue_free()
