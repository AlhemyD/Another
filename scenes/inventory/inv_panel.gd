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
