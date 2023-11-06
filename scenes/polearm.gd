extends Area2D

func _ready():
	pass

func _process(delta):
	remove_after_attack()

func _on_body_entered(body):
	body.queue_free()
	State.enemy_status = "dead"

func remove_after_attack():
	if !get_parent().is_attacking:
		queue_free()
