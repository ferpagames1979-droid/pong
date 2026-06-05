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

## Reference to screen exit notifier
@onready var screen_notifier: VisibleOnScreenEnabler2D = %VisibleOnScreenEnabler2D

func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG, PrintLogManager.LogType.INFO, " _ready()")
	body_entered.connect(_on_body_entered)
	screen_notifier.screen_exited.connect(_on_screen_exited)
	
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
	position = model.get_ball_position()
	PrintLogManager.printlog(CLASS_NAME_LOG, PrintLogManager.LogType.INFO, "Ball is reset")
	
## Returns a random normalize direction
func _get_random_direction() -> Vector2:
	var _angle = randf_range(-45.0, 45.0)
	var direction = Vector2(0, 1)
	return direction.rotated(deg_to_rad(_angle)).normalized()
	
## Called when Area2D detects StaticBody2D collision.
## Identifies what was hit and delegates to handler.
## [param body] - the StaticBody2D that was hit
func _on_body_entered(body : Node) -> void:
	if body is PaddlePlayerViewController:
		_handle_paddle_hit(PaddleBaseController.PLAYER_ID)
	elif body is PaddleAIViewController:
		_handle_paddle_hit(PaddleBaseController.IA_ID)
	elif body.is_in_group("walls"):
		_handle_wall_hit()
		
## Handles ball hitting a paddle — bounces vertically.
## [param paddle_id] - 1 = player | 2 = IA		
func _handle_paddle_hit(paddle_id : int) -> void:
	bounce_vertical()
	SignalBus.BallViewControllerSignal_hit_paddle.emit(paddle_id)
	PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							"Hit paddle id: " + str(paddle_id))

## Handles ball hitting a wall — bounces horizontally.							
func _handle_wall_hit() -> void:
	bounce_horizontal()
	SignalBus.BallViewControllerSignal_hit_wall.emit()
	PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							"Hit WALL ")
	
## Called by Godot when ball exits the screen.
## Detects exit direction and emits correct signal.
func _on_screen_exited() -> void:
	if not model.is_active:
		return
	if position.y < 0:
		PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							"BALL EXITED TOP ")
		SignalBus.BallViewControllerSignal_out_top.emit()
	else:
		PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							"BALL EXITED BOTTOM ")
		SignalBus.BallViewControllerSignal_out_bottom.emit()
	reset_ball()

	
	
	
