## =================================================
## CLASS: PaddleIAViewController
## DESCRIPTION: IA paddle controller.
## Follows the ball position with configurable difficulty.
## Extends PaddleBaseController — inherits all shared logic.
##
## Difficulty levels:
##   EASY   → ai_speed: 150 | dead_zone: 20px
##   MEDIUM → ai_speed: 280 | dead_zone: 10px
##   HARD   → ai_speed: 450 | dead_zone: 3px
##
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
class_name PaddleAIViewController
extends PaddleBaseController

const CLASS_NAME_LOG_CHILD = "PaddleAIViewController"

## Reference to the ball — injected by GameViewController
var ball : BallViewController = null

func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG_CHILD, 
							 PrintLogManager.LogType.INFO,
							" execute _ready()")
							
## Overrides _on_ready() hook — logs IA paddle initialization
func _on_ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG_CHILD, 
							 PrintLogManager.LogType.INFO,
							" execute _on_ready()")
							
## Overrides abstract method — follows ball position
## Uses dead_zone to avoid jittering
## [param delta] - frame time in seconds						
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
		
## Moves IA paddle using ai_speed instead of player speed
## [param direction] - movement direction: 1.0 or -1.0
## [param delta] - frame time in seconds
func _move_ai(direction: float, delta: float) -> void:
	var new_x: float = position.x + direction * model.ai_speed * delta
	position.x = clamp(new_x, model.limit_left, model.limit_right)
	
## Sets IA difficulty — updates model with correct speed and dead zone
## Called by GameViewController on level start
## [param diff] - AIDifficulty enum value
func set_difficulty(diff : PaddleModel.AIDifficulty) -> void:
	model.apply_difficulty_ai(diff)
	PrintLogManager.printlog(CLASS_NAME_LOG_CHILD, 
							 PrintLogManager.LogType.INFO,
							"dif set = " + str(diff))
							
## Injects ball reference — must be called before game starts
## [param ball_ref] - reference to BallViewController
func set_ball(ball_ref : BallViewController) -> void:
	ball = ball_ref
	PrintLogManager.printlog(CLASS_NAME_LOG_CHILD, 
							 PrintLogManager.LogType.INFO,
							"Ball ref = " + str(ball))
							

	
