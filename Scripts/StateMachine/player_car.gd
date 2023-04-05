extends VehicleBody3D

var base_color: Color
var input_direction: Vector3
var player: Player
@export var texture: Texture2D
@export var HEALTH: float = 500
var can_hack: bool = true
var health: float

@onready var explosion = load("res://Scenes/Assets/particles/parts_explode.tscn")

signal set_health(percentage: float)

# Called when the node enters the scene tree for the first time.
func _ready():
	ChaosTracker.player_hack.connect(_on_player_hack)
	ChaosTracker.player_direction.connect(_on_direction)
	ChaosTracker.looking_direction.connect(_on_looking_direction)
	health = HEALTH
	can_hack = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player:
		steering = Input.get_axis("right", "left") * .8
		engine_force = Input.get_axis("down", "up") * 100
		rotation_degrees.x = clamp(rotation_degrees.x, 0, 0)
		rotation_degrees.z = clamp(rotation_degrees.z, 0, 0)
	
func _on_player_hack(new_player: Player, hacked_instance_id: int):
	if hacked_instance_id == get_instance_id():
		player = new_player
	else:
		player = null

func _on_direction(direction: Vector3):
	input_direction = direction
	
func _on_looking_direction(_direction: Vector3):
	pass
	
func _on_hitbox_body_entered(body):
	health = health - 20
	set_health.emit(health/HEALTH)
	if health < 0:
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		var explode = explosion.instantiate() as Node3D
		get_tree().get_root().add_child(explode)
		explode.global_position = global_position
		tween.tween_property(explode, "scale", Vector3(5,5,5), 1)
		tween.set_parallel(false)
		if player:
			ChaosTracker.lose.emit()
		queue_free()
