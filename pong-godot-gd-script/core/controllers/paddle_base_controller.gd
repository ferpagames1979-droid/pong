## =================================================
## CLASS: PaddleBaseController
## DESCRIPTION: Abstract base class for all paddles.
## Contains all shared logic between Player and IA paddles.
## Subclasses MUST override _handle_movement().
## Subclasses CAN override _on_ready() for custom init logic.
##
## Inheritance:
##   PaddleBaseController
##     ├── PaddlePlayerViewController
##     └── PaddleIAController
##
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
class_name PaddleBaseController
extends StaticBody2D

const CLASS_NAME_LOG: String = "PaddleBaseController"

## Paddle ID constants — used across entire architecture
const PLAYER_ID : int = 1
const IA_ID : int = 2

## Shared data model — used by all paddle subclasses
var model: PaddleModel = PaddleModel.new()


## Initializes the paddle and calls the _on_ready() hook.
## Do NOT override this in subclasses — override _on_ready() instead.
func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG + " _ready()")
	_on_ready()


## Hook method — override in subclasses for custom initialization.
## Called automatically by _ready().
func _on_ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG + " _on_ready()")


## Called every frame.
## Delegates movement to _handle_movement() — do NOT override this.
func _process(delta: float) -> void:
	_handle_movement(delta)


## Abstract method — MUST be overridden by subclasses.
## Defines how each paddle moves:
##   PaddlePlayerViewController → reads keyboard input
##   PaddleIAController         → follows ball position
## [param delta] - frame time in seconds
func _handle_movement(delta: float) -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.WARNING,
		"Abstract method _handle_movement() must be overridden in: " + get_class())


## Moves the paddle horizontally with boundary check.
## Shared by all subclasses — call this inside _handle_movement().
## [param direction] - movement direction: 1.0 (right) or -1.0 (left)
## [param delta] - frame time in seconds
func _move(direction: float, delta: float) -> void:
	var new_x: float = position.x + direction * model.speed * delta
	position.x = clamp(new_x, model.limit_left, model.limit_right)


## Updates paddle movement speed.
## Called by LevelManager when the level increases.
## [param new_speed] - new speed value in pixels per second
func set_speed(new_speed: float) -> void:
	model.speed = new_speed
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Speed updated: " + str(new_speed))


## Resets paddle to a given horizontal center position.
## Called between rounds or when the game resets.
## [param center_x] - horizontal position to reset to
func reset_paddle(center_x: float) -> void:
	model.reset()
	position.x = center_x
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Paddle reset to x: " + str(center_x))
