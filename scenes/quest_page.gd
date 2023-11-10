extends CanvasLayer

@onready var quest_label_scene = load("res://scenes/quest_label.tscn")
@onready var quest_list = %QuestList

var quest_dict : Dictionary = {"bon": "Kill lizard"}

var quest_dict_2: Dictionary = \
	{"bon" =  {"quest_name": "Kill lizard",\
			  "hand_in_text": "Talk to Bon"}}

func _ready():
	hide()
	# Update the quest page with the current quest states from State whenever
	# this scene is added to the scene.
	update_quest_page()

# Called from signal emitted from State autoload
func update_quest_page():
	var quest_label = quest_label_scene.instantiate()
	
	# Checks every character list in State
	for character_1 in State.quests_started:
		# Checks every character in quest dictionary
		for character_2 in quest_dict_2:
			# Checks if both character names match from both arrays
			if character_1 == character_2:
				# If the quest label node doesn'texist, add the quest label
				if quest_list.get_node("QuestLabel") == null:
					quest_list.add_child(quest_label)
				
				# Update existing quest label's text to the hand-in text after
				# the lizard is killed.
				if State.bon_quest_hand_in:
					quest_list.get_node("QuestLabel").text = str(quest_dict_2[character_2]["hand_in_text"])
				else:
					# Otherwise, update quest label text to the quest name when
					# the quest is first picked up
					quest_label.text = str(character_2.capitalize(), " - ", quest_dict_2[character_2]["quest_name"])
				
				# Remove the quest label if it exists and quest is completed
				if quest_list.get_node("QuestLabel") != null && State.bon_quest_completed:
					quest_list.get_node("QuestLabel").queue_free()
