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
var route_counter = 0
var total_routes = 0
var curr_money = 100

signal stage_failed(why)
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
	$EndLevel.hide()

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

func check_restriction(c):
	var curr_checkpoint
	if c == "a":
		curr_checkpoint = restriction_a
	elif c == "b":
		curr_checkpoint = restriction_b
	elif c == "c":
		curr_checkpoint = restriction_c
		
	var tax_applied = 0
	
	#Iterate the restriction
	for i in range(curr_checkpoint.size()):
		for j in range(delivery_goods.size()):
			#Check if the goods are listed in the restriction
			if delivery_goods[j]["type"] == curr_checkpoint[i]["goods"]:
				#Check if passable or tax-able
				if curr_checkpoint[i]["passable"] == "true":
					tax_applied += curr_checkpoint[i]["tax"]
				else:
					print("Bringing illegal goods")
					delivery_failed("illegal")
					return
	
	#Pay the accumulated tax
	if tax_applied > 0:
		pay_tax(tax_applied)
	else:
		#Next route or end level
		if route_counter == total_routes:
			delivery_succeed()
		else:
			randomize_route()
	pass
	
func pay_tax(t):
	if curr_money > t:
		curr_money -= t
		print("Paid " + str(t) + " for taxes")
	else:
		print("Failed to pay tax")
		delivery_failed("tax")
	pass
	
func delivery_failed(w):
	emit_signal("stage_failed", w)
	pass

func delivery_succeed():
	emit_signal("stage_cleared")
	pass

func _on_LevelSelection_load_level(lv):
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
	
	#Assign total routes
	total_routes = level_json["levels"][lv]["routesCount"]
	


func _on_BriefingNews_brief_closed():
	print("Game start")
	if restriction_a[0]["passable"] == "true":
		print(restriction_a[0]["goods"] + " is passable")
	else:
		print(restriction_a[0]["goods"] + " is not passable")
	#start the timer
	
	randomize_route()


func _on_RouteChoice_route_selected(r):
	route_counter += 1
	check_restriction(r)
	pass # Replace with function body.
