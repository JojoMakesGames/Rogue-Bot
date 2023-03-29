extends PlayerAbilityState
class_name PlayerShootingState

@onready var GLAIVE = preload("res://Scenes/glaive.tscn")
@export var number_of_shots: int = 1
var shots_left: int = number_of_shots
var start_shot: int

func enter():
	super.enter()
	shots_left -= 1
	var mouse_position = get_global_mouse_position()
	var boomerang_container = player.get_node("GlaiveContainer")
	print_debug("container position: ", boomerang_container.global_position)
	var direction_to_mouse = player.global_position.direction_to(mouse_position)
	start_shot = start_time
	var glaive: Glaive = GLAIVE.instantiate()
	glaive.init(direction_to_mouse, boomerang_container.global_position, start_time, player)
	glaive.position = boomerang_container.global_position
	player.owned_glaive = glaive
	player.get_parent().add_child(glaive)
	player.state_machine.glaive_dashing.set_target(glaive)
	
	is_ability_done = true
	

func check_can_shoot(current: int):
	return current - start_shot > 500 and shots_left > 0

func regain_shot():
	shots_left += 1
	
