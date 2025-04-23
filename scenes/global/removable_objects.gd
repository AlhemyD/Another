extends Node

@export var id:int
func _ready():
	if id in global.removed_objects:
		queue_free()
