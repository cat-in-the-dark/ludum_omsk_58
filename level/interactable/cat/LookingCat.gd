extends StaticBody3D

var closestPlayer: Node3D = null
@onready var PlayerSeekerArea: Area3D = $PlayerSeekerArea

@export var rotation_speed = 1.0 # Radians per second

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if closestPlayer != null:
		var player_position = closestPlayer.global_transform.origin
		look_at(player_position, Vector3.UP)
	else:
		rotate_y(rotation_speed * delta)

func _on_player_seeker_area_body_entered(body: Node3D) -> void:
	if closestPlayer == null && body is CharacterBody3D:
		closestPlayer = body
		rotation = Vector3.ZERO
	pass # Replace with function body.

func _on_player_seeker_area_body_exited(body: Node3D) -> void:
	if closestPlayer != null && closestPlayer.get_instance_id() == body.get_instance_id():
		closestPlayer = null
	pass # Replace with function body.
