extends CharacterBody2D

var default_speed := 35
var speed := default_speed
var relative_direction : Vector2
var chase := false
var knockback_strength := 200
var collision

@export var animation_tree : Node

func _ready():
	animation_tree.active = true

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
	
	collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.slide(collision.get_normal())
		
		if "Player" in collision.get_collider().name:
			collision.get_collider().knockback = relative_direction * knockback_strength
	
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
