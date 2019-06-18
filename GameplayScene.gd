extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://leveldata.json", File.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json).result
	file.close()
	
	if typeof(json_result) == TYPE_ARRAY:
		print("Hola")
	elif typeof(json_result) == TYPE_DICTIONARY:
		print("Tipe dictionary " + str(json_result["levels"][0]["news"]))
	else:
		print(typeof(json_result["levels"]))
	# Load delivery goods list for current level
	# Load checkpoint restrictions for current level
	# Start the game
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
