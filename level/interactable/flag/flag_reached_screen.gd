extends CanvasLayer

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@export_file_path var next_scene: String

func _ready() -> void:
	Events.flag_reached.connect(func on_flag_reached() -> void:
		await get_tree().create_timer(2.0).timeout
		_animation_player.play("fade_in")
		await _animation_player.animation_finished
		if next_scene != null and next_scene != "":
			get_tree().change_scene_to_file(next_scene)
	)
