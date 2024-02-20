extends Node2D

@export var player_scene : PackedScene
@export var player_start_position : Node

func _ready():
	#Audio.play_bg_music("village")
	Global.add_ui_to_scene("res://scenes/ui.tscn")
	# Spawns player in the middle of the map on first game launch
	if Global.start_game:
		var player := player_scene.instantiate()
		add_child(player)
		player.global_position = player_start_position.global_position
		Global.start_game = false

func _on_enter_building_1_body_entered(_body):
	Global.goto_scene("res://scenes/house_1.tscn")
	Global.add_ui_to_scene("res://scenes/ui.tscn")

func _on_enter_building_2_body_entered(_body):
	Global.goto_scene("res://scenes/house_2.tscn")
	Global.add_ui_to_scene("res://scenes/ui.tscn")
