extends Node3D

var enemy: PackedScene = preload("res://Scenes/PoliceBot.tscn")
@onready var spawn_location: Node3D = $Spawn_Location

func _process(_delta):
	if Time.get_ticks_msec() % 7000 <= 10:
		print("Here")
		var instance = enemy.instantiate()
		instance.global_position = spawn_location.global_position
		var root = get_tree().get_root()
		root.add_child(instance)
