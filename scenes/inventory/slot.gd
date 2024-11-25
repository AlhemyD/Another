extends Panel
@onready var background_sprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = %item

func update(item:InventoryItem):
	if !item:
		background_sprite.frame=0
		itemSprite.visible=false
	else:
		background_sprite.frame=1
		itemSprite.visible=true
		itemSprite.texture=item.texture
