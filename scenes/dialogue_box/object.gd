extends Area2D
@export_global_file var object_d_file
var player_in_area=false
func _ready() -> void:
	connect("body_entered",_on_body_entered)
	connect("body_exited",_on_body_exited)
	
func _on_body_entered(body: CharacterBody2D):
	player_in_area=true
func _on_body_exited(body:CharacterBody2D):
	player_in_area=false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("touch") and len(get_overlapping_bodies())>0 and player_in_area and not get_tree().get_root().get_node("Node").get_node("DialogueBox").d_active:
		use_dialogue()
func use_dialogue():
	var dialogue=get_tree().get_root().get_node("Node").get_node("DialogueBox")
	
	if dialogue:
		dialogue.set_file(object_d_file)
		dialogue.start()
