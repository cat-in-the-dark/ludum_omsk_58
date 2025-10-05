class_name Player
extends CharacterBody3D

@export var player_idx = 1
var kicking_ability = true
var pulling_ability = false

@export var hookTargetPointer: TextureRect
@onready var _hookTargetDetector: HookTargetDetector = $HookTargetDetector

@export_group("Movement")
## Character maximum run speed on the ground in meters per second.
@export var move_speed := 8.0
## Ground movement acceleration in meters per second squared.
@export var acceleration := 20.0
## Player model rotation speed in arbitrary units. Controls how fast the
## character skin orients to the movement or camera direction.
@export var rotation_speed := 12.0
## Minimum horizontal speed on the ground. This controls when the character skin's
## animation tree changes between the idle and running states.
@export var stopping_speed := 1.0

@export_group("Camera")
@export_range(0.0, 10.0) var joystick_sensitivity := 2.5
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 4.0
@export var tilt_lower_limit := -PI / 4.0
@export var _camera: Camera3D

# just as metric for jumps/run etc
var character_height = 4.5

## Each frame, we find the height of the ground below the player and store it here.
## The camera uses this to keep a fixed height while the player jumps, for example.
var ground_height := 0.0

# would affect both jump and gravity, and maybe other things
# for tuning jumps etc
var gravity_base_multiplier = 2.0

# when falling, gravity is more....3ravitier 
var descendingGravityFactor = 1.3

var _gravity : int = -30.0 * gravity_base_multiplier
var _was_on_floor_last_frame := true
var is_stomping = false
var _camera_input_direction := Vector2.ZERO

## When the player is on the ground and presses the 'jump' button, the vertical
## velocity is set to this value.
@export var jump_impulse :int = (character_height * 3) * gravity_base_multiplier

## The last movement or aim direction input by the player. We use this to orient
## the character model.
@onready var _last_input_direction := global_basis.z
# We store the initial position of the player to reset to it when the player falls off the map.
@onready var _start_position := global_position

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera_anchor: Node3D = $CameraPivot/SpringArm3D/CameraAnchor
@onready var _skin: SophiaSkin = %SophiaSkin
@onready var _landing_sound: AudioStreamPlayer3D = %LandingSound
@onready var _jump_sound: AudioStreamPlayer3D = %JumpSound
@onready var _dust_particles: GPUParticles3D = %DustParticles

@onready var _kickingArea: Area3D = $SophiaSkin/KickArea
@onready var _interactArea: Area3D = $SophiaSkin/InteractArea
var kicking = false

var checkpoint: Checkpoint = null

var catToInteractWith: Node3D = null
var objectToInteractWith: RigidBody3D = null
var holdedObject: RigidBody3D = null
var holdedObjectMock: Node3D = null
var holdedObjectParent: Node3D = null
var holdingObjectNow = false

func set_skills():
	if player_idx == 1:
		kicking_ability = true
		pulling_ability = false
	elif player_idx == 2:
		kicking_ability = false
		pulling_ability = true
	else:
		# GOD MODE HAHAHAHA
		kicking_ability = true
		pulling_ability = true

	if not pulling_ability:
		# fast hack to remove hooking area if no ability
		remove_child(_hookTargetDetector)
		_hookTargetDetector = null
		if hookTargetPointer:
			hookTargetPointer.hide()
		

func _ready() -> void:
	_skin.set_variant(player_idx)
	set_skills()
	Events.kill_plane_touched.connect(func on_kill_plane_touched() -> void:
		global_position = _start_position
		velocity = Vector3.ZERO
		_skin.idle()
		set_physics_process(true)
	)
	Events.kill_plane_touched_with_id.connect(func on_kill_plane_touched_with_id(killedObjectId: int) -> void:
		if killedObjectId == get_instance_id():
			if checkpoint != null:
				global_position = checkpoint.spawn_anchor
			else:
				global_position = _start_position
			velocity = Vector3.ZERO
			_skin.idle()
			set_physics_process(true)
	)
	Events.flag_reached.connect(func on_flag_reached() -> void:
		set_physics_process(false)
		_skin.idle()
		_dust_particles.emitting = false
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	var player_is_using_mouse := (
		event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if player_is_using_mouse:
		_camera_input_direction.x = -event.relative.x * mouse_sensitivity
		_camera_input_direction.y = event.relative.y * mouse_sensitivity

func _handle_camera_joystic_move():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		return
	if Input.is_action_just_pressed("camera_reset_%d" % player_idx):
		# TODO: maybe tween?
		_camera_pivot.rotation = _skin.rotation
		return
	var raw_input := Input.get_vector("camera_left_%d" % player_idx, "camera_right_%d" % player_idx, "camera_up_%d" % player_idx, "camera_down_%d" % player_idx, 0.2)
	_camera_input_direction.x = -raw_input.x * joystick_sensitivity
	_camera_input_direction.y = raw_input.y * joystick_sensitivity

func _do_hooking():
	print("TODO: pulling ability")
	# _hookTargetDetector.get_hook_target()

func _physics_process(delta: float) -> void:
	_handle_camera_joystic_move()
	var current_move_speed = move_speed
	var current_acceleration = acceleration
	
	var appliedGravity = _gravity
	
	# relates to gliding or opposite
	var current_gravity_modifier = 1
	
	if kicking_ability:
		if kicking:
			kicking = false
			_kickingArea.monitoring = false
		elif Input.is_action_just_pressed("ability_%d" % player_idx):
			print("Kicking")
			kicking = true
			_kickingArea.monitoring = true
	elif pulling_ability:
		# maybe some code
		if Input.is_action_just_pressed("ability_%d" % player_idx):
			_do_hooking()

	if Input.is_action_just_pressed("interact_%d" % player_idx):
		if holdingObjectNow:
			# release object
			var prev_global := holdedObjectMock.global_transform
			remove_child(holdedObjectMock)
			holdedObjectMock.queue_free()
			holdedObjectParent.add_child(holdedObject)
			holdedObject.global_transform = prev_global
			holdedObject.freeze = false
			holdedObject.lock_rotation = false
			holdedObjectParent = null
			holdedObject = null
			holdedObjectMock = null
			holdingObjectNow = false
		elif catToInteractWith != null:
			Globals.level_cat_catched += 1
			catToInteractWith.queue_free()
			catToInteractWith = null
		elif objectToInteractWith != null:
			# grab object
			holdedObject = objectToInteractWith
			holdedObject.linear_velocity = Vector3.ZERO
			holdedObject.lock_rotation = true
			#holdedObject.freeze = true
			#holdedObject.sleeping = true
			holdedObjectParent = holdedObject.get_parent()
			#var prev_global := holdedObject.global_transform
			holdedObjectParent.remove_child(holdedObject)
			if holdedObject.has_method("getMockObject"):
				holdedObjectMock = holdedObject.getMockObject()
				_skin.add_child(holdedObjectMock)
				holdedObjectMock.transform = _interactArea.transform
			#holdedObject.transform = _interactArea.transform
			objectToInteractWith = null
			holdingObjectNow = true

	
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	_camera_pivot.rotation.y += _camera_input_direction.x * delta

	_camera_input_direction = Vector2.ZERO

	# Calculate movement input and align it to the camera's direction.
	var raw_input := Input.get_vector("move_left_%d" % player_idx, "move_right_%d" % player_idx, "move_up_%d" % player_idx, "move_down_%d" % player_idx, 0.4)
	# Should be projected onto the ground plane.
	var forward := Vector3.FORWARD
	var right := Vector3.RIGHT
	if _camera != null:
		forward = _camera.global_basis.z
		right = _camera.global_basis.x
		_camera.global_position = _camera_anchor.global_position
		_camera.global_rotation = _camera_anchor.global_rotation
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	# To not orient the character too abruptly, we filter movement inputs we
	# consider when turning the skin. This also ensures we have a normalized
	# direction for the rotation basis.
	if move_direction.length() > 0.2:
		_last_input_direction = move_direction.normalized()
	var target_angle := Vector3.BACK.signed_angle_to(_last_input_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)

	var is_just_jumping := Input.is_action_pressed("jump_%d" % player_idx) and is_on_floor()	
	
	if velocity.y < 0:
		appliedGravity = appliedGravity * descendingGravityFactor

	# We separate out the y velocity to only interpolate the velocity in the
	# ground plane, and not affect the gravity.
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * current_move_speed, current_acceleration * delta)
	if is_equal_approx(move_direction.length_squared(), 0.0) and velocity.length_squared() < stopping_speed:
		velocity = Vector3.ZERO
		
	velocity.y = y_velocity + appliedGravity * current_gravity_modifier * delta
	var ground_speed := Vector2(velocity.x, velocity.z).length()
	
	# Character animations and visual effects.
	if is_just_jumping:
		velocity.y += jump_impulse
		_skin.jump()
		_jump_sound.play()
	elif not is_on_floor() and velocity.y < 0:
		_skin.fall()
		
	elif is_on_floor():
		if ground_speed > 0.0:
			_skin.move()
		else:
			_skin.idle()

	_dust_particles.emitting = is_on_floor() && ground_speed > 0.0

	if is_on_floor() and not _was_on_floor_last_frame:
		_landing_sound.play()
	_was_on_floor_last_frame = is_on_floor()
	move_and_slide()

# get Vector3 with movementDirection (x,z)
func getCharacterLookDirection():
	var skin_direction_basis: Basis = _skin.global_basis
	#wvar direction_basis: Basis = transform.basis
	return skin_direction_basis.z

func getKickVelocity():
	var kick_horizontal_strengh = 40
	var kick_vertical_strength = 40
	var kick_velocity = Vector3.ZERO
	var direction = getCharacterLookDirection()
	kick_velocity.x = direction.x * kick_horizontal_strengh
	kick_velocity.y = kick_vertical_strength
	kick_velocity.z = direction.z * kick_horizontal_strengh
	return kick_velocity

func getBoxKickVelocity():
	var kick_horizontal_strengh = 20
	var kick_vertical_strength = 20
	var kick_velocity = Vector3.ZERO
	var direction = getCharacterLookDirection()
	kick_velocity.x = direction.x * kick_horizontal_strengh
	kick_velocity.y = kick_vertical_strength
	kick_velocity.z = direction.z * kick_horizontal_strengh
	return kick_velocity

func _on_kick_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.velocity = getKickVelocity()
	elif body is RigidBody3D:
		body.linear_velocity = getBoxKickVelocity()
	pass # Replace with function body.

func _on_interact_area_body_entered(body: Node3D) -> void:
	print_debug("entered %s" % body.name)
	if !holdingObjectNow && catToInteractWith == null && body is StaticBody3D:
		catToInteractWith = body
	elif !holdingObjectNow && objectToInteractWith == null && body is RigidBody3D:
		print_debug("can interact with %s" % body.name)
		objectToInteractWith = body

func _on_interact_area_body_exited(body: Node3D) -> void:
	print_debug("left %s" % body.name)
	if !holdingObjectNow && body is RigidBody3D:
		print_debug("no longer interactable -  %s" % body.name)
		objectToInteractWith = null
