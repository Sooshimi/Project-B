extends CanvasLayer

@onready var quest_label_scene = load("res://scenes/quest_label.tscn")
@onready var quest_list = %QuestList

var quest_dict: Dictionary = \
	{"bon" =  {"quest_name": "Kill lizard for Bon",\
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
		for character_2 in quest_dict:
			# Checks if both character names match from both arrays
			if character_1 == character_2:
				# If the quest label node doesn'texist, add the quest label
				if quest_list.get_node("QuestLabel") == null:
					# Assign character origin id to the quest label
					quest_label.character_origin = character_2
					quest_list.add_child(quest_label)
				
				# For every node in Quest List..
				for node in quest_list.get_children():
					# .. check if quest label's character origin matches the
					# current character of the quest we're iterating through
					if quest_list.get_node("QuestLabel").character_origin == character_2:
						# Update existing quest label's text to the hand-in text
						# after the quest can be handed in.
						if State.npc_state[character_2]["quest_hand_in"]:
							quest_list.get_node("QuestLabel").text = quest_dict[character_2]["hand_in_text"]
						else:
							# Otherwise, update quest label text to the quest name when
							# the quest is first picked up
							quest_label.text = quest_dict[character_2]["quest_name"]
						
						# Remove the quest label if it exists and quest is completed
						if \
						quest_list.get_node("QuestLabel") != null &&\
						State.npc_state[character_2]["quest_completed"]:
							quest_list.get_node("QuestLabel").queue_free()
