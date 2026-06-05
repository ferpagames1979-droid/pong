## =================================================
## CLASS: GameViewController
## DESCRIPTION: Main game scene controller.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
extends Control

const CLASS_NAME_LOG = "GameView"

@onready var ball_view: BallViewController = %BallView
@onready var paddle_ai_view: PaddleAIViewController = %PaddleAIView
@onready var paddle_player_view: PaddlePlayerViewController = %PaddlePlayerView

	
func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							CLASS_NAME_LOG + " loaded")	
	_connect_signals()
	_setup_ai()
	ball_view.launch()
	
## Connects all SignalBus signals
func _connect_signals() -> void:
	SignalBus.BallViewControllerSignal_hit_paddle.connect(_on_ball_hit_paddle)
	SignalBus.BallViewControllerSignal_hit_wall.connect(_on_ball_hit_wall)
	SignalBus.BallViewControllerSignal_out_top.connect(_on_ball_out_top)
	SignalBus.BallViewControllerSignal_out_bottom.connect(_on_ball_out_bottom)
	
## Configures IA before game starts
## Injects ball reference and sets difficulty
func _setup_ai() -> void:
	paddle_ai_view.set_ball(ball_view)
	paddle_ai_view.set_difficulty(PaddleModel.AIDifficulty.EASY)
	PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							CLASS_NAME_LOG + " setup_ai executado")	
	
## Called when ball hits a paddle
## [param paddle_id] - 1 = player | 2 = IA						
func _on_ball_hit_paddle(paddle_id : int) -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							str(paddle_id))	
							
## Called when ball hits a wall	
func _on_ball_hit_wall() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							"HIT WALL")
							
## Called when ball exits top — player scores
func _on_ball_out_top() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							"OUT TOP - player score")
	_reset_round(PaddleBaseController.PLAYER_ID)
	
## Called when ball exits bottom — IA scores
func _on_ball_out_bottom() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							"OUT BOTTOM - IA score")
	_reset_round(PaddleBaseController.IA_ID)							

## Resets round after point — waits 1s then relaunches ball
## [param scorer_id] - 1 = player | 2 = IA							
func _reset_round(score_id : int) -> void:
	await get_tree().create_timer(1).timeout
	ball_view.launch()
	SignalBus.GameViewControllerSignal_round_reset.emit()
	PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							"Round Reset - scorer id: " + str(score_id))
	
	
	
