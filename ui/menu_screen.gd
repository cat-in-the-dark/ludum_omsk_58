extends Node

@onready var icon_sp: SophiaSkin = $"Icon Single Player/Character Preview/SophiaSkin"
@onready var icon_mp1: SophiaSkin = $"Icon Two Players 1/Character Preview/SophiaSkin"
@onready var icon_mp2: SophiaSkin = $"Icon Two Players 2/Character Preview/SophiaSkin"

var singlePlayerScreen := "res://main_single_screen.tscn"
var multiPlayerScreen := "res://main_split_screen.tscn"


func _on_single_player_btn_pressed() -> void:
	get_tree().change_scene_to_file(singlePlayerScreen)


func _on_multiplayer_btn_pressed() -> void:
	get_tree().change_scene_to_file(multiPlayerScreen)


func _on_single_player_btn_mouse_entered() -> void:
	icon_sp.move()


func _on_single_player_btn_mouse_exited() -> void:
	icon_sp.idle()


func _on_multiplayer_btn_mouse_entered() -> void:
	icon_mp1.move()
	icon_mp2.move()


func _on_multiplayer_btn_mouse_exited() -> void:
	icon_mp1.idle()
	icon_mp2.idle()
