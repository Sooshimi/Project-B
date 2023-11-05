extends Node2D

func _ready():
	pass

func _process(delta):
	pass

func _on_exit_building_2_body_entered(body):
	Global.goto_scene("res://scenes/main.tscn")
	Global.add_player_to_scene("res://scenes/player.tscn", Vector2(-119, -142))
