extends Area2D

func _ready():
	pass

func _process(delta):
	pass

func _on_body_entered(body):
	body.queue_free()
	State.enemy_status = "dead"
