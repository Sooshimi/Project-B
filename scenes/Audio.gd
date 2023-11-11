extends Node

@onready var village_bg_music = load("res://audio/4 - Village.ogg")
@onready var bon_bg_music = load("res://audio/27 - Chill.ogg")
@onready var bg_music = $BackgroundMusic

func play_bg_music(choice:String):
	if choice == "village":
		bg_music.stream = village_bg_music
	elif choice == "bon":
		bg_music.stream = bon_bg_music
	
	bg_music.play()
