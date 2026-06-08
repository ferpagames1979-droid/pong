## =================================================
## CLASS: HudScoreModel
## DESCRIPTION: Holds all HUD score display data.
## Stores player score, IA score, level and messages.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
class_name HudScoreModel
extends Resource

const CLASS_NAME_LOG: String = "HudScoreModel"

## Current player score for display
var player_score: int = 0

## Current IA score for display
var ia_score: int = 0

## Current level for display
var current_level: int = 1

## Current display message — empty means no message
var message: String = ""


## Updates player score
## [param score] - new player score value
func update_player_score(score: int) -> void:
	player_score = score


## Updates IA score
## [param score] - new IA score value
func update_ia_score(score: int) -> void:
	ia_score = score


## Updates current level number
## [param level] - new level value
func update_level(level: int) -> void:
	current_level = level


## Sets display message
## [param msg] - message to display on screen
func set_message(msg: String) -> void:
	message = msg


## Resets all display data to initial values
func reset() -> void:
	player_score = 0
	ia_score = 0
	message = ""
