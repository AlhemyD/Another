extends CharacterBody2D
@export var hp = 100
@export var speed = 100
var player_chase = false
var player = null
@export var attack = 10
var player_in_range = false
@export var dead = false
var queue_freed = false
@export var enemy_id = 0

var can_take_damage = true

func _ready() -> void:
	if enemy_id in global.enemies_slain:
		self.queue_free()

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
	if dead and not queue_freed:
		self.queue_free()
		queue_freed = true
	deal_with_damage()

func _on_detection_area_body_entered(body: CharacterBody2D) -> void:
	player = body
	player_chase=true
	


func _on_detection_area_body_exited(body: CharacterBody2D) -> void:
	player=null
	player_chase=false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("player"):
		player_in_range = true


func _on_enemy_hitbox_body_exited(body: CharacterBody2D) -> void:
	if body.has_method("player"):
		player_in_range = false
		
func deal_with_damage():
	if player_in_range and global.player_current_attack and can_take_damage:
		hp-=20
		global.player_current_attack=false
		print("enemy was damaged. Current hp: ",hp)
		$take_damage_cooldown.start()
		can_take_damage=false
		if hp<=0:
			dead = true
			global.enemies_slain.append(enemy_id)
			print("enemy slain")


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	$take_damage_cooldown.stop()
