class_name Door
extends Node3D

var is_closed = true
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var body: StaticBody3D = $MeshInstance3D/StaticBody3D

func open():
	if is_closed:
		is_closed = false
		mesh.visible = false
		body.set_collision_layer_value(1, false)
	
func close():
	if not is_closed:
		is_closed = true
		mesh.visible = true
		body.set_collision_layer_value(1, true)
