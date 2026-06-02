class_name PaddleAIViewController
extends PaddleBaseController

const CLASS_NAME_LOG_CHILD = "PaddleAIViewController"

var ball : BallViewController = null

func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG_CHILD, 
							 PrintLogManager.LogType.INFO,
							" execute _ready()")
							
func _on_ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG_CHILD, 
							 PrintLogManager.LogType.INFO,
							" execute _on_ready()")
							
func _handle_movement(delta: float) -> void:
	if ball == null:
		PrintLogManager.printlog(CLASS_NAME_LOG_CHILD, 
							 PrintLogManager.LogType.INFO,
							" ball == null")
		return
	var distance: float = ball.position.x - position.x
	if abs(distance) < model.ai_dead_zone:
		return
	var direction : float = sign(distance)
	_move_ai(direction, delta)
		
	
func _move_ai(direction: float, delta: float) -> void:
	var new_x: float = position.x + direction * model.speed * delta
	position.x = clamp(new_x, model.limit_left, model.limit_right)
	
	
func set_difficulty(dif : PaddleModel.AIDifficulty) -> void:
	model.apply_difficulty_ai(dif)
	PrintLogManager.printlog(CLASS_NAME_LOG_CHILD, 
							 PrintLogManager.LogType.INFO,
							"dif set = " + str(dif))
							
	
func set_ball(ball_ref : BallViewController) -> void:
	ball = ball_ref
	PrintLogManager.printlog(CLASS_NAME_LOG_CHILD, 
							 PrintLogManager.LogType.INFO,
							"Ball ref = " + str(ball))
	
