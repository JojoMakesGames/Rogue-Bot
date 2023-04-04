extends Node3D

class_name Destroyable

@export var POINTS: int
@onready var hitbox: Area3D = $Hitbox

func _on_hitbox_body_entered(body):
	ChaosTracker.object_destroyed.emit(self)
