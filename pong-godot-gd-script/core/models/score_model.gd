## =================================================
## CLASS: ScoreModel
## DESCRIPTION: Holds all score data and state.
## Tracks player score, IA score and win condition.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
class_name ScoreModel
extends Resource

const CLASS_NAME_LOG: String = "ScoreModel"

## Points needed to win the current level
var points_to_win: int = 3

## Current player score
var player_score: int = 0

## Current IA score
var ia_score: int = 0


## Adds one point to the correct paddle based on ID
## [param scorer_id] - 1 = player | 2 = IA
func add_point(scorer_id: int) -> void:
	if scorer_id == PaddleBaseController.PLAYER_ID:
		player_score += 1
	elif scorer_id == PaddleBaseController.IA_ID:
		ia_score += 1


## Returns true if the given paddle has reached points_to_win
## [param scorer_id] - 1 = player | 2 = IA
func has_won(scorer_id: int) -> bool:
	if scorer_id == PaddleBaseController.PLAYER_ID:
		return player_score >= points_to_win
	elif scorer_id == PaddleBaseController.IA_ID:
		return ia_score >= points_to_win
	return false

## Returns the current score of the given paddle
## [param paddle_id] - 1 = player | 2 = IA
func get_score(paddle_id: int) -> int:
	if paddle_id == PaddleBaseController.PLAYER_ID:
		return player_score
	return ia_score


## Resets both scores to zero
func reset() -> void:
	player_score = 0
	ia_score = 0
