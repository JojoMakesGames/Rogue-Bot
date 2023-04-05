extends Node3D
class_name Player

@onready var camera: Camera3D = $Camera3D
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var sparks = load("res://Scenes/Assets/particles/parts_sparks.tscn")
@onready var you_lose = load("res://Scenes/Assets/UI/You Lose.tscn")

@export var hacked_object: PhysicsBody3D
var mouse_delta: Vector2
var current_scan: Node3D
var direction: Vector3
var tween: Tween

func _ready():
	tween = get_tree().create_tween()
	camera.target = self
	change_hacked_object(hacked_object, true)
	ChaosTracker.player_hack.emit(self, hacked_object.get_instance_id())
	ChaosTracker.lose.connect(_on_lose)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  

func _physics_process(_delta):
	scan_for_hackables()
	
func _process(delta):
	if !tween.is_running():
		if hacked_object != null:
			position = hacked_object.position
		rotation_degrees.x -= mouse_delta.y * 10.0 * delta
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
		
		rotation_degrees.y -= mouse_delta.x * 10.0 * delta
		mouse_delta = Vector2()
		ChaosTracker.looking_direction.emit(-global_transform.basis.z)
		var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
		var forward = global_transform.basis.z
		var right = global_transform.basis.x
		direction = (forward * input_dir.y + right * input_dir.x).normalized()
		direction.y = 0
		ChaosTracker.player_direction.emit(direction)
	
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

func change_hacked_object(new_hacked_object: Node3D, init: bool = false):
	hacked_object = new_hacked_object
	tween = get_tree().create_tween()
	var position_tween = tween.tween_property(self, "position", hacked_object.position, .5)
	position_tween.set_ease(Tween.EASE_IN_OUT)
	if !init:
		audio.play()
		var spark = sparks.instantiate()
		add_child(spark)
		spark.scale = Vector3(3,3,3)
		tween.set_parallel()
		tween.tween_property(camera, "fov", camera.fov * .8, .5).set_ease(Tween.EASE_IN_OUT)
		tween.set_parallel(false)
		tween.tween_property(camera, "fov", camera.fov, .2).set_ease(Tween.EASE_IN_OUT)
		tween.tween_callback(spark.queue_free)
	
	camera.offset = hacked_object.get_node("CameraPlacement").position
	
func scan_for_hackables():
	var space_state = get_world_3d().direct_space_state
	var forward = global_transform.basis.z * -50
	var query = PhysicsRayQueryParameters3D.create(position, forward)
	query.set_collision_mask(4)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var result = space_state.intersect_ray(query)
	if "collider" in result:
		print(result["collider"].get_parent())
		current_scan = result["collider"].get_parent() as Node3D
		if Input.is_action_just_pressed("hack") and current_scan.can_hack:
			ChaosTracker.player_hack.emit(self, current_scan.get_instance_id())
			change_hacked_object(current_scan)
	elif current_scan:
		current_scan = null
		
func _on_lose():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var lose = you_lose.instantiate()
	add_child(lose)

