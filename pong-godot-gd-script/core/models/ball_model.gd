## =================================================
## CLASS: BallModel
## DESCRIPTION: Holds all ball data and state.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
class_name BallModel
extends Resource

const CLASS_NAME_LOG = "BallModel"

## Ball movement speed in pixels per second
var speed: float = 300.0

## Current normalized movement direction
var direction: Vector2 = Vector2.ZERO

## Whether the ball is currently moving
var is_active: bool = false



func reset() -> void:
	self.direction = Vector2.ZERO
	self.is_active = false
	
	
