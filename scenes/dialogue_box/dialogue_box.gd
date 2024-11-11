extends CanvasLayer
@export_global_file var d_file
var dialogue=[]
var current_dialogue_id=-2
var d_active=false

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
	#if dialogue[0]["read"]=="false":
	next_script()
	#elif dialogue[0]["line_if_read"]=="-1":
	#	d_active=false
	#	return
	#else:
	#	current_dialogue_id=int(dialogue[0]["line_if_read"])
	#	next_script()
	
func set_file(file:String):
	d_file=file
func load_dialogue():
	var json=JSON.new()	
	var file=FileAccess.open(d_file,FileAccess.READ)
	var json_text=file.get_as_text()
	file.close()
	json.parse(json_text)
	var json_data=json.get_data()
	#var json_data_copy=json_data
	#json_data_copy[0]["read"]="true"
	#json_data_copy=JSON.stringify(json_data_copy)
	#file=FileAccess.open(d_file,FileAccess.WRITE)
	#file.store_string(json_data_copy)
	#file.close()
	return json_data

func _input(event: InputEvent) -> void:
	if not d_active:
		return
	if event.is_action_pressed("touch"):
		next_script()
		
func next_script():
	current_dialogue_id+=1
	if current_dialogue_id>=len(dialogue):
		$Timer.start()
		$NinePatchRect.visible=false	
		return
	$NinePatchRect/Name.text=dialogue[current_dialogue_id]["name"]
	$NinePatchRect/Text.text=dialogue[current_dialogue_id]["text"]
	$NinePatchRect/Reaction.text=dialogue[current_dialogue_id]["reaction"]
	print(dialogue[current_dialogue_id]["text"])


func _on_timer_timeout() -> void:
	current_dialogue_id=-2
	d_active=false
