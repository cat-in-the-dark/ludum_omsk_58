extends Window

func _ready() -> void:
	transient = true # Make the window considered as a child of the main window
	close_requested.connect(on_close) # connect window closing event
	
func on_close() -> void:
	# queue_free() # close this window
	# quit the game on any window is closed
	get_tree().quit()
