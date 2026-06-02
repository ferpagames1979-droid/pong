## =================================================
## CLASS: PaddleModel
## DESCRIPTION: Holds all paddle data and state.
## Responsible for speed and boundary limits.
## Shared between PaddlePlayerController and PaddleIAController.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
class_name PaddleModel
extends Resource

const CLASS_NAME_LOG: String = "PaddleModel"

## Paddle movement speed in pixels per second
var speed: float = 400.0

## Left boundary limit in pixels
## Considers paddle half-width (120px / 2 = 60px)
var limit_left: float = 60.0

## Right boundary limit in pixels
## Considers paddle half-width (1152px - 60px = 1092px)
var limit_right: float = 1092.0

## IA SESSION
enum AIDifficulty { EASY, MEDIUM, HARD }

var ai_difficulty: AIDifficulty = AIDifficulty.EASY

var ai_speed : float = 150.0

var ai_dead_zone : float = 5.0

func apply_difficulty_ai(dif : AIDifficulty) -> void:
	ai_difficulty = dif
	match ai_difficulty:
		AIDifficulty.EASY:
			ai_speed = 150
			ai_dead_zone = 20
		AIDifficulty.MEDIUM:
			ai_speed = 280
			ai_dead_zone = 10
		AIDifficulty.HARD:
			ai_speed = 500
			ai_dead_zone = 3
## / finish IA SESSION


## Resets paddle speed to default value.
## Called by reset_paddle() in PaddleBaseController.
func reset() -> void:
	speed = 400.0
