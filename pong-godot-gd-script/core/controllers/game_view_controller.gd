## =================================================
## CLASS: GameViewController
## DESCRIPTION: Main game scene controller.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
extends Control

const CLASS_NAME_LOG = "GameView"

@onready var ball_view: BallViewController = %BallView

	
func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG, PrintLogManager.LogType.INFO, CLASS_NAME_LOG + " loaded")
	ball_view.launch()
	

	
	
