extends Area2D

func _ready():
	pass

func _process(_delta):
	remove_after_attack()

func _on_body_entered(body):
	if body.name == "Enemy1": # Bon's Lizard quest
		State.npc_state["bon"]["lizard_alive"] = false
		State.npc_state["bon"]["quest_hand_in"] = true
		State.emit_quest_ping()
	
	body.queue_free()

func remove_after_attack():
	if !get_parent().is_attacking:
		queue_free()
