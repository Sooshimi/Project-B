extends Node

var enemy_alive := true

var bon_interacted := false
var bon_interacted_after_kill := false
var bon_quest_completed := false

var quests_started : Array = []

signal quest_started

# The quests_started array is appended with names of NPCs whenever their quests
# have started.
# The below function is called from the main.dialogue script to check if the
# passed name parameter already exists in the quests_started array to avoid 
# duplicates.
# The quest_start signal is connected to a QuestPage scene function and emitted
# to update the quest page.
func check_and_append(name: String):
	if !quests_started.has(name):
		quests_started.append(name)
		quest_started.connect(get_tree().current_scene.get_node("QuestPage").update_quest_page)
		quest_started.emit()
