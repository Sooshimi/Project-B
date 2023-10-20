extends CharacterBody2D

var speed := 100

func _physics_process(delta):
	get_input()
	move_and_slide()

func get_input():
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
