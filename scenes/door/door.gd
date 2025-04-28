extends Area2D
@export_global_file var scene: String
@export var closed = false
@export var player_x:float
@export var player_y:float
@export var side:String
var player_in_area=false


func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_body_exited(body: CharacterBody2D) -> void:
	if body.has_method("player"):
		player_in_area = false
	
func _on_interact():
	if scene=="res://scenes/K-1/K-1.tscn" and global.load_file("res://assets/dialogues/flags.json")[0]["res://assets/dialogues/Лаборатория (Kоридор-1)/Вентиль.json"]!="false":
		get_tree().change_scene_to_file("res://scenes/K-1 (crystal)/K-1 (crystal).tscn")
	else:
		get_tree().change_scene_to_file(scene)
	
var change_door=false
var used_dialogue=false
func _process(delta):
	if player_in_area and Input.is_action_just_pressed("touch"):
		if get_node("Area2D"):
			get_node("Area2D").use_dialogue()
			used_dialogue=true
		elif not closed:
			change_door=true
	if not closed and used_dialogue and not get_tree().get_root().get_node("Node").get_node("DialogueBox").d_active:
		change_door=true
	if change_door:
		if player_x:
			global.player_x=player_x
		if player_y:
			global.player_y=player_y
		if side:
			global.side=side
		_on_interact()
