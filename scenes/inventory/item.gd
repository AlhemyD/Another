extends Area2D

@export var item:InventoryItem
signal take_item(item)
var player_in_area=false
func _ready():
	if item:
		
		$sprite.texture=item.texture

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("touch") and len(get_overlapping_bodies())>0 and player_in_area and not get_tree().get_root().get_node("Node").get_node("DialogueBox").d_active:
		#добавить проверку на наличие места в инвентаре
		queue_free()
		take_item.emit(item)
func _on_player_entered(body: CharacterBody2D) -> void:
	player_in_area=true
	
	
