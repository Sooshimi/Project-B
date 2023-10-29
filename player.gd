extends CharacterBody2D

var speed := 100
var input_direction : Vector2

@onready var animation_tree := $AnimationTree
@onready var attack_speed_timer := $AttackSpeedTimer

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	get_input()
	move_and_slide()

func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if velocity == Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Idle")
	else:
		animation_tree.get("parameters/playback").travel("Walk")
		animation_tree.set("parameters/Idle/blend_position", input_direction)
		animation_tree.set("parameters/Walk/blend_position", input_direction)
		animation_tree.set("parameters/Attack/blend_position", input_direction)
	
	if Input.is_action_pressed("attack"):
		animation_tree.get("parameters/playback").travel("Attack")
