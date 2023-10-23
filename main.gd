extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_pressed("escape"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_enter_building_1_body_entered(body):
	Global.goto_scene("res://indoor_1.tscn")
	Global.add_player("res://player.tscn", Vector2(72,151))
