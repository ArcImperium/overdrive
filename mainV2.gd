extends CharacterBody2D

@onready var sprite = $PlayerSprite

var score = 0
var level = 0

var total_coins = 20

var start_pos

@onready var coin_label = get_parent().get_node("CanvasLayer/CoinLabel")
@onready var level_label = get_parent().get_node("CanvasLayer/LevelLabel")
@onready var win_label = get_parent().get_node("WinLabel")

var speed_mod = 1
var jump_mod = 1

const BASE_SPEED = 300.0
const BASE_JUMP_VELOCITY = -900.0

var run = true

func _ready():
	win_label.hide()
	
	updateUI()
	start_pos = global_position

func _physics_process(delta: float) -> void:
	if (run == true):
		var SPEED = BASE_SPEED * speed_mod
		var JUMP_VELOCITY = BASE_JUMP_VELOCITY * jump_mod
		
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		if not is_on_floor():
			if sprite.animation != "jump":
				sprite.play("jump")
		elif direction != 0:
			if sprite.animation != "walk":
				sprite.play("walk")
		else:
			if sprite.animation != "default":
				sprite.play("default")
		
		if direction != 0:
			sprite.flip_h = direction > 0
			
		if global_position.y > 2000:
			respawn()

func respawn():
	if score == total_coins:
		level += 1
		speed_mod *= 1.25
		jump_mod /= 1.1
	else:
		level -= 1
		speed_mod /= 1.25
		jump_mod *= 1.25
	
	score = 0
	
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.show()
		coin.monitoring = true
	
	updateUI()
	
	global_position = start_pos
	velocity = Vector2.ZERO
	
	if level == 5 || level == -5:
		run = false
		win_label.show()
		sprite.play("default")

func plusScore(amt):
	score += amt
	updateUI()
	
func updateUI():
	coin_label.text = "\nCoins: " + str(score) + "/" + str(total_coins)
	level_label.text = "Level: " + str(level) + "/5"
