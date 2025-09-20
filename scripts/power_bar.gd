extends Node2D

const SPEED = 70
const BAR_TOP = 0
const BAR_BOTTOM = 114
var moving = false
var power = null
var accuracy = null
var direction_up = true

func show_bar():
	show()
	
func hide_bar():
	stop()
	hide()
	reset_bar()

func reset_bar():
	$marker.position.y = BAR_BOTTOM;

func go():
	moving = true

func stop():
	moving = false

func set_carrot(pos_y: float, carrot_num: int = 1):
	var carrot;
	if (carrot_num == 1):
		carrot = $carrot_1
	else:
		carrot = $carrot_2
	carrot.position.y = pos_y
	carrot.visible = true

func move_bar(delta: float):
	var pos = $marker.position.y;
	if pos <= BAR_TOP:
		direction_up = false
	if pos > BAR_BOTTOM:
		stop()
		return
	var new_pos;
	if direction_up:
		new_pos = pos - (SPEED * delta);
	else:
		new_pos = pos + (SPEED * delta);
	$marker.position.y = new_pos;

func get_input():
	if Input.is_action_just_pressed("a"):
		if moving:
			if power == null:
				power = $marker.position.y
				direction_up = false
				set_carrot(power)
			else:
				accuracy = $marker.position.y
				set_carrot(accuracy, 2)
		else:
			go()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_bar()
	Events.swing.start_swing.connect(show_bar)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		get_input()	
	if moving:
		move_bar(delta)
