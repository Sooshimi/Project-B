extends Area2D

func _ready():
	pass

func _process(delta):
	remove_after_attack()

func _on_body_entered(body):
	body.queue_free()
	State.enemy_alive = false
	State.bon_quest_hand_in = true
	State.emit_quest_ping()

func remove_after_attack():
	if !get_parent().is_attacking:
		queue_free()
