extends Node3D

@export var catCount: int = 4

func _ready() -> void:
	Globals.level_cat_count = catCount
	Globals.level_cat_catched = 0
	
