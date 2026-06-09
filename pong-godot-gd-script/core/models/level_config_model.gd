## =================================================
## CLASS: LevelConfigModel
## DESCRIPTION: Holds configuration data for each level.
## Reuses existing models — no data duplication.
##
## OOP reuse principle:
##   ball_model.speed          → BallModel
##   paddle_ia_model.ai_speed,
##   paddle_ia_model.ai_dead_zone,
##   paddle_ia_model.ai_difficulty → PaddleModel
##   score_model.points_to_win → ScoreModel
##
## Generated automatically by LevelManager.generate_config()
## AUTHOR: Ferpa Games
## VERSION: 1.1.0
## =================================================
class_name LevelConfigModel
extends Resource

const CLASS_NAME_LOG = "LevelConfigModel"

## Current level number — single source of truth for level state
var level_number: int = 1

## Reuses BallModel — speed already defined there
var ball_model: BallModel = BallModel.new()

## Reuses PaddleModel — ai_speed, ai_dead_zone and
## ai_difficulty set via apply_difficulty_ai()
var paddle_ia_model: PaddleModel = PaddleModel.new()

## Reuses ScoreModel — points_to_win already defined there
var score_model: ScoreModel = ScoreModel.new()
