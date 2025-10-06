extends Node

@export_file_path var next_scene: String

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_start_1") or Input.is_action_just_pressed("ui_start_2"):
		get_tree().change_scene_to_file(next_scene)
