extends CanvasLayer
@export_global_file var d_file
var dialogue=[]
var current_dialogue_id=-2
var d_active=false
var continues
var read
var end
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
	read=load_file("res://assets/dialogues/flags.json")
	continues=load_file("res://assets/dialogues/continues.json")
	#split[0] - начало, если прочитано
	#split[1] - конец, если не прочитано
	if read[0][d_file]=="false":
		if "no" in continues[0][d_file]:
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
func load_file(l_file):
	var json=JSON.new()	
	var file=FileAccess.open(l_file,FileAccess.READ)
	var json_text=file.get_as_text()
	file.close()
	json.parse(json_text)
	var json_data=json.get_data()
	return json_data
func write_file(file_path, variable):
	var json_string=JSON.stringify(variable)
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
func load_dialogue():
	return load_file(d_file)

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
		return
	$NinePatchRect/Name.text=dialogue[current_dialogue_id]["name"]
	$NinePatchRect/Text.text=dialogue[current_dialogue_id]["text"]
	$NinePatchRect/Reaction.text=dialogue[current_dialogue_id]["reaction"]
	print(dialogue[current_dialogue_id]["text"])


func _on_timer_timeout() -> void:
	current_dialogue_id=-2
	d_active=false
