extends CanvasLayer

@export var heart_scene : PackedScene
@export var heart_container : Node

var heart

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(Global.player_hp):
		heart = heart_scene.instantiate()
		heart_container.add_child(heart)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func minus_hearts(amount:int):
	for i in range(amount):
		var last_child = heart_container.get_child_count() - 1
		heart_container.remove_child(heart_container.get_child(last_child))

func plus_hearts(amount:int):
	for i in range(amount):
		heart = heart_scene.instantiate()
		heart_container.add_child(heart)
