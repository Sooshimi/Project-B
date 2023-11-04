extends CharacterBody2D

var default_speed := 35
var speed := default_speed
var relative_direction : Vector2
var chase := false
var knockback_strength := 200
var collision
var player : Node

@export var animation_tree : Node

func _ready():
	animation_tree.active = true

func _process(delta):
	player = Global.get_scene().get_node("Player")
	
	# Get relative direction between player and enemy position.
	# Normalize so length of vector is 1.
	relative_direction = (player.position - position).normalized()
	
	collision = move_and_collide(velocity * delta)
	
	if collision:
		# Allows enemy to slide on walls
		velocity = velocity.slide(collision.get_normal())
		
		# Knockback player on collision
		knockback_player()
	
	play_move_animations()
	
	chase_player(player.position)

func chase_player(player_position:Vector2):
	# Sets chase condition if player is within range
	if position.distance_to(player_position) < 60:
		chase = true
	
	if chase:
		# Sets velocity which changes based on relative direction
		velocity = Vector2(relative_direction * speed)

func play_move_animations():
	# If enemy not moving, travel to idle animation
	if velocity == Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Idle")
	else:
		# If enemy moving, travel to walk animation
		# Set blend positions (directions) of animations based on relative direction
		animation_tree.get("parameters/playback").travel("Walk")
		animation_tree.set("parameters/Idle/blend_position", relative_direction)
		animation_tree.set("parameters/Walk/blend_position", relative_direction)
		animation_tree.set("parameters/Attack/blend_position", relative_direction)

func knockback_player():
	if "Player" in collision.get_collider().name:
		# Sets the player's knockback value (which adds onto its velocity)
		# to the relative_direction vector of the enemy, so the player
		# is knocked back the same direction the enemy is going
		collision.get_collider().knockback = relative_direction * knockback_strength
