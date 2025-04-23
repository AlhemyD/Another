extends Node

var player_current_attack = false
var current_player_hp = 100
var enemies_hp={}
var enemies_slain=[]
var enemies_in_range={}
var enemies_attacking={}
var player_current_damage = 0
var items_taken=[]
var removed_objects=[]
var visibled_objects=[]
func load_file(l_file):
	var json=JSON.new()	
	var file=FileAccess.open(l_file,FileAccess.READ)
	var json_text=file.get_as_text()
	file.close()
	json.parse(json_text)
	var json_data=json.get_data()
	return json_data
