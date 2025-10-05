class_name TvSkin
extends Node3D

@onready var _mesh: MeshInstance3D = $"Sketchfab_model/852c0fe8cbc04f6e905fd3b71339eb74_fbx/RootNode/TVCRT/TVCRT_M_TVCRT_0"
@onready var _mat_on = preload("res://level/interactable/checkpoint/tv_on_mat.tres")
@onready var _mat_off = preload("res://level/interactable/checkpoint/tv_off_mat.tres")

func switch_on_tv():
	_mesh.set_surface_override_material(0, _mat_on)

func switch_off_tv():
	# TODO: switch off old display
	_mesh.set_surface_override_material(0, _mat_off)

func _ready() -> void:
	switch_off_tv()
