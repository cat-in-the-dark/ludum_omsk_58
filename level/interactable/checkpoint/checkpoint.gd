class_name Checkpoint
extends Node3D

@export var idx: int = 1
@onready var spawn_anchor: Vector3 = $SpawnAnchor.global_position

@onready var tvs: Array[TvSkin] = [
	$TV_Model_Player_1, $TV_Model_Player_2
]

func switch_off(player_idx):
	tvs[player_idx].switch_off_tv()

func switch_on(player_idx):
	tvs[player_idx].switch_on_tv()

func use_ckpt(player: Player) -> void:
	var prev_ckpt = player.checkpoint
	if prev_ckpt:
		prev_ckpt.switch_off(player.player_idx)
	switch_on(player.player_idx)
	player.checkpoint = self

func _on_trigger_area_body_entered(body: Node3D) -> void:
	if body is Player:
		use_ckpt(body)
