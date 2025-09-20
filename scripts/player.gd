extends CharacterBody2D

const SPEED = 100
var controlling = true
var last_direction
var state = "moving"

func _ready() -> void:
	Events.cars.car_entered.connect(on_car_entered)
	Events.cars.car_exited.connect(on_car_exit)

func on_car_entered():
	controlling = false
	hide()
	
func on_car_exit(car_pos: Vector2):
	controlling = true
	position.x = car_pos.x
	position.y = car_pos.y
	show()

func get_input():
	if state == "moving":
		last_direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_released("b"):
		Events.swing.start_swing.emit()
	
func handle_movement():
	velocity = last_direction * SPEED
	move_and_slide()
	
func set_animation():
	var dir = 'idle'
	var flip = false
	if (last_direction.x > 0 or last_direction.x < 0):
		dir = 'side'
		if last_direction.x < 0:
			flip = true
	elif (last_direction.y > 0 or last_direction.y < 0):
		dir = 'down'
	$AnimatedSprite2D.flip_h = flip
	$AnimatedSprite2D.play('walk_' + str(dir))

func _process(delta: float) -> void:
	set_animation()

func _physics_process(delta: float):
	if controlling:
		get_input()
		handle_movement()
