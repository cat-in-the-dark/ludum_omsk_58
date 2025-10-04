class_name HookTargetDetector
extends Area3D

@onready var player: Player = $".."

# To control max distance to hookable object
# change the collider shape radius

# from center of the screen
var hook_max_targeting_dist = 100

var hook_targets: Array[PhysicsBody3D] = []
var hook_target: int = -1

func get_hook_target() -> PhysicsBody3D:
	if hook_target < 0:
		return null
	if len(hook_targets) == 0:
		return null
	if hook_target >= len(hook_targets):
		print("WTF?")
		return null
	return hook_targets[hook_target]

func _on_enter_hook_area(body: PhysicsBody3D) -> void:
	if body == player: # prevent self collision
		return
	# new object would be at the end.. Ok?
	hook_targets.push_back(body)

func _on_exit_hook_area(body: PhysicsBody3D) -> void:
	if body == player: # prevent self collision
		return
	# could be slow, but who cares
	hook_targets.erase(body)
	pass

func _ready() -> void:
	connect("body_entered", _on_enter_hook_area)
	connect("body_exited", _on_exit_hook_area)

func _process(_delta: float) -> void:
	update_best_target()

func update_best_target():
	if len(hook_targets) == 0:
		return null
	var screen_center = player.hookTargetPointer.get_viewport_rect().size / 2
	var min_dist = 10000000
	var min_pos = Vector2.ZERO
	hook_target = -1
	for idx in len(hook_targets):
		var target = hook_targets[idx]
		var screen_pos = player._camera.unproject_position(target.global_position)
		var dist = screen_pos.distance_to(screen_center)
		if dist < min_dist and dist < hook_max_targeting_dist:
			min_dist = dist
			min_pos = screen_pos
			hook_target = idx

	if hook_target > -1:
		player.hookTargetPointer.visible = true
		player.hookTargetPointer.position = min_pos - player.hookTargetPointer.pivot_offset
	else:
		player.hookTargetPointer.visible = false
