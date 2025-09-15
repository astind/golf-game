extends Node2D

const SPEED = 300
const BAR_TOP = 0
const BAR_BOTTOM = 114
var moving = false

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

func move_bar(delta: float):
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if moving:
		move_bar(delta)
