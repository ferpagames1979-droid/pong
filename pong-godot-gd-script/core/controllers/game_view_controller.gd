## =================================================
## CLASS: GameViewController
## DESCRIPTION: Main game scene controller.
## Orchestrates ball, paddles, score and level.
## Uses LevelManager for automatic difficulty progression.
##
## Flow:
##   _ready() → _connect_signals() → _setup_ai()
##            → _start_level()    → ball_view.launch()
##
##   game_over → await 2s → _start_next_level()
##             → _apply_config() → ball_view.launch()
##
## AUTHOR: Ferpa Games
## VERSION: 1.4.0
## =================================================
extends Control

const CLASS_NAME_LOG = "GameView"

@onready var ball_view: BallViewController = %BallView
@onready var paddle_ai_view: PaddleAIViewController = %PaddleAIView
@onready var paddle_player_view: PaddlePlayerViewController = %PaddlePlayerView
@onready var score_view: ScoreViewController = %ScoreView

## Controls if the game is active — false during game over
var _game_active: bool = false


func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG + " loaded")
	_connect_signals()
	_setup_ai()
	_start_level()


## Connects all SignalBus signals for this controller
func _connect_signals() -> void:
	SignalBus.BallViewControllerSignal_hit_paddle.connect(_on_ball_hit_paddle)
	SignalBus.BallViewControllerSignal_hit_wall.connect(_on_ball_hit_wall)
	SignalBus.BallViewControllerSignal_out_top.connect(_on_ball_out_top)
	SignalBus.BallViewControllerSignal_out_bottom.connect(_on_ball_out_bottom)
	SignalBus.GameViewControllerSignal_game_over.connect(_on_game_over)


## Injects ball reference into IA paddle.
## Difficulty is applied later via _apply_config()
func _setup_ai() -> void:
	paddle_ai_view.set_ball(ball_view)
	ball_view.set_paddles(paddle_player_view, paddle_ai_view) 
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG + " setup_ai executado")


## Starts current level — generates config, applies it,
## emits round_reset to clear HUD and launches ball.
func _start_level() -> void:
	var config: LevelConfigModel = LevelManager.generate_config(
		LevelManager.get_current_level())
	_apply_config(config)
	_game_active = true
	SignalBus.GameViewControllerSignal_round_reset.emit()
	ball_view.launch()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"_start_level() EXECUTED — level: " + str(LevelManager.get_current_level()))


## Applies level config to all game systems.
## Reads from config.ball_model, config.paddle_ia_model
## and config.score_model — no data duplication.
## [param config] - LevelConfigModel with level settings
func _apply_config(config: LevelConfigModel) -> void:
	ball_view.model.speed = config.ball_model.speed
	paddle_ai_view.model.ai_speed = config.paddle_ia_model.ai_speed
	paddle_ai_view.model.ai_dead_zone = config.paddle_ia_model.ai_dead_zone
	paddle_ai_view.model.ai_difficulty = config.paddle_ia_model.ai_difficulty
	score_view.set_points_to_win(config.score_model.points_to_win)
	score_view.reset_scores()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"_apply_config() EXECUTED" +
		" | ball_speed: " + str(config.ball_model.speed) +
		" | ia_speed: " + str(config.paddle_ia_model.ai_speed) +
		" | points_to_win: " + str(config.score_model.points_to_win))


## Advances to next level — gets new config from LevelManager,
## applies it, resets all systems and relaunches ball.
func _start_next_level() -> void:
	var config: LevelConfigModel = LevelManager.next_level()
	_apply_config(config)
	_game_active = true
	await get_tree().create_timer(1).timeout
	ball_view.launch()
	SignalBus.GameViewControllerSignal_round_reset.emit()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"_start_next_level() EXECUTED — level: " + str(LevelManager.get_current_level()))


## Called when ball hits a paddle via SignalBus.
## [param paddle_id] - 1 = player | 2 = IA
func _on_ball_hit_paddle(paddle_id: int) -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"HIT PADDLE - id: " + str(paddle_id))


## Called when ball hits a wall via SignalBus.
func _on_ball_hit_wall() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"HIT WALL")


## Called when ball exits top — player scores.
## Guard _game_active prevents scoring after game over.
func _on_ball_out_top() -> void:
	if not _game_active:
		return
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"OUT TOP - player score")
	score_view.register_point(PaddleBaseController.PLAYER_ID)
	_reset_round(PaddleBaseController.PLAYER_ID)


## Called when ball exits bottom — IA scores.
## Guard _game_active prevents scoring after game over.
func _on_ball_out_bottom() -> void:
	if not _game_active:
		return
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"OUT BOTTOM - IA score")
	score_view.register_point(PaddleBaseController.IA_ID)
	_reset_round(PaddleBaseController.IA_ID)


## Resets round after point — waits 1s then relaunches ball.
## Guard after await prevents relaunch if game over triggered.
## [param score_id] - 1 = player | 2 = IA
func _reset_round(score_id: int) -> void:
	await get_tree().create_timer(1).timeout
	if not _game_active:
		return
	ball_view.launch()
	SignalBus.GameViewControllerSignal_round_reset.emit()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Round Reset - scorer id: " + str(score_id))


## Called when game is over via SignalBus.
## Stops ball, waits 2s then starts next level automatically.
## [param winner_id] - 1 = player | 2 = IA
func _on_game_over(winner_id: int) -> void:
	_game_active = false
	ball_view.reset_ball()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"GAME OVER - WINNER = " + str(winner_id))
	await get_tree().create_timer(2).timeout
	_start_next_level()
