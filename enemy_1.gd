extends CharacterBody2D

const speed := 40
var relative_direction : Vector2
var chase := false

func _ready():
	pass

func _process(delta):
	var player = Global.get_scene().get_node("Player")
	
	# Get relative direction between player and enemy position.
	# Normalize so length of vector is 1.
	relative_direction = (player.position - position).normalized()
	
	# Sets chase condition if player is within range
	if position.distance_to(player.position) < 60:
		chase = true

	if chase:
		# Sets velocity which changes based on relative direction
		velocity = Vector2(relative_direction * speed)
		move_and_slide()
