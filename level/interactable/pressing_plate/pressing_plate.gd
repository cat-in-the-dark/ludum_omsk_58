class_name PressingPlate
extends Node3D

var is_pressed = false
var counter = 0
@onready var animation = $AnimationPlayer

signal plate_pressed
signal plate_unpressed

func _on_area_3d_body_entered(_body: Node3D) -> void:
	counter += 1
	if not is_pressed and counter > 0:
		is_pressed = true
		animation.play("press")
		plate_pressed.emit()


func _on_area_3d_body_exited(_body: Node3D) -> void:
	counter -= 1
	if counter < 0:
		counter = 0
	if is_pressed and counter == 0:
		is_pressed = false
		animation.play("unpress")
		plate_unpressed.emit()
