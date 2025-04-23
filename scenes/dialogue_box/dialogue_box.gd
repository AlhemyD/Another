extends CanvasLayer
@export_global_file var d_file
var dialogue=[]
var current_dialogue_id=-2
var d_active=false
var continues
var read
var end
var change_scene = null
var destroy=""
func _ready():
	$NinePatchRect.visible=false
	if d_file:
		current_dialogue_id=-1
		start()

func start():
	if d_active:
		return
	d_active=true
	$NinePatchRect.visible=true
	dialogue=load_dialogue()
	read=global.load_file("res://assets/dialogues/flags.json")
	continues=global.load_file("res://assets/dialogues/continues.json")
	#split[0] - начало, если прочитано. Номер минус 2 (-2)
	#split[1] - конец, если не прочитано. Нумерация корректная, начинается с 0
	
	#если есть предмет
	#split[0] - название предмета
	#split[1] - конец, если нет предмета
	#split[2] - начало, если предмет есть
	if ".tres" in continues[0][d_file].split(" ")[0]:
			var item=continues[0][d_file].split(" ")[0].replace(".tres","")
			var inventory = get_tree().get_root().get_node("Node").get_node("Inventory")
			if inventory.is_item_here(item):
				current_dialogue_id=int(continues[0][d_file].split(" ")[2])
				end=len(dialogue)
			else:
				#zcurrent_dialogue_id = 0
				end=int(continues[0][d_file].split(" ")[1])
	elif read[0][d_file]=="false":	
		if "no" == continues[0][d_file]:
			end=len(dialogue)
		else:			
			end=int(continues[0][d_file].split(" ")[1])+1
	else:
		if "no" in continues[0][d_file]:
			current_dialogue_id=len(dialogue)
			end=len(dialogue)
		else:
			current_dialogue_id=int(continues[0][d_file].split(" ")[0])
			end=len(dialogue)
			
	
	next_script()
	
	
func set_file(file:String):
	d_file=file

func write_file(file_path, variable):
	var json_string=JSON.stringify(variable)
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
func load_dialogue():
	return global.load_file(d_file)

func _input(event: InputEvent) -> void:
	if not d_active:
		return
	if event.is_action_pressed("skip_dialogue"):
		next_script()
		
func next_script():
	current_dialogue_id+=1
	if current_dialogue_id>=end:
		$Timer.start()
		$NinePatchRect.visible=false
		if read[0][d_file]=="false":
			read[0][d_file]="true"
			write_file("res://assets/dialogues/flags.json", read)
		if destroy and get_tree().get_root().get_node("Node").get_node(destroy):
			global.removed_objects.append(get_tree().get_root().get_node("Node").get_node(destroy).id)			
			get_tree().get_root().get_node("Node").get_node(destroy).queue_free()
			destroy=""
		elif destroy:
			print(get_tree().get_root().get_node("Node").get_node(destroy).name)
			
		if change_scene:
			get_tree().change_scene_to_file(change_scene)
		return
	$NinePatchRect/Name.text=dialogue[current_dialogue_id]["name"]
	$NinePatchRect/Text.text=dialogue[current_dialogue_id]["text"]
	$NinePatchRect/Reaction.text=dialogue[current_dialogue_id]["reaction"]
	if "hp" in dialogue[current_dialogue_id]:
		global.current_player_hp-=int(dialogue[current_dialogue_id]["hp"])
		print(global.current_player_hp)
	if "change_scene" in dialogue[current_dialogue_id]:
		change_scene=dialogue[current_dialogue_id]["change_scene"]
	if "destroy" in  dialogue[current_dialogue_id]:
		destroy=dialogue[current_dialogue_id]["destroy"]
	if "remove" in dialogue[current_dialogue_id]:
		get_tree().get_root().get_node("Node").get_node("Inventory").remove_item(dialogue[current_dialogue_id]["remove"])
	if "visible" in dialogue[current_dialogue_id] and get_tree().get_root().get_node("Node").get_node(dialogue[current_dialogue_id]["visible"]):
		get_tree().get_root().get_node("Node").get_node(dialogue[current_dialogue_id]["visible"]).visible=true
		global.visibled_objects.append(get_tree().get_root().get_node("Node").get_node(dialogue[current_dialogue_id]["visible"]).id)
	print(dialogue[current_dialogue_id]["text"])


func _on_timer_timeout() -> void:
	current_dialogue_id=-2
	d_active=false
