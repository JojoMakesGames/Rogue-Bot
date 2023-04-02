extends Node3D

var enemy: PackedScene = preload("res://Scenes/PoliceBot.tscn")
@onready var spawn_location: Node3D = $Spawn_Location
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _on_timer_timeout():
	audio.play()
	var instance = enemy.instantiate()
	instance.global_position = spawn_location.global_position
	var root = get_tree().get_root()
	root.add_child(instance)
