extends Area2D

@export var dialogue_resource : DialogueResource
@export var dialogue_start := "start"

func action():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
