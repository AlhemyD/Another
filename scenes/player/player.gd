extends CharacterBody2D
@export var speed=250
@export var hp = 100
@export var limit_left = -10000000
@export var limit_top = -10000000
@export var limit_right = 10000000
@export var limit_bottom = 10000000
@export var attack = 20

var enemy_in_range = false
var number_enemy_in_range = 0
var enemy_attack_cooldown = true
var alive = true
var attack_in_progress = false


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
		
		
	if Input.is_action_just_pressed("attack"):
		print("Player's attacking")
		attack_in_progress = true
		global.player_current_attack=true
		
		
		
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
	
	if attack_in_progress:
		if $AnimatedSprite2D.animation == "right":
			#$AnimatedSprite2D.animation = "attack_right"
			pass #play attack animation RIGHT
		if $AnimatedSprite2D.animation == "left":
			#$AnimatedSprite2D.animation = "attack_left"
			pass #play attack animation LEFT
		if $AnimatedSprite2D.animation == "up":
			#$AnimatedSprite2D.animation = "attack_up"
			pass #play attack animation UP
		if $AnimatedSprite2D.animation == "down":
			#$AnimatedSprite2D.animation = "attack_down"
			pass #play attack animation DOWN
		$deal_attack_timer.start()
	move_and_slide()
	
	enemy_attack()
	
	if hp<=0:
		alive = false #добавить экран смерти
		hp = 0
		print("Player's dead")
		self.queue_free() #убрать позднее, просто удаляет узел из сцены

func _on_player_hitbox_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = true
		number_enemy_in_range += 1


func _on_player_hitbox_body_exited(body: CharacterBody2D) -> void:
	if body.has_method("enemy"):
		number_enemy_in_range -= 1
		if number_enemy_in_range <= 0:
			enemy_in_range = false

func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown:
		hp = hp - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		
		print(hp)

func player():
	pass



func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_in_progress = false


func update_health():
	var healthbar = $HealthBar
	

func _on_regen_timer_timeout() -> void:
	pass # Replace with function body.
