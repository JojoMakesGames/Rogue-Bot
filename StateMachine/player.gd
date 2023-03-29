extends CharacterBody2D
class_name Player

@onready var state_machine = $StateMachine

@export var SPEED: float
@export var JUMP_VELOCITY: float
@export var acceleration: float

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	state_machine.state.physics_update(delta)

func _process(delta):
	state_machine.state.handle_input(delta)
