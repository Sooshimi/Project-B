extends CharacterBody2D

var speed := 75
var input_direction : Vector2
var is_attacking : bool
var attack_direction : Vector2
var knockback := Vector2.ZERO
var enemy_collision : bool
var enemy_relative_direction : Vector2
var collision

@export var weapon_scene : PackedScene
@export var animation_tree : Node
@export var weapon_point_right : Node
@export var weapon_point_left : Node
@export var weapon_point_up : Node
@export var weapon_point_down : Node

func _ready():
	animation_tree.active = true
	is_attacking = false

func _physics_process(delta):
	# move_and_collide() used instead of move_and_slide() as we do not want
	# multiple collision detection
	collision = move_and_collide(velocity * delta)
	get_input()
	play_move_animations()
	play_attack_animations()
	
	if collision:
		# Allows player to slide on walls
		velocity = velocity.slide(collision.get_normal())
	
	# Quickly return knockback value to 0 after knockback
	knockback = lerp(knockback, Vector2.ZERO, 0.1)

func get_input():
	# Enable player movement if not attacking
	if !is_attacking && is_visible_in_tree():
		input_direction = Input.get_vector("left", "right", "up", "down")
		
		# Knockback updated in enemy script, as move_and_collide() collision
		# detection only detects when player is moving
		velocity = (input_direction * speed) + knockback
	else:
		# Else stop player movement when attacking
		velocity = Vector2.ZERO

func play_move_animations():
	# If player not moving, travel to idle animation
	if input_direction == Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Idle")
	else:
		# If player moving, travel to walk animation
		# Set blend positions (directions) of animations based on player input
		animation_tree.get("parameters/playback").travel("Walk")
		animation_tree.set("parameters/Idle/blend_position", input_direction)
		animation_tree.set("parameters/Walk/blend_position", input_direction)
		animation_tree.set("parameters/Attack/blend_position", input_direction)

func play_attack_animations():
	if Input.is_action_just_pressed("attack") && is_visible_in_tree():
		# Bool to stop player movement when attacking
		is_attacking = true
		
		# When attacking, travel to attack animation
		animation_tree.get("parameters/playback").travel("Attack")
		
		# Get attack facing direction
		attack_direction = round_vector(animation_tree.get("parameters/Walk/blend_position"))
		
		# Instantiate weapon scene
		var weapon = weapon_scene.instantiate()
		
		# Set weapon position and rotation based on facing direction.
		if attack_direction == Vector2(1,0) ||\
			attack_direction == Vector2(1,-1) ||\
			attack_direction == Vector2(1,1):
			weapon.position = weapon_point_right.position
			weapon.rotation = weapon_point_right.rotation
		elif attack_direction == Vector2(-1,0) ||\
			attack_direction == Vector2(-1,-1) ||\
			attack_direction == Vector2(-1,1):
			weapon.position = weapon_point_left.position
			weapon.rotation = weapon_point_left.rotation
		elif attack_direction == Vector2(0,-1):
			weapon.position = weapon_point_up.position
			weapon.rotation = weapon_point_up.rotation
		else:
			weapon.position = weapon_point_down.position
			weapon.rotation = weapon_point_down.rotation
		
		add_child(weapon)
		
		# Wait for attack animation to finish before allowing player to
		# move again, and removing weapon
		await animation_tree.animation_finished
		is_attacking = false
		weapon.queue_free()

# Function to round blend position axis values to nearest integers.
# As player moves diagonally, x and y blend values become floats between
# -1 and 1, so the appropriate attack animations wouldn't be played.
func round_vector(blend_position:Vector2) -> Vector2:
	var rounded_x : float = round(blend_position.x)
	var rounded_y : float = round(blend_position.y)
	var vector := Vector2(rounded_x, rounded_y)
	return vector
