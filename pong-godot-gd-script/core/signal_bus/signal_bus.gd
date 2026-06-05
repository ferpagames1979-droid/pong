## =================================================
## CLASS: SignalBus
## File: signal_bus.gd
## DESCRIPTION: Central signal bus — decouples all
## game systems. All signals follow the pattern:
## [ClassName]Signal_[Action]
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
extends Node

## SESSION SIGNALS - BallViewController
signal BallViewControllerSignal_hit_paddle(paddle_id : int)
signal BallViewControllerSignal_hit_wall
signal BallViewControllerSignal_out_top
signal BallViewControllerSignal_out_bottom

## SESSION SIGNALS - GameViewController
signal GameViewControllerSignal_game_started
signal GameViewControllerSignal_round_reset
signal GameViewControllerSignal_game_over(winner_id : int)

## SESSION SIGNALS - ScoreViewController
signal GameViewControllerSignal_point_scored(paddle_id : int, score : int)

## SESSION SIGNALS - LeveManager 
signal LevelManagerSignal_level_changed(new_level : int)
signal LevelManagerSignal_difficulty_changed(diff : int)
