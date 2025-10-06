extends Node

@export var text_1: Array[Label]
@export var text_2: Array[Label]

@export var skin_1: Array[SophiaSkin]
@export var skin_2: Array[SophiaSkin]

var start_1 := false
var start_2 := false

@export_file_path var next_scene: String

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_start_1"):
		start_1 = not start_1
		for text in text_1:
			text.visible = not start_1
		if start_1:
			for skin in skin_1:
				skin.move()
		else:
			for skin in skin_1:
				skin.idle()

	if Input.is_action_just_pressed("ui_start_2"):
		start_2 = not start_2
		for text in text_2:
			text.visible = not start_2
		if start_2:
			for skin in skin_2:
				skin.move()
		else:
			for skin in skin_2:
				skin.idle()

	if start_1 and start_2:
		get_tree().change_scene_to_file(next_scene)
