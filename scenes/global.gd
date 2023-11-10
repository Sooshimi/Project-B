extends Node

var current_scene = null
var player = null
var start_game := true
var player_hp := 3
var max_player_hp := 3
var ui = null
var quest_page = null

func _ready():
	get_scene()

func _unhandled_input(_event):
	if Input.is_action_pressed("escape"):
		get_tree().quit()
	if Input.is_action_just_pressed("quest_page"):
		var page = current_scene.get_node("QuestPage")
		if page.visible:
			current_scene.get_node("QuestPage").hide()
		else:
			current_scene.get_node("QuestPage").show()

func get_scene():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	return current_scene

func goto_scene(path:String):
	# Defer the scene load to a later time when no code is running
	# in the current scene.
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path:String):
	current_scene.free() # Now safe to remove current scene
	var loaded_scene = ResourceLoader.load(path) # Load new scene
	current_scene = loaded_scene.instantiate() # Instantiate new scene
	get_tree().root.add_child(current_scene) # Add it as a child of the root
	# (Optional) Make compatible with SceneTree.change_scene_to_file() API
	get_tree().current_scene = current_scene

func add_player_to_scene(path:String, position:Vector2):
	call_deferred("_deferred_add_player_to_scene", path, position)

func _deferred_add_player_to_scene(path:String, position:Vector2):
	var load_player = ResourceLoader.load(path)
	player = load_player.instantiate()
	get_scene().add_child(player)
	player.position = position

func add_ui_to_scene(path:String):
	call_deferred("_deferred_add_ui_to_scene", path)

func _deferred_add_ui_to_scene(path:String):
	var load_ui = ResourceLoader.load(path)
	ui = load_ui.instantiate()
	get_scene().add_child(ui)
	add_quest_page_to_scene()

func add_quest_page_to_scene():
	var load_quest_page = ResourceLoader.load("res://scenes/quest_page.tscn")
	quest_page = load_quest_page.instantiate()
	get_scene().add_child(quest_page)

func damage_player(amount:int):
	player_hp -= amount
	get_scene().get_node("UI").minus_hearts(amount)

func heal_player(amount:int):
	if player_hp < max_player_hp:
		player_hp += amount
		get_scene().get_node("UI").plus_hearts(amount)
