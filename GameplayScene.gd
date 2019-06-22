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
var curr_money = 1000

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
	$DashboardNotes.hide()
	$DashboardNotes2.hide()

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
		#Update KredsLabel
		$KredsLabel.text = str(curr_money) + " Kreds"
		#Next route or end level
		if route_counter == total_routes:
			delivery_succeed()
		else:
			randomize_route()
	else:
		print("Failed to pay tax")
		delivery_failed("tax")
	pass
	
func delivery_failed(w):
	$DashboardNotes.hide()
	$DashboardNotes2.hide()
	$EndLevel.show()
	emit_signal("stage_failed", w)
	pass

func delivery_succeed():
	$DashboardNotes.hide()
	$DashboardNotes2.hide()
	$EndLevel.show()
	emit_signal("stage_cleared")
	pass

func _on_LevelSelection_load_level(lv):
	$LevelSelection.hide()
	
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
	$BriefingNews.hide()
	
	#Restart the Kreds
	curr_money = 1000
	$KredsLabel.text = str(curr_money) + " Kreds"
	
	#Restart the route counter
	route_counter = 0
	
	#Set the dashboard delivery notes
	$DashboardNotes.show()
	var delivery_text = "Delivery List:\n"
	
	for d in range(delivery_goods.size()):
		delivery_text += "- " + delivery_goods[d]["name"] + " (" + delivery_goods[d]["type"] + ")\n"
	
	$DashboardNotes/Label.text = delivery_text
	
	#Set the dashboard checkpoint notes
	$DashboardNotes2.show()
	var checkpoint_text
	
	#Checkpoint A
	checkpoint_text = "Azule Checkpoints:\n"
	for a in range(restriction_a.size()):
		if restriction_a[a]["passable"] == "false":
			checkpoint_text += "- No " + restriction_a[a]["goods"] + "\n"
		else:
			checkpoint_text += "- " + restriction_a[a]["goods"] + " " + str(restriction_a[a]["tax"]) + " Kreds" + "\n"
	
	#Checkpoint B
	checkpoint_text += "\nBrue Checkpoints:\n"
	for b in range(restriction_b.size()):
		if restriction_b[b]["passable"] == "false":
			checkpoint_text += "- No " + restriction_b[b]["goods"] + "\n"
		else:
			checkpoint_text += "- " + restriction_b[b]["goods"] + " " + str(restriction_b[b]["tax"]) + " Kreds" + "\n"
	
	#Checkpoint C
	checkpoint_text += "\nCyan Checkpoints:\n"
	for c in range(restriction_c.size()):
		if restriction_c[c]["passable"] == "false":
			checkpoint_text += "- No " + restriction_c[c]["goods"] + "\n"
		else:
			checkpoint_text += "- " + restriction_c[c]["goods"] + " " + str(restriction_c[c]["tax"]) + " Kreds" + "\n"
	
	$DashboardNotes2/Label.text = checkpoint_text
	
	randomize_route()


func _on_RouteChoice_route_selected(r):
	$RouteChoice.hide()
	route_counter += 1
	check_restriction(r)


func _on_EndLevel_level_select():
	$EndLevel.hide()
	$LevelSelection.show()
	pass # Replace with function body.
