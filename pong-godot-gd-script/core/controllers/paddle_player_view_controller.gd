## =================================================
## CLASS: PaddlePlayerViewController
## DESCRIPTION: Player paddle controller.
## Reads keyboard input and moves the paddle.
## Extends PaddleBaseController — inherits all shared logic.
##
## Input Map required:
##   paddle_right → Arrow Right + D
##   paddle_left  → Arrow Left  + A
##
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
class_name PaddlePlayerViewController
extends PaddleBaseController

const CLASS_NAME_LOG_CHILD: String = "PaddlePlayerViewController"


## Overrides _on_ready() hook — logs player paddle initialization.
func _on_ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG_CHILD,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG_CHILD + " _on_ready()")


## Overrides abstract method — reads keyboard input to move paddle.
## Uses Input Map actions: paddle_right and paddle_left.
## Calls _move() from PaddleBaseController to apply movement.
## [param delta] - frame time in seconds
func _handle_movement(delta: float) -> void:
	var direction: float = 0.0

	if Input.is_action_pressed("paddle_right"):
		direction = 1.0
	if Input.is_action_pressed("paddle_left"):
		direction = -1.0

	if direction == 0.0:
		return

	_move(direction, delta)
