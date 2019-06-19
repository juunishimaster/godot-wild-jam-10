extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var level_json

var delivery_goods = {}

var restriction_a = {}
var restriction_b = {}
var restriction_c = {}

var available_routes = ["a", "b", "c"]
var chosen_route
var curr_money

signal stage_failed
signal stage_cleared

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://leveldata.json", File.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json).result
	level_json = JSON.parse(json).result
	file.close()
	
	#For randomizing the route
	randomize()
	
	$BriefingNews.hide()
	$RouteChoice.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func randomize_route():
	var rand_me = randi() % available_routes.size()
	var route_1 = available_routes[rand_me]
	var route_2
	print("Route 1: " + route_1)
	
	if rand_me == 2:
		if randf() < 0.5:
			route_2 = available_routes[0]
		else:
			route_2 = available_routes[1]
	elif rand_me == 1:
		if randf() < 0.5:
			route_2 = available_routes[0]
		else:
			route_2 = available_routes[2]
	else:
		if randf() < 0.5:
			route_2 = available_routes[2]
		else:
			route_2 = available_routes[1]
	
	print("Route 2: " + route_2)
	
	#Assign them into the choices
	$RouteChoice.show()
	$RouteChoice.set_text(route_1, route_2)
	pass

func check_restriction():
	pass

func delivery_failed():
	pass

func delivery_succeed():
	pass

func _on_LevelSelection_load_level(lv):
	print(level_json["levels"][lv]["newsA"])
	#Show and assign news
	$BriefingNews.show()
	
	$BriefingNews/NewsPanel/NewsContainer/AzuleNews.text = level_json["levels"][lv]["newsA"]
	$BriefingNews/NewsPanel/NewsContainer/BrueNews.text = level_json["levels"][lv]["newsB"]
	$BriefingNews/NewsPanel/NewsContainer/CyanNews.text = level_json["levels"][lv]["newsC"]
	
	#Assign checkpoint restrictions
	restriction_a = level_json["levels"][lv]["ruleA"]
	restriction_b = level_json["levels"][lv]["ruleB"]
	restriction_c = level_json["levels"][lv]["ruleC"]
	
	#Assign delivery goods
	delivery_goods = level_json["levels"][lv]["delivery"]
	
	print(delivery_goods[0]["name"])
	
	pass # Replace with function body.


func _on_BriefingNews_brief_closed():
	print("Game start")
	if restriction_a[0]["passable"] == "true":
		print(restriction_a[0]["goods"] + " is passable")
	else:
		print(restriction_a[0]["goods"] + " is not passable")
	#start the timer
	
	randomize_route()
	pass # Replace with function body.
