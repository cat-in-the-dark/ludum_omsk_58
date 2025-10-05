class_name DoorLocker
extends Node3D

@onready var door: Node3D = $Door

@export var plates_required = 1
var plates_pressed = 0

func _on_plate_pressed():
	plates_pressed += 1
	if plates_pressed >= plates_required:
		pass
		#TODO: return when will implement
		#door.open()

func _on_plate_unpressed():
	plates_pressed -= 1
	if plates_pressed < plates_required:
		pass
		#TODO: return when will implement
		#door.close()

func _on_pressing_plate_plate_pressed() -> void:
	_on_plate_pressed()
	pass # Replace with function body.

func _on_pressing_plate_plate_unpressed() -> void:
	_on_plate_unpressed()
	pass # Replace with function body.
