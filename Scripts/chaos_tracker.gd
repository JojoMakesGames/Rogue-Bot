extends Node

var total_destruction: int = 0

signal object_destroyed(object: Destroyable)
signal player_hack(player: Player, hacked_instance_id: int)
signal player_direction(direction: Vector3)
signal looking_direction(direction: Vector3)
signal lose()
