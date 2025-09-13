extends CharacterBody2D

const SPEED = 300
const ROT_SPEED = 1.5
const WHEEL_BASE = 70
const STEER_ANGLE = 15
const DRAG = -0.06
const FRICTION = -55
const BREAKING = -450
const MAX_REVERSE_SPEED = 200

var steer_dir
var acceleration = Vector2.ZERO
var driving = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func enable_ray_cast():
	$RayCast2D.enabled = true
	
func disable_ray_cast():
	$RayCast2D.enabled = false

func enter_cart():
	disable_ray_cast()
	Events.cars.car_entered.emit()
	driving = true
	
func exit_cart():
	enable_ray_cast()
	Events.cars.car_exited.emit(position)
	driving = false

func get_input():
	var turn = Input.get_axis("left", "right")
	steer_dir = turn * deg_to_rad(STEER_ANGLE)
	if Input.is_action_pressed("up"):
		acceleration = transform.x * SPEED
	if Input.is_action_pressed("down"):
		acceleration = transform.x * BREAKING
	if Input.is_action_just_released("action"):
		exit_cart()
		
func cal_steering(delta: float):
	# 1. Find the wheel positions
	var rear_wheel = position - transform.x * WHEEL_BASE / 2.0
	var front_wheel = position + transform.x * WHEEL_BASE / 2.0
	# 2. Move the wheels forward
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_dir) * delta
	# 3. Find the new direction vector
	var new_heading = (front_wheel - rear_wheel).normalized()
	var dir = new_heading.dot(velocity.normalized())
	# 4. Set the velocity and rotation to the new direction
	if dir > 0:
		velocity = new_heading * velocity.length()
	if dir < 0:
		velocity = -new_heading * min(velocity.length(), MAX_REVERSE_SPEED)
	rotation = new_heading.angle()

func apply_friction(delta: float):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * FRICTION * delta
	var drag_force = velocity * velocity.length() * DRAG * delta
	acceleration += drag_force + friction_force

func _physics_process(delta: float) -> void:
	if driving:
		acceleration = Vector2.ZERO
		get_input()
		apply_friction(delta)
		cal_steering(delta)
		velocity += acceleration * delta
		move_and_slide()
		
func checkActionInput():
	if Input.is_action_just_released("action"):
		enter_cart()

func _process(delta: float) -> void:
	if !driving:
		if $RayCast2D.is_colliding():
			checkActionInput()
