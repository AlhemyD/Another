extends CharacterBody2D
@export var speed=200
@export var limit_left = -10000000
@export var limit_top = -10000000
@export var limit_right = 10000000
@export var limit_bottom = 10000000
@export var damage = 20
@export var side:String

var enemy_in_range = false
var number_enemy_in_range = 0
var enemy_attack_cooldown = true
var alive = true
var attack_in_progress = false

var regen = false

var screen_size
var slain_flags={"res://assets/dialogues/Отдел по роботизации трудовых процессов (R-1)/После аннигиляции противника.json":false}

func _ready():
	
	screen_size = Vector2(pow(2,20),pow(2,20))
	var cam=$Camera2D
	cam.limit_left = limit_left
	cam.limit_top=limit_top
	cam.limit_bottom=limit_bottom
	cam.limit_right=limit_right
	if global.side:
		side=global.side
	if side in ["down", "left", "right", "up"]:
		$AnimatedSprite2D.animation=side
	if global.player_x:
		position.x=global.player_x
		global.player_x=null
	if global.player_y:
		position.y=global.player_y
		global.player_y=null
	
	
func _physics_process(delta):
	if get_tree().get_root().get_node("Node").get_node("DialogueBox"):
		if get_tree().get_root().get_node("Node").get_node("DialogueBox").d_active:
			$AnimatedSprite2D.stop()
			return
		elif len(global.enemies_slain)==5 and not slain_flags["res://assets/dialogues/Отдел по роботизации трудовых процессов (R-1)/После аннигиляции противника.json"]:
			var dialogue_ = get_tree().get_root().get_node("Node").get_node("DialogueBox")
			dialogue_.set_file("res://assets/dialogues/Отдел по роботизации трудовых процессов (R-1)/После аннигиляции противника.json")
			dialogue_.current_dialogue_id=-1
			dialogue_.start()
			slain_flags["res://assets/dialogues/Отдел по роботизации трудовых процессов (R-1)/После аннигиляции противника.json"]=true
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
		global.player_current_damage = damage
	if Input.is_action_pressed("speed_up"):
		speed = 300
	else:
		speed = 200
		
		
		
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
	update_health()
	move_and_slide()
	
	enemy_attack(10)
	
	if global.current_player_hp<=0:
		alive = false #добавить экран смерти
		global.current_player_hp = 0
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

func enemy_attack(damage: int):
	if enemy_in_range and enemy_attack_cooldown:
		global.current_player_hp -= damage
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		
		print(global.current_player_hp)

func player():
	pass



func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	global.player_current_damage = 0
	attack_in_progress = false


func update_health():
	var healthbar = $HealthBar
	healthbar.value = global.current_player_hp
	
	if global.current_player_hp >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
		if not regen:
			$regen_timer.start()
			regen = true
		
		

func _on_regen_timer_timeout() -> void:
	if global.current_player_hp < 100 and alive and regen:
		global.current_player_hp+=20
		
		if global.current_player_hp>100:
			global.current_player_hp=100
			$regen_timer.stop()
			regen = false
		print("Healed player + 20 hp, current HP: ",global.current_player_hp)
	
