extends Node3D

var enemy: PackedScene = preload("res://Scenes/PoliceBot.tscn")
@export var target: Player
@onready var spawn_location: Node3D = $Spawn_Location
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _on_timer_timeout():
	audio.play()
	var instance = enemy.instantiate()
	var root = get_tree().get_root()
	instance.add_to_group("enemy_bots",false)
	instance.position = spawn_location.global_position
	instance.target = target
	root.add_child(instance)
