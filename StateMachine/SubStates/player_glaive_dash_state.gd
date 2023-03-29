extends PlayerAbilityState
class_name PlayerGlaiveDashState

@export var dash_speed: float = 400
var target: Node2D

func physics_update(delta):
	super.physics_update(delta)
	#var direction = Vector2.ZERO
	#var tween = player.create_tween()
	#tween.tween_property(player, "position", target.position, .1)
	is_ability_done = true
	if !target:
		is_ability_done = true
	else:
		player.global_position = player.global_position.lerp(target.global_position.x * Vector2.RIGHT, 1)
		#player.y = player.position.lerp(target.position.y * Vector2.UP, 1)

func can_dash():
	return target != null and target.is_returning()
	
func set_target(target: Node2D):
	self.target = target
	
