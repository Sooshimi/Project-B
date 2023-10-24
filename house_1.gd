extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_building_2_body_entered(body):
	Global.goto_scene("res://main.tscn")
#	Global.add_player_to_scene("res://player.tscn", Vector2(-215, -109))
