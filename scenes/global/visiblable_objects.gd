extends Node

@export var id:int
func _ready():
	if id in global.visibled_objects:
		self.visible=true
