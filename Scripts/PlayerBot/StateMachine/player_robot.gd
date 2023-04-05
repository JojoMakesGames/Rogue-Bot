extends CharacterBody3D

class_name PlayerRobot

signal set_health(percentage: float)

@onready var state_machine: PlayerRobotStateMachine = $StateMachine
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var base_color: Color = mesh.mesh.material.albedo_color
@onready var animations: AnimationPlayer = $Robot/AnimationPlayer
@onready var camera_placement: Node3D = $CameraPlacement
@onready var head: BoneAttachment3D = $Robot/RobotArmature/Skeleton3D/Head_2
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 
var input_direction: Vector3
var player: Node3D

@export var SPEED: float
@export var JUMP_VELOCITY: float
@export var HEALTH: float
@export var acceleration: float

var health: float = HEALTH

@export var texture: Texture2D

var health_percentage = 1

func _ready():
	ChaosTracker.player_hack.connect(_on_player_hack)
	ChaosTracker.player_direction.connect(_on_direction)
	ChaosTracker.looking_direction.connect(_on_looking_direction)

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

func _on_direction(direction: Vector3):
	input_direction = direction
	
func _on_looking_direction(direction: Vector3):
	pass


func _on_hitbox_body_entered(body):
	health -= 20
	set_health.emit(health/HEALTH)
	
