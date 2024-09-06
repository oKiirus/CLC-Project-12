extends CharacterBody2D

var Cursor : AnimatedSprite2D
var JumpChargeBar : Sprite2D

@export_group("Movement")

@export_subgroup("Walk")
@export var walk_acceleration = 500
@export var max_walk_speed = 200
@export var walk_turn_boost = 2

@export_subgroup("Run")
@export var run_acceleration = 1000
@export var max_run_speed = 400
@export var run_turn_boost = 4

@export_subgroup("Jump")
@export var jump_power = 1
@export var max_jump_power = 700
@export var jump_charge_speed = 0.03

@export_group("Environment")

@export var gravity = 600
@export var air_friction = 10
@export var ground_friction = 3000
@export var terminal_velocity = 10000000


var acceleration = 10
var max_speed = 10
var friction = 1
var turn_boost
var charging_jump = false

var Input2 = Vector2(0, 0)

func _ready():
	Cursor = get_node("CursorSprite")
	JumpChargeBar = get_node("JumpChargeBar")

func _physics_process(delta):
	Input2 = get_input2()
	velocity += Vector2(0, gravity) * delta #Gravity
	scale = Vector2(1, 1)
	
	Cursor.position = get_local_mouse_position()
	
	print(jump_power)
	
	if is_on_floor():
		if Input.is_action_just_released("jump"):
			charging_jump = false
			jump_power = 1
		if Input.is_action_pressed("jump"):
			
			charging_jump = true
			jump_power += max_jump_power * jump_charge_speed
		if jump_power > max_jump_power:
			charging_jump = false
			
			velocity = Vector2(velocity.x, -jump_power)
			jump_power = 1
	else:
		jump_power = 1

	if Input.is_action_pressed("walk"):
		acceleration = walk_acceleration
		max_speed = max_walk_speed
		turn_boost = walk_turn_boost
	else: #Running
		acceleration = run_acceleration
		max_speed = max_run_speed
		turn_boost = run_turn_boost
	
		friction = air_friction
	
	
	
	#debug()
	
	if sign(velocity.x) == Input2.x:
		turn_boost = 1
	
	if not charging_jump:
		velocity += Vector2(Input2.x, 0) * acceleration * delta * turn_boost #Movin
	
	if Input2.x == 0 or charging_jump: #Friction
		if is_on_floor():
			var friction = Vector2(sign(-velocity.x) * ground_friction * delta, 0)
			
			if abs(friction.x) > abs(velocity.x) or velocity.x == 0:
				velocity = Vector2(0, velocity.y)
			else:
				velocity += Vector2(sign(-velocity.x) * ground_friction * delta, 0)
				
		else:
			friction = -velocity.normalized() * air_friction * delta
			
			if friction.length() > velocity.length() or velocity.length() == 0:
				velocity += -velocity.normalized() * air_friction * delta
	
	
	
	
	
	velocity = velocity.clamp(Vector2(-max_speed, -terminal_velocity), Vector2(max_speed, terminal_velocity))

	move_and_slide()

@export_group("DEBUG")
@export var debug_speed = 10

var up_var = {"name": "acceleration", "value": 600, "speed": 0.1}
var down_var = {"name": "max_speed", "value": 0, "speed": 0.1}
var right_var = {"name": "ground_friction", "value": 2000, "speed": 0.1}
var left_var = {"name": "air_friction", "value": 0, "speed": 0.1}

func debug():
	
	acceleration = up_var["value"]
	max_speed = down_var["value"]
	air_friction = left_var["value"]
	ground_friction = right_var["value"]
	
	
	if Input.is_action_pressed("ctrl"):
		debug_speed = 30
	else:
		debug_speed = 10
	if Input.is_action_just_pressed("walk"):
		debug_speed *= -1
	
	if Input.is_action_pressed("ui_up"):
		up_var["value"] += debug_speed * up_var["speed"]
	if Input.is_action_pressed("ui_down"):
		down_var["value"] += debug_speed * down_var["speed"]
	if Input.is_action_pressed("ui_left"):
		left_var["value"] += debug_speed * left_var["speed"]
	if Input.is_action_pressed("ui_right"):
		right_var["value"] += debug_speed * right_var["speed"]
	
	print("DEBUG")
	print("********************")
	print(up_var["name"])
	print(up_var["value"])
	
	print(down_var["name"])
	print(down_var["value"])
	
	print(right_var["name"])
	print(right_var["value"])
	
	print(left_var["name"])
	print(left_var["value"])
	print("********************")

func get_input2():
	var input_guh_2 = Vector2(0, 0)
	if Input.is_action_pressed("right") and Input.is_action_pressed("left"):
		pass
	elif Input.is_action_pressed("right"):
		input_guh_2 += Vector2.RIGHT
	elif Input.is_action_pressed("left"):
		input_guh_2 = Vector2.LEFT
	
	if Input.is_action_pressed("up") and Input.is_action_pressed("down"):
		pass
	elif Input.is_action_pressed("up"):
		input_guh_2 = Vector2.UP
	elif Input.is_action_pressed("down"):
		input_guh_2 = Vector2.DOWN
	
	return input_guh_2
