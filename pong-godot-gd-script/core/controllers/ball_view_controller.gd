## =================================================
## CLASS: BallViewController
## DESCRIPTION: Controls ball movement and behavior.
## Detects collisions via body_entered.
## Detects screen exit via VisibleOnScreenNotifier2D.
## Emits all events through SignalBus.
## Calculates bounce angle based on paddle hit offset.
## AUTHOR: Ferpa Games
## VERSION: 1.1.0
## =================================================
class_name BallViewController
extends Area2D

const CLASS_NAME_LOG = "BallViewController"

## Half width used for offset normalization
## Calibrated to real collision area — not full paddle width
const PADDLE_HALF_WIDTH: float = 20.0

## Max bounce angle in degrees — applied on paddle hit offset
const MAX_BOUNCE_ANGLE: float = 75.0

var model: BallModel = BallModel.new()

## Reference to screen exit notifier
@onready var screen_notifier: VisibleOnScreenEnabler2D = %VisibleOnScreenEnabler2D

## Paddle references — injected by GameViewController
## Required for offset-based bounce angle calculation
var paddle_player: PaddlePlayerViewController = null
var paddle_ia: PaddleAIViewController = null


func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO, "_ready()")
	body_entered.connect(_on_body_entered)
	screen_notifier.screen_exited.connect(_on_screen_exited)


## Called every frame — moves the ball based on model data
func _process(delta: float) -> void:
	if not model.is_active:
		return
	position += model.direction * model.speed * delta


## Injects paddle references — called by GameViewController.
## Required for offset-based bounce angle calculation.
## [param player] - PaddlePlayerViewController reference
## [param ia]     - PaddleAIViewController reference
func set_paddles(player: PaddlePlayerViewController,
				 ia: PaddleAIViewController) -> void:
	paddle_player = player
	paddle_ia = ia
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Paddles reference set")


## Returns the correct paddle based on ID.
## [param paddle_id] - 1 = player | 2 = IA
func _get_paddle(paddle_id: int) -> PaddleBaseController:
	if paddle_id == PaddleBaseController.PLAYER_ID:
		return paddle_player
	return paddle_ia


## Reverses the ball horizontal direction — called on wall hit
func bounce_horizontal() -> void:
	model.direction.x *= -1


## Calculates bounce direction based on where ball hit the paddle.
## Left side  → ball goes left
## Center     → ball goes straight
## Right side → ball goes right
## Uses real CollisionShape2D size when available.
## [param paddle_id] - 1 = player | 2 = IA
func _calculate_bounce(paddle_id: int) -> void:
	var paddle: PaddleBaseController = _get_paddle(paddle_id)
	if paddle == null:
		model.direction.y *= -1
		return

	## Offset between ball center and paddle center
	var offset: float = global_position.x - paddle.global_position.x

	## Use real CollisionShape2D size when available
	var shape = paddle.get_node("CollisionShape2D")
	var half_width: float = PADDLE_HALF_WIDTH
	if shape and shape.shape is RectangleShape2D:
		half_width = shape.shape.size.x / 2.0

	## Normalize offset and calculate angle
	var normalized: float = clamp(offset / half_width, -1.0, 1.0)
	var angle: float = normalized * MAX_BOUNCE_ANGLE

	## Preserve vertical direction — always bounce away from paddle
	var direction_y: float = -sign(model.direction.y)

	model.direction = Vector2(
		sin(deg_to_rad(angle)),
		direction_y
	).normalized()

	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Bounce" +
		" | offset: " + str(offset) +
		" | normalized: " + str(normalized) +
		" | angle: " + str(angle) +
		" | direction: " + str(model.direction))


## Launches the ball in a random direction
func launch() -> void:
	model.is_active = true
	model.direction = _get_random_direction()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Ball launched: " + str(model.direction))


## Resets ball to initial position and stops movement
func reset_ball() -> void:
	model.reset()
	position = model.initial_position
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Ball reset")


## Returns a random normalized launch direction
func _get_random_direction() -> Vector2:
	var angle: float = randf_range(-45.0, 45.0)
	var direction: Vector2 = Vector2(0, 1)
	return direction.rotated(deg_to_rad(angle)).normalized()


## Called when Area2D detects StaticBody2D collision.
## Identifies what was hit and delegates to handler.
## [param body] - the StaticBody2D that was hit
func _on_body_entered(body: Node) -> void:
	if body is PaddlePlayerViewController:
		_handle_paddle_hit(PaddleBaseController.PLAYER_ID)
	elif body is PaddleAIViewController:
		_handle_paddle_hit(PaddleBaseController.IA_ID)
	elif body.is_in_group("walls"):
		_handle_wall_hit()


## Handles ball hitting a paddle.
## Uses offset-based angle calculation via _calculate_bounce().
## [param paddle_id] - 1 = player | 2 = IA
func _handle_paddle_hit(paddle_id: int) -> void:
	_calculate_bounce(paddle_id)
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
		"Hit WALL")


## Called by Godot when ball exits the screen.
## Detects exit direction and emits correct signal.
func _on_screen_exited() -> void:
	if not model.is_active:
		return
	if position.y < 0:
		PrintLogManager.printlog(CLASS_NAME_LOG,
			PrintLogManager.LogType.INFO,
			"BALL EXITED TOP")
		SignalBus.BallViewControllerSignal_out_top.emit()
	else:
		PrintLogManager.printlog(CLASS_NAME_LOG,
			PrintLogManager.LogType.INFO,
			"BALL EXITED BOTTOM")
		SignalBus.BallViewControllerSignal_out_bottom.emit()
	reset_ball()
