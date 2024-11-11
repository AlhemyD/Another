extends Area2D
@export_global_file var scene: String
var player_in_area=false


func _on_body_entered(body: CharacterBody2D) -> void:
	player_in_area = true


func _on_body_exited(body: CharacterBody2D) -> void:
	player_in_area = false
	
func _on_interact():
	
	#get_tree().get_root().get_node("Node").get_node("Player").position=spawn_position
	
		
	get_tree().change_scene_to_file(scene)
	
var change_door=false
var used_dialogue=false
func _process(delta):
	if player_in_area and Input.is_action_just_pressed("touch"):
		if get_node("Area2D"):
			get_node("Area2D").use_dialogue()
			used_dialogue=true
		else:
			change_door=true
	if used_dialogue and not get_tree().get_root().get_node("Node").get_node("DialogueBox").d_active:
		change_door=true
	if change_door:
		_on_interact()
