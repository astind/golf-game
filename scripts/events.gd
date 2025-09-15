extends Node

var cars = CarEvents.new()
var ball = BallEvents.new()

class CarEvents:
	signal car_entered
	signal car_exited(position: Vector2)

class BallEvents:
	signal ball_hit
