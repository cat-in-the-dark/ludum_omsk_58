extends CanvasLayer

@onready var label: Label = $Label

var winText = "You found %d/ %d cats, great! \n Press A to restart"

func _ready() -> void:
	label.text = winText % [Globals.level_cat_catched, Globals.level_cat_count]
