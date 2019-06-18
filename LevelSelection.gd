extends GridContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal load_level(lv)

# Called when the node enters the scene tree for the first time.
func _ready():
	var lv_counter = 0
	for button in get_tree().get_nodes_in_group("level_buttons"):
		button.connect("pressed", self, "level_button_pressed", [lv_counter])
		lv_counter += 1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func level_button_pressed(lv):
	print("Load level-" + str(lv))
	#emit signal of level data
	#hide this level selection