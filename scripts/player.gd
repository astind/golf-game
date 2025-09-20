class_name Player extends CharacterBody2D

enum player_state {MOVING, DRIVING, SWINGING}

const SPEED = 100
var last_direction: Vector2
var last_animation: String
var state = player_state.MOVING
var aim = null
var swinging = false

func _ready() -> void:
	Events.cars.car_entered.connect(on_car_entered)
	Events.cars.car_exited.connect(on_car_exit)
	Events.swing.end_swing.connect(on_swing_end)

func start_swing():
	state = player_state.SWINGING
	Events.swing.start_swing.emit()

func cancel_swing():
	state = player_state.MOVING
	Events.swing.cancel_swing.emit()

func on_car_entered():
	state = player_state.DRIVING
	hide()
	$CollisionShape2D.disabled = true
	
func on_car_exit(car_pos: Vector2):
	state = player_state.MOVING
	$CollisionShape2D.disabled = false
	position.x = car_pos.x
	position.y = car_pos.y
	show()

func on_swing_end(power: float, accuracy: float):
	print(power)
	print(accuracy)
	swinging = true

func get_input():
	if state == player_state.MOVING:
		last_direction = Input.get_vector("left", "right", "up", "down")
		if Input.is_action_just_released("b"):
			start_swing()
	elif state == player_state.SWINGING:
		var aim_input  = Input.get_axis("left", "right")
		if Input.is_action_just_released("up"):
			#change club up
			pass
		elif Input.is_action_just_released("down"):
			# change club down
			pass
		if Input.is_action_just_released("b"):
			cancel_swing()
			
	# Driving State input is handled by the car class

func handle_movement():
	velocity = last_direction * SPEED
	move_and_slide()
	
func set_animation():
	var animation = null
	var flip = false
	if state == player_state.MOVING:
		var dir = 'idle'
		if (last_direction.x > 0 or last_direction.x < 0):
			dir = 'side'
			if last_direction.x < 0:
				flip = true
		elif (last_direction.y > 0 or last_direction.y < 0):
			dir = 'down'
		animation = 'walk_' + dir
	if state == player_state.SWINGING:
		if swinging:
			animation = "swing"
		else:
			animation = "tee"
	$AnimatedSprite2D.flip_h = flip
	if animation != last_animation:
		last_animation = animation
		$AnimatedSprite2D.play(animation)

func _process(_delta: float) -> void:
	if state != player_state.DRIVING:
		set_animation()

func _physics_process(_delta: float):
	if state != player_state.DRIVING:
		get_input()
	if state == player_state.MOVING:
		handle_movement()

func _on_animated_sprite_2d_animation_finished() -> void:
	if swinging:
		swinging = false
		cancel_swing()
