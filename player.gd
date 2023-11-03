extends CharacterBody2D

var speed := 75
var input_direction : Vector2
var is_moving : bool
var is_attacking : bool

@onready var animation_tree := $AnimationTree
@onready var attack_speed_timer := $AttackSpeedTimer

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
	
	# If attacking, travel to attack animation
	if Input.is_action_just_pressed("attack"):
		animation_tree.get("parameters/playback").travel("Attack")
		
		# Stop player movement until attack animation finishes
		is_attacking = true
		await animation_tree.animation_finished
		is_attacking = false
