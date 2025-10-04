extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		get_tree().change_scene_to_file("res://main_split_windows.tscn")
