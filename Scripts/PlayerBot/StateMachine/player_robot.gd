extends CharacterBody3D

class_name PlayerRobot

signal set_health(percentage: float)

@onready var state_machine: PlayerRobotStateMachine = $StateMachine
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var animations: AnimationPlayer = $Robot/AnimationPlayer
@onready var camera_placement: Node3D = $CameraPlacement
@onready var head: BoneAttachment3D = $Robot/RobotArmature/Skeleton3D/Head_2
@onready var explosion = load("res://Scenes/Assets/particles/parts_explode.tscn")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 
var input_direction: Vector3
var player: Node3D
var can_hack: bool = true

@export var SPEED: float
@export var JUMP_VELOCITY: float
@export var HEALTH: float
@export var acceleration: float

var health: float

@export var texture: Texture2D

var health_percentage = 1

func _ready():
	ChaosTracker.player_hack.connect(_on_player_hack)
	ChaosTracker.player_direction.connect(_on_direction)
	ChaosTracker.looking_direction.connect(_on_looking_direction)
	health = HEALTH

func _physics_process(delta):
	if player != null:
		state_machine.state.physics_update(delta)
	elif not is_on_floor():
		velocity.y -= gravity * delta
		move_and_slide()
	
func _process(delta):
	if player != null:
		state_machine.state.handle_input(delta)
		if input_direction != Vector3.ZERO:
			look_at(position + input_direction)

func _on_player_hack(player: Player, hacked_instance_id: int):
	if hacked_instance_id == get_instance_id():
		self.player = player
	else:
		self.player = null
		animations.stop()

func _on_direction(direction: Vector3):
	input_direction = direction
	
func _on_looking_direction(direction: Vector3):
	pass


func _on_hitbox_body_entered(body):
	health = health - 20
	set_health.emit(health/HEALTH)
	if health < 0:
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
