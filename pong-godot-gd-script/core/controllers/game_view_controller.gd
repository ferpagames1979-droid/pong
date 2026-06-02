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
	_setup_ai()
	ball_view.launch()
	
## Configures IA before game starts
## Injects ball reference and sets difficulty
func _setup_ai() -> void:
	paddle_ai_view.set_ball(ball_view)
	paddle_ai_view.set_difficulty(PaddleModel.AIDifficulty.EASY)
	PrintLogManager.printlog(CLASS_NAME_LOG, 
							 PrintLogManager.LogType.INFO, 
							CLASS_NAME_LOG + " setup_ai executado")	

	
	
