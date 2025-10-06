extends Node

@onready var player_1: Player = $"../game/Player_1"
@onready var player_2: Player = $"../game/Player_2"

func _ready() -> void:
	Globals.single_player = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("switch_char"):
		var idx = player_1.player_idx
		player_1.player_idx = player_2.player_idx
		player_2.player_idx = idx
		
		var camera = player_1._camera
		player_1._camera = player_2._camera
		player_2._camera = camera
		
		player_1.setup_crosshair()
		player_2.setup_crosshair()
