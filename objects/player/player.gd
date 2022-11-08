extends CharacterBody3D

# Constants
const SPEED := 2.5
const JUMP := 3.0
const MOUSE_SENSITIVITY := 0.25
const PUSH_FORCE := 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Nodes
@onready var neck: Node3D = $Neck
@onready var head: Node3D = $Neck/Head
@onready var footsteps: Node3D = $Footsteps
@onready var interact_ray: RayCast3D = $Neck/Head/Interact
@onready var ui: Control = $UI/UI
@onready var belongings: Node3D = $Neck/Head/Items/Belongings/Offset
@onready var crosshairs := {
	"idle":     ui.get_node("Crosshairs/idle"),
	"interact": ui.get_node("Crosshairs/interact"),
	"pickup":   ui.get_node("Crosshairs/pickup"),
	"store":    ui.get_node("Crosshairs/store")
}

# Variables
var direction  := Vector3()
var last_is_moving := false
var is_moving    := false
var is_running   := false
var is_crouching := false
var is_holding_item := false
var moving     := 0.0  # 1.0 if moving, 0.0 if not moving (used for animation transitions)
var time       := 0.0

# Node methods
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.player = self
	Global.loading_ui = $LoadingUI
	Global.ui     = ui

func _process(delta):
	var freq   := 17.0 if is_running else (13.3 if not is_crouching else 9.5)
	var amount := 0.02 if is_running else 0.01
	
	# If moving
	if abs(direction.x) + abs(direction.z) > 0 and moving <= 1.0 && !is_on_wall():
		moving = lerp(moving, 1.0, 5.0 * delta)
	else:
		moving = lerp(moving, 0.0, 3 * delta)
	
	# Head tilt
	head.position.z = (cos(time * freq) * amount) * moving;
	head.position.y = (sin(time * freq) * (amount * 5)) * moving;
	head.position.z = (cos(time * freq) * (amount * 5)) * moving;
	
	# Increasing time
	time += delta

	# Resetting the time every once in a while so it doesn't overflow max float limit         
	if (time >= freq * 8):
		time = 0.0
	
	# Updating crosshairs
	var usable: Dictionary = Util.player_get_usable()
	for key in crosshairs.keys():
		if usable.object == null:
			crosshairs[key].visible = false
			crosshairs["idle"].visible = true
		crosshairs["interact"].visible = (usable.type == "interactable")
		crosshairs["pickup"].visible   = (usable.type == "pickup")
		crosshairs["store"].visible    = (usable.type == "car")

func _physics_process(delta):
	# Unlocking/locking mouse
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = (2 - Input.mouse_mode)
		
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP
		footsteps.play_once()
	
	# Crouching
	if Input.is_action_just_pressed("crouch"):
		is_crouching = true
		is_running = false
		$Collision.disabled = true
		$CrouchCollision.disabled = false
	elif Input.is_action_just_released("crouch"):
		is_crouching = false
		$Collision.disabled = false
		$CrouchCollision.disabled = true
	
	if is_crouching:
		neck.position.y = lerp(neck.position.y, -0.4, 5 * delta)
	else:
		neck.position.y = lerp(neck.position.y,  0.3, 5 * delta)
	
	# Sprinting
	is_running = Input.is_action_pressed("sprint") and moving and not is_crouching
	
	# Handling movement
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var speed := (SPEED * 1.9) if is_running else ((SPEED * 0.6) if is_crouching else SPEED)
	direction = transform.basis * Vector3(input.x, 0, input.y).normalized()
	last_is_moving = is_moving
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		is_moving = true
	else:
		velocity.x = move_toward(direction.x, 0, speed)
		velocity.z = move_toward(direction.z, 0, speed)
		is_moving = false
	
	if last_is_moving != is_moving:
		if is_moving:
			footsteps.start()
		else:
			footsteps.stop()
	
	# Applying movement	
	move_and_slide()
	
	# Pushing Rigidbody3D objects around
	_calculate_rigidbody_push()
	
	# Object interaction
	if Input.is_action_just_pressed("interact"):
		var usable: Dictionary = Util.player_get_usable()
		if usable.type == "car":
			if belongings.get_child_count() > 0:
				usable.object.store_item(belongings.get_child(0))
				is_holding_item = false
		else:
			if usable.type == "interactable":
				usable.object.interact()
			elif usable.type == "pickup":
				usable.object.pickup()
	

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var movement: Vector2 = (event.relative * 0.01)
		
		# Vertical head rotation
		neck.rotate_x(-movement.y * MOUSE_SENSITIVITY)
		neck.rotation.x = clamp(neck.rotation.x, -(PI / 2), (PI / 2))  # Big brain math
		
		# Horizontal body rotation
		rotate_y(-movement.x * MOUSE_SENSITIVITY)

# Godot 4.0 infinite inertia solution (from https://github.com/godotengine/godot/issues/59473)
func _calculate_rigidbody_push():
	var slideCollision: KinematicCollision3D = null
	for i in get_slide_collision_count():
		slideCollision = get_slide_collision(i)

	if slideCollision == null:
		return

	for i in slideCollision.get_collision_count():
		var collider = slideCollision.get_collider(i)
		if collider is RigidBody3D:
			collider.apply_central_impulse(-slideCollision.get_normal(i) * (PUSH_FORCE + (collider.mass * 0.04)))
	
func throw_held_item():	
	# Is there a held item?
	if belongings.get_child_count() == 0:
		return
	
	# Getting held item
	var item: RigidBody3D = belongings.get_child(0)
	
	# Removing from scene
	var pos := item.position
	var rot := item.rotation
	item.get_parent().remove_child(item)
	
	# Adding the rigidbody to the scene
	item.collision.disabled = false
	item.freeze = false
	item.position = pos
	item.rotation = rot
	$"../Map/Map/Belongings".add_child(item)
