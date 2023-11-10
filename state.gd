extends Node

var npc_state : Dictionary = {"bon" = {"interacted": false,\
									   "interacted_after_kill": false,\
									   "lizard_alive": true,\
									   "quest_completed": false,\
									   "quest_hand_in": false}}

var quests_started : Array = []

# This signal is emitted whenever this function is called. This signal is
# connected to the QuestPage where it updates the quest page depending on the
# quest states from this State script.
signal quest_ping
func emit_quest_ping():
	quest_ping.connect(get_tree().current_scene.get_node("QuestPage").update_quest_page)
	quest_ping.emit()

# The quests_started array is appended with names of NPCs whenever their quests
# have started.
# The below function is called from the main.dialogue script to check if the
# passed name parameter already exists in the quests_started array to avoid 
# duplicates.
# The quest_start signal is connected to a QuestPage scene function and emitted
# to update the quest page.
signal quest_started
func check_and_append(name: String):
	if !quests_started.has(name):
		quests_started.append(name)
		quest_started.connect(get_tree().current_scene.get_node("QuestPage").update_quest_page)
		quest_started.emit()
