extends Node

var cars = CarEvents.new()

class CarEvents:
	signal car_entered
	signal car_exited(position: Vector2)
