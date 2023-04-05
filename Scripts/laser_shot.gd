extends RigidBody3D

var parent

func _on_timer_timeout():
	queue_free()
