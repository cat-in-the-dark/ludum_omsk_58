extends Window

func _ready() -> void:
	close_requested.connect(on_close) # connect window closing event
	#content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	#content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	#content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	#content_scale_size = Vector2i(640, 360)
	
func on_close() -> void:
	# queue_free() # close this window
	# quit the game on any window is closed
	get_tree().quit()
