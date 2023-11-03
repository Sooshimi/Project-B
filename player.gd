extends CharacterBody2D

var speed := 75
var input_direction : Vector2
var is_attacking : bool
var attack_direction : Vector2
const polearm_load = preload("res://polearm.tscn")

@onready var animation_tree := $AnimationTree
@onready var attack_speed_timer := $AttackSpeedTimer
@onready var weapon_point_right := $WeaponPointRight
@onready var weapon_point_left := $WeaponPointLeft
@onready var weapon_point_up := $WeaponPointUp
@onready var weapon_point_down := $WeaponPointDown

func _ready():
	animation_tree.active = true
	is_attacking = false

func _physics_process(delta):
	get_input()
	move_and_slide()

func get_input():
	# Enable player movement if not attacking
	if !is_attacking:
		input_direction = Input.get_vector("left", "right", "up", "down")
		velocity = input_direction * speed
	else:
		# Else stop player movement when attacking
		velocity = Vector2.ZERO
	
	# If player not moving, travel to idle animation
	if velocity == Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Idle")
	else:
		# If player moving, travel to walk animation
		# Set blend positions (directions) of animations based on player input
		animation_tree.get("parameters/playback").travel("Walk")
		animation_tree.set("parameters/Idle/blend_position", input_direction)
		animation_tree.set("parameters/Walk/blend_position", input_direction)
		animation_tree.set("parameters/Attack/blend_position", input_direction)
	
	if Input.is_action_just_pressed("attack"):
		# When attacking, travel to attack animation
		animation_tree.get("parameters/playback").travel("Attack")
		
		# Get attack facing direction
		attack_direction = fixed_vector(animation_tree.get("parameters/Walk/blend_position"))
		print(attack_direction)
		# Instantiate weapon scene
		var polearm = polearm_load.instantiate()
		
		# Set weapon position and rotation based on facing direction.
		if attack_direction == Vector2(1,0) ||\
			attack_direction == Vector2(1,-1) ||\
			attack_direction == Vector2(1,1):
			polearm.position = weapon_point_right.position
			polearm.rotation = weapon_point_right.rotation
		elif attack_direction == Vector2(-1,0) ||\
			attack_direction == Vector2(-1,-1) ||\
			attack_direction == Vector2(-1,1):
			polearm.position = weapon_point_left.position
			polearm.rotation = weapon_point_left.rotation
		elif attack_direction == Vector2(0,-1):
			polearm.position = weapon_point_up.position
			polearm.rotation = weapon_point_up.rotation
		else:
			polearm.position = weapon_point_down.position
			polearm.rotation = weapon_point_down.rotation
		
		add_child(polearm)
		
		# Stop player movement until attack animation finishes
		is_attacking = true
		await animation_tree.animation_finished
		is_attacking = false
		polearm.queue_free()

# Function to round blend position axis values to nearest integers.
# As player moves diagonally, x and y blend values become floats, so
# the appropriate attack animations wouldn't be played.
func fixed_vector(blend_position:Vector2) -> Vector2:
	var rounded_x = int(round(blend_position.x))
	var rounded_y = int(round(blend_position.y))
	var vector := Vector2(rounded_x, rounded_y)
	return vector
