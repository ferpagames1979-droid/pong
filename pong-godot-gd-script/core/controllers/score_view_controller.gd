## =================================================
## CLASS: ScoreViewController
## DESCRIPTION: Controls score tracking and win condition.
## Listens to SignalBus events and updates ScoreModel.
## Emits signals when score changes or game is over.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
class_name ScoreViewController
extends Node

const CLASS_NAME_LOG: String = "ScoreViewController"

## Score data model
var model: ScoreModel = ScoreModel.new()


func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG + " _ready()")
	_connect_signals()


## Connects to SignalBus signals
func _connect_signals() -> void:
	SignalBus.GameViewControllerSignal_round_reset.connect(_on_round_reset)


## Main scoring method — called by GameViewController
## Adds point, emits score signal, checks win condition
## [param scorer_id] - 1 = player | 2 = IA
func register_point(scorer_id: int) -> void:
	model.add_point(scorer_id)

	var current_score: int = model.get_score(scorer_id)

	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Point scored — id: " + str(scorer_id) +
		" | score: " + str(current_score))

	SignalBus.ScoreViewControllerSignal_point_scored.emit(
		scorer_id, current_score)

	if model.has_won(scorer_id):
		_handle_game_over(scorer_id)


## Handles game over — emits game_over signal
## [param winner_id] - 1 = player | 2 = IA
func _handle_game_over(winner_id: int) -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Game over — winner id: " + str(winner_id))
	SignalBus.GameViewControllerSignal_game_over.emit(winner_id)


## Resets scores — called on round reset
func _on_round_reset() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Round reset received")


## Returns current player score
func get_player_score() -> int:
	return model.player_score


## Returns current IA score
func get_ia_score() -> int:
	return model.ia_score


## Updates points needed to win — called by LevelManager
## [param points] - new points to win value
func set_points_to_win(points: int) -> void:
	model.points_to_win = points
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Points to win updated: " + str(points))


## Resets all scores — called on new game or level up
func reset_scores() -> void:
	model.reset()
	SignalBus.ScoreViewControllerSignal_point_scored.emit(
		PaddleBaseController.PLAYER_ID, 0)
	SignalBus.ScoreViewControllerSignal_point_scored.emit(
		PaddleBaseController.IA_ID, 0)
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"reset_scores() EXECUTED")
