extends Node3D

@onready var _area_3d: Area3D = $Area3D
var counter: int

func _ready() -> void:
	_area_3d.body_entered.connect(_on_enter)
	_area_3d.body_exited.connect(_on_exit)

func _on_enter(body: PhysicsBody3D) -> void:
	if body is Player:
		counter = clampi(counter + 1, 0, Globals.n_players)
		if counter >= Globals.n_players:
			Events.flag_reached.emit()
		else:
			print('Need more players!')

func _on_exit(body: PhysicsBody3D) -> void:
	if body is Player:
		counter = clampi(counter - 1, 0, Globals.n_players)
