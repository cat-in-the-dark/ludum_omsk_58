extends CanvasLayer

@onready var label: Label = $Label

var winText = "You found %d/ %d cats, great!\nLevel cleared in %d seconds\nPress ESC to restart"

func _ready() -> void:
	label.text = winText % [Globals.level_cat_catched, Globals.level_cat_count, Globals.level_cleared_in_seconds]
