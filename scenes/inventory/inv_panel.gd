extends Panel
@onready var inventory: Inventory = preload("res://resources/inventory_res.tres")
@onready var slots: Array=$GridContainer.get_children()

func update():

	for i in range(min(inventory.items.size(),slots.size())):
		slots[i].update(inventory.items[i])

func _ready() -> void:
	visible=false
	update()

func toggle():
	visible=!visible

func _update_item(index:int,newItem:InventoryItem):
	inventory.items[index]=newItem
	slots[index].update(newItem)
	
	
func on_take_item(item:Variant) -> void:
	for i in range(inventory.items.size()):
		if !inventory.items[i]:
			_update_item(i,item)
			
			break

func is_item_here(item_name:String):
	for i in range(inventory.items.size()):
		if inventory.items[i] and inventory.items[i].name==item_name:
			return true
	return false
func remove_item(item_name:String) -> void:
	for i in range(inventory.items.size()):
		if inventory.items[i] and inventory.items[i].name==item_name:
			_update_item(i,null)
			return
func give_item(item_name:String) -> void:
	var item = load("res://resources/"+item_name)
	on_take_item(item)
