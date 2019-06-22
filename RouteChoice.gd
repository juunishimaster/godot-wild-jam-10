extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var choice_a = "a"
var choice_b = "b"

signal route_selected(r)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_text(a, b):
	$HBoxContainer/ChoiceButtonA.text = "Go to checkpoint " + a
	choice_a = a
	$HBoxContainer/ChoiceButtonB.text = "Go to checkpoint " + b
	choice_b = b

func select_route(r):
	emit_signal("route_selected", r)

func _on_ChoiceButtonA_pressed():
	select_route(choice_a)


func _on_ChoiceButtonB_pressed():
	select_route(choice_b)
