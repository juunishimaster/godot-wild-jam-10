extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var level_json
var delivery_goods = {}
var restriction_a = {}
var restriction_b = {}
var restriction_c = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://leveldata.json", File.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json).result
	level_json = JSON.parse(json).result
	file.close()
		
	$BriefingNews.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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
	#start the timer
	pass # Replace with function body.
