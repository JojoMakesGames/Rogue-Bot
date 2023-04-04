extends Node

var total_destruction: int = 0

signal object_destroyed(object: Destroyable)
signal player_hack(player: Player, hacked_instance_id: int)
signal player_direction(direction: Vector3)
signal looking_direction(direction: Vector3)

func _ready():
	object_destroyed.connect(_on_object_destroyed)
	player_hack.connect(_on_hack_test)

func _on_object_destroyed(object: Destroyable):
	print_debug(object)
	
func _on_hack_test(player: Player, hacked_instance_id: int):
	print_debug(hacked_instance_id)
