extends PossessableObject

class_name PlayerRobot

@onready var state_machine: PlayerRobotStateMachine = $StateMachine
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

@export var SPEED: float
@export var JUMP_VELOCITY: float
@export var acceleration: float

@export var hacked: bool

func _physics_process(delta):
	if hacked:
		state_machine.state.physics_update(delta)
	
func _process(delta):
	if hacked:
		state_machine.state.handle_input(delta)
