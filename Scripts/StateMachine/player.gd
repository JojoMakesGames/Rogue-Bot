extends Node3D
class_name Player

var possession

@export var SPEED: float
@export var JUMP_VELOCITY: float
@export var acceleration: float

var state_machine: PlayerStateMachine
@onready var body = $Body

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	body.physics(delta)
	body.SPEED = self.SPEED
	body.JUMP_VELOCITY = self.JUMP_VELOCITY
	self.global_position = body.global_position
	
func _process(delta):
	body.process(delta)
