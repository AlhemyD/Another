extends Area2D

@export var item:InventoryItem
@export var id:int
@export_global_file var object_d_file
signal take_item(item)
var player_in_area=false
func _ready():
	if item:
		$sprite.texture=item.texture
	if id in global.items_taken:
		self.queue_free()
	elif id in global.visibled_objects:
		visible=true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("touch") and len(get_overlapping_bodies())>0 and player_in_area and not get_tree().get_root().get_node("Node").get_node("DialogueBox").d_active:
		#добавить проверку на наличие места в инвентаре
		if object_d_file:
			var dialogue=get_tree().get_root().get_node("Node").get_node("DialogueBox")
			if dialogue:
				dialogue.set_file(object_d_file)
				dialogue.start()
		queue_free()
		global.items_taken.append(id)
		take_item.emit(item)
func _on_player_entered(body: CharacterBody2D) -> void:
	player_in_area=true
	
	
