extends Area2D

func _ready():
	pass

func _process(delta):
	pass

func _on_body_entered(body):
	if Global.player_hp < Global.max_player_hp:
		Global.heal_player(1)
		queue_free()
