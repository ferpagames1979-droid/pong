## =================================================
## CLASS: LevelManager
## DESCRIPTION: Manages game level progression.
## Generates LevelConfigModel reusing existing models.
## Autoload — persists across scenes.
##
## Progression formula:
##   ball_speed:    300 + (level-1)*30  — cap 700
##   points_to_win: 3 + floor((level-1)/2) — cap 11
##
## IA difficulty tiers:
##   EASY   (levels 1-3): ia_speed 150 | dead_zone 20
##   MEDIUM (levels 4-6): ia_speed 280 | dead_zone 10
##   HARD   (levels 7+):  ia_speed 500 | dead_zone 3
##
## AUTHOR: Ferpa Games
## VERSION: 1.1.0
## =================================================
extends Node

const CLASS_NAME_LOG = "LevelManager"

## Holds current level config — level_number lives here
## No separate current_level variable needed
var current_config: LevelConfigModel = LevelConfigModel.new()


func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG + " _ready()")


## Returns current level number from config.
## Avoids duplicating level state outside the model.
func get_current_level() -> int:
	return current_config.level_number


## Generates level config reusing BallModel, PaddleModel
## and ScoreModel — no data duplication.
## [param level] - level number to generate config for
func generate_config(level: int) -> LevelConfigModel:
	var config: LevelConfigModel = LevelConfigModel.new()
	config.level_number = level

	## Ball speed — stored in BallModel.speed — cap 700
	config.ball_model.speed = min(300.0 + (level - 1) * 30.0, 700.0)

	## Points to win — stored in ScoreModel.points_to_win — cap 11
	config.score_model.points_to_win = min(3 + int((level - 1) / 2), 11)

	## IA difficulty — apply_difficulty_ai() sets ai_speed
	## and ai_dead_zone internally in PaddleModel
	if level <= 3:
		config.paddle_ia_model.apply_difficulty_ai(PaddleModel.AIDifficulty.EASY)
	elif level <= 6:  ## ← BUG CORRIGIDO: era if, causava MEDIUM sobrescrever EASY
		config.paddle_ia_model.apply_difficulty_ai(PaddleModel.AIDifficulty.MEDIUM)
	else:
		config.paddle_ia_model.apply_difficulty_ai(PaddleModel.AIDifficulty.HARD)

	current_config = config

	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Config generated" +
		" | level: " + str(config.level_number) +
		" | ball_speed: " + str(config.ball_model.speed) +
		" | ia_speed: " + str(config.paddle_ia_model.ai_speed) +
		" | dead_zone: " + str(config.paddle_ia_model.ai_dead_zone) +
		" | points_to_win: " + str(config.score_model.points_to_win))

	return config


## Advances to next level — increments level_number,
## emits level_changed signal and generates new config.
func next_level() -> LevelConfigModel:
	var next: int = current_config.level_number + 1
	SignalBus.LevelManagerSignal_level_changed.emit(next)
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Next Level -> " + str(next) + " passed!")
	return generate_config(next)


## Resets level progression back to level 1.
## Called on new game start.
func reset() -> void:
	current_config = LevelConfigModel.new()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"LEVEL MANAGER IS RESET")
