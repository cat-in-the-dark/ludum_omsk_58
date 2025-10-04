extends Node

@export_file_path var next_scene: String

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		print("Goto: ", next_scene)
		get_tree().change_scene_to_file(next_scene)
	elif Input.is_action_just_pressed("ui_accept"):
		print("Goto: ", next_scene)
		get_tree().change_scene_to_file(next_scene)
