extends CharacterBody3D


signal PointingAtInteractable(collided: Object)
signal NotPointingAtInteractable

@onready var Raycast: ShapeCast3D = $Head/Camera3D/ShapeCast3D 
@export var SPEED = 2.0
@export var JUMP_VELOCITY = 4.5
var mouseSensibility = 1200
var mouse_relative_x = 0
var mouse_relative_y = 0
var disable_player = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Raycast.add_exception(self)
	Raycast.collide_with_areas = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.stream.loop = true


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / mouseSensibility
		$Head/Camera3D.rotation.x -= event.relative.y / mouseSensibility
		$Head/Camera3D.rotation.x = clamp($Head/Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)


func _physics_process(delta):
	if disable_player:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * 1.5

	# Handle Jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		$AnimationPlayer.play("head_bob")
		$AudioStreamPlayer.stream_paused = false
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		$AnimationPlayer.pause()
		$AudioStreamPlayer.stream_paused = true
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	interact()	
	
func interact():
	if not Raycast.is_colliding():
		NotPointingAtInteractable.emit()
		return
	
	var prioritized_collided: Interactable = Raycast.get_collider(0)
	for i in range(Raycast.get_collision_count()):
		var collided = Raycast.get_collider(i)
		if collided.priority < prioritized_collided.priority:
			prioritized_collided = collided
	
	if not (prioritized_collided is Interactable):
		NotPointingAtInteractable.emit()
		return
	PointingAtInteractable.emit(prioritized_collided)


func loopThroughRaycast():
	pass