extends Node2D

@export var player_scene : PackedScene

func _ready():
	# Spawns player in the middle of the map on first game launch
	if Global.start_game:
		var player := player_scene.instantiate()
		add_child(player)
		player.global_position = $PlayerStartPosition.global_position
		Global.start_game = false

func _process(delta):
	pass

func _on_enter_building_1_body_entered(body):
	Global.goto_scene("res://house_1.tscn")

func _on_enter_building_2_body_entered(body):
	Global.goto_scene("res://house_2.tscn")
