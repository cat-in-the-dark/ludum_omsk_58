extends Node

@export_file_path var next_scene: String

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		get_tree().change_scene_to_file(next_scene)
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file(next_scene)
