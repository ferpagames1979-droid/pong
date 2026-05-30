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

## Resets paddle speed to default value.
## Called by reset_paddle() in PaddleBaseController.
func reset() -> void:
	speed = 400.0
