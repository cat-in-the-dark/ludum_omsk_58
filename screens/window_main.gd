extends Node

@onready var _MainWindow: Window = get_window()


func _ready() -> void:
	#_MainWindow.borderless = true		# Hide the edges of the window
	_MainWindow.unresizable = true		# Prevent resizing the window
	_MainWindow.always_on_top = true		# Force the window always be on top of the screen
	_MainWindow.gui_embed_subwindows = false	# Make subwindows actual system windows <- VERY IMPORTANT
	_MainWindow.transparent = true		# Allow the window to be transparent
	# Settings that cannot be set in project settings
	_MainWindow.transparent_bg = true	# Make the window's background transparent
