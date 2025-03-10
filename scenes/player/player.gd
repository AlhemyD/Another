extends CharacterBody2D
@export var speed=250
@export var limit_left = -10000000
@export var limit_top = -10000000
@export var limit_right = 10000000
@export var limit_bottom = 10000000



var screen_size

func _ready():
	screen_size = Vector2(pow(2,20),pow(2,20))
	var cam=$Camera2D
	cam.limit_left = limit_left
	cam.limit_top=limit_top
	cam.limit_bottom=limit_bottom
	cam.limit_right=limit_right
	
func _physics_process(delta):
	if get_tree().get_root().get_node("Node").get_node("DialogueBox"):
		if get_tree().get_root().get_node("Node").get_node("DialogueBox").d_active:
			$AnimatedSprite2D.stop()
			return
	var velocity=Vector2.ZERO
	if Input.is_action_pressed("move_right"):		
		velocity.x+=1
	if Input.is_action_pressed("move_left"):
		velocity.x-=1
	if Input.is_action_pressed("move_up"):
		velocity.y-=1
	if Input.is_action_pressed("move_down"):
		velocity.y+=1
	if velocity.length()>0:
		velocity=velocity.normalized()*speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0 && velocity.x>0:
		$AnimatedSprite2D.animation = "right"
	elif velocity.x != 0 && velocity.x<0:
		$AnimatedSprite2D.animation="left"
	elif velocity.y != 0 && velocity.y>0:
		$AnimatedSprite2D.animation = "down"
	elif velocity.y != 0 && velocity.y<0:
		$AnimatedSprite2D.animation="up"
	move_and_slide()



	
