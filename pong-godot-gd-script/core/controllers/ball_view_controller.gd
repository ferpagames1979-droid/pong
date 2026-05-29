## =================================================
## CLASS: BallViewController
## DESCRIPTION: Controls ball movement and behavior.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
class_name BallViewController
extends Area2D

const CLASS_NAME_LOG = "BallViewController"

var model : BallModel = BallModel.new()

func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG, PrintLogManager.LogType.INFO, " _ready()")
	
## Called every frame — moves the ball based on model data
func _process(delta: float) -> void:
	if not model.is_active:
		return
	position += model.direction * model.speed * delta
	
## Reverses the ball horizontal direction (bounce on paddles)
func bounce_horizontal() -> void:
	model.direction.x *= -1

## Reverses the ball vertical direction (bounce on paddles)
func bounce_vertical() -> void:
	model.direction.y *= -1
	
## Launches the ball in a random direction
func launch() -> void:
	model.is_active = true
	model.direction = _get_random_direction()
	PrintLogManager.printlog(CLASS_NAME_LOG, PrintLogManager.LogType.INFO, str(model.direction))
	
## Resets ball to center position
func reset_ball() -> void:
	model.reset()
	position = Vector2.ZERO
	PrintLogManager.printlog(CLASS_NAME_LOG, PrintLogManager.LogType.INFO, "Ball is reset")
	
## Returns a random normalize direction
func _get_random_direction() -> Vector2:
	var _angle = randf_range(-45.0, 45.0)
	var direction = Vector2(0, 1)
	return direction.rotated(deg_to_rad(_angle)).normalized()
	
	
