extends CharacterBody2D
@export var hp = 20
@export var speed = 100
var player_chase = false
var player = null

func _physics_process(delta: float) -> void:
	if player_chase and position.distance_to(player.position) > 60:
		velocity = (player.get_global_position() - position).normalized() * speed * delta
		
		if velocity.y != 0 && velocity.y>0:
			$AnimatedSprite2D.animation = "down"
		elif velocity.y != 0 && velocity.y<0:
			$AnimatedSprite2D.animation="up"
		$AnimatedSprite2D.play()
		
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.07)
		$AnimatedSprite2D.stop()
	move_and_collide(velocity)

func _on_detection_area_body_entered(body: CharacterBody2D) -> void:
	player = body
	player_chase=true
	


func _on_detection_area_body_exited(body: CharacterBody2D) -> void:
	player=null
	player_chase=false
