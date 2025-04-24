extends CanvasLayer


func _input(event):
	if event.is_action_pressed("inventory") and not get_tree().get_root().get_node("Node").get_node("DialogueBox").d_active:
		$InvPanel.toggle()
	if get_tree().get_root().get_node("Node").get_node("DialogueBox").d_active and $InvPanel.visible:
		$InvPanel.toggle()


func _on_item_area_2d_take_item(item: Variant) -> void:
	$InvPanel.on_take_item(item)

func is_item_here(item_name:String):
	return $InvPanel.is_item_here(item_name)
func remove_item(item_name:String):
	$InvPanel.remove_item(item_name)
func give_item(item_name:String):
	$InvPanel.give_item(item_name)
