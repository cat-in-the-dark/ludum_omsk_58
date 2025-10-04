extends RigidBody3D

@onready var body = $"."
var body_mass = 10
@onready var box_start_position = global_position

func _ready() -> void:
	body.mass = body_mass
	Events.kill_plane_touched.connect(func on_kill_plane_touched() -> void:
		global_position = box_start_position
		linear_velocity = Vector3.ZERO
		set_physics_process(true)
	)
	Events.kill_plane_touched_with_id.connect(func on_kill_plane_touched_with_id(killedObjectId: int) -> void:
		if killedObjectId == get_instance_id():
			global_position = box_start_position
			linear_velocity = Vector3.ZERO
			set_physics_process(true)
	)
