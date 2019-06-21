extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state

signal next_level
signal level_select

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ClosePanelButton_pressed():
	self.hide()
	if state == "clear":
		print("Next level")
	else:
		print("Back to level selection")
	pass # Replace with function body.


func _on_GameplayScene_stage_failed(why):
	state = why
	self.show()

	if state == "tax":
		$NewsPanel/EndLevelText.text = "*Delivery Failed*\n\nYou've been jailed for failing to pay taxes"
	elif state == "illegal":
		$NewsPanel/EndLevelText.text = "*Delivery Failed*\n\nYou've been jailed for bringing illegal goods"
	$ClosePanelButton.text = "Back to Level Selection"
	pass # Replace with function body.


func _on_GameplayScene_stage_cleared():
	state = "clear"

	pass # Replace with function body.
