extends Node3D

class_name Destroyable

@export var POINTS: int
@export var mesh: MeshInstance3D
@onready var hitbox: Area3D = $Hitbox

func _on_hitbox_body_entered(body):
	ChaosTracker.object_destroyed.emit(self)
	destroy()
	
func destroy():
	var tween = get_tree().create_tween()
	tween.tween_property(mesh.mesh.surface_get_material(0),"albedo_color", Color.DARK_RED, 1)
	tween.set_parallel(true)	
	tween.tween_property(mesh.mesh.surface_get_material(1),"albedo_color", Color.DARK_RED, 1)
	tween.tween_property(mesh, "scale", Vector2(), 10)
	tween.set_parallel(false)
	tween.tween_callback(self.queue_free)
