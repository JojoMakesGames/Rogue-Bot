extends PlayerStateMachine

class_name PlayerRobotStateMachine

@export var idle: PlayerIdleState
@export var moving: PlayerMovingState
@export var jumping: PlayerJumpingState
@export var in_air: PlayerInAirState

@export var player: PlayerRobot
@export var animation_player: AnimationPlayer

func _ready():
	state = get_child(0) as PlayerRobotState
	state.state_machine = self
	state.player = player
	state.animation = animation_player
	state.enter()
	
func change_state(new_state: PlayerRobotState):
	state.exit()
	state = new_state
	if !state.state_machine:
		state.state_machine = self
	if !state.player:
		state.player = self.player
	if !state.animation:
		state.animation = animation_player
	state.enter()

