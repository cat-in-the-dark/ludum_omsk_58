extends Area3D


func _ready() -> void:
	body_entered.connect(func (_body_that_entered: PhysicsBody3D) -> void:
		#if _body_that_entered is CharacterBody3D:
			#await get_tree().process_frame
			#Events.kill_plane_touched.emit()
		#else:
		await get_tree().process_frame
		Events.kill_plane_touched_with_id.emit(_body_that_entered.get_instance_id())
	)
