extends CanvasLayer

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@export_file_path var next_scene: String
@export_file_path var restart_scene: String
var startMSec: int = 0

func _ready() -> void:
	startMSec = Time.get_ticks_msec()
	Events.flag_reached.connect(func on_flag_reached() -> void:
		await get_tree().create_timer(2.0).timeout
		var endMSec := Time.get_ticks_msec()
		Globals.level_cleared_in_seconds = roundi((endMSec - startMSec) / 1000.0)
		_animation_player.play("fade_in")
		await _animation_player.animation_finished
		if next_scene != null and next_scene != "":
			get_tree().change_scene_to_file(next_scene)
	)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_restart"):
		if restart_scene != null and restart_scene != "":
			get_tree().change_scene_to_file(restart_scene)
