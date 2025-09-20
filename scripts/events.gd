extends Node

var cars = CarEvents.new()
var swing = SwingEvents.new()

class CarEvents:
	signal car_entered
	signal car_exited(position: Vector2)

class SwingEvents:
	signal start_swing
	signal cancel_swing
	signal end_swing(power: float, accuracy: float)
