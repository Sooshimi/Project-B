extends Node2D

@export var player_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.start_game:
		var player := player_scene.instantiate()
		add_child(player)
#		Global.add_player_to_scene("res://player.tscn", $PlayerStartPosition.position)
		player.global_position = $PlayerStartPosition.global_position
		Global.start_game = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_enter_building_1_body_entered(body):
	Global.goto_scene("res://house_1.tscn")
