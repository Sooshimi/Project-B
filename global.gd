extends Node

var current_scene = null
var player = null
var start_game := true

# Called when the node enters the scene tree for the first time.
func _ready():
	get_scene()

func _input(event):
	if Input.is_action_pressed("escape"):
		get_tree().quit()

func get_scene():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	return current_scene

func goto_scene(path):
	# Defer the scene load to a later time when no code is running
	# in the current scene.
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# Now safe to remove current scene
	current_scene.free()
	
	# Load new scene
	var loaded_scene = ResourceLoader.load(path)
	
	# Instantiate new scene
	current_scene = loaded_scene.instantiate()
	
	# Add it as a child of the root
	get_tree().root.add_child(current_scene)
	
	# (Optional) Make compatible with SceneTree.change_scene_to_file() API
	get_tree().current_scene = current_scene

func add_player_to_scene(player, position : Vector2):
	call_deferred("_deferred_add_player_to_scene", player, position)

func _deferred_add_player_to_scene(player, position):
	var load_player = ResourceLoader.load(player)
	player = load_player.instantiate()
	get_scene().add_child(player)
	player.position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
