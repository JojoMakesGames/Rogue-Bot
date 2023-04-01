extends Node3D

@export var enemy: PackedScene
@onready var spawn_location: Node3D = $Spawn_Location


func _on_timer_timeout():
	var instance = enemy.instantiate()
	instance.global_position = spawn_location.global_position
	var root = get_tree().get_root()
	root.add_child(instance)
