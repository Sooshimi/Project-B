extends CanvasLayer

@onready var quest_label_scene = load("res://scenes/quest_label.tscn")
@onready var quest_list = %QuestList

var quest_dict : Dictionary = {"bon": "Kill lizard"}

func _ready():
	hide()
	# Update the quest page with the current quest states from State whenever
	# this scene is added to the scene.
	update_quest_page()

# Called from signal emitted from State autoload
func update_quest_page():
	var quest_label = quest_label_scene.instantiate()
	
	# Checks every character list in State
	for character in State.quests_started:
		# Checks every quest in quest dictionary
		for quest in quest_dict:
			# Update quest label text, adding the character name and the
			# the matching character's quest name.
			quest_label.text = str(character.capitalize(), " - ", quest_dict[character])
			quest_list.add_child(quest_label)
