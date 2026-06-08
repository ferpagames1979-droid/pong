## =================================================
## CLASS: HudScoreViewController
## DESCRIPTION: Controls HUD score display and updates.
## Listens to SignalBus events and updates visual Labels.
## Completely decoupled — no direct references needed.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
class_name HudScoreViewController
extends CanvasLayer

const CLASS_NAME_LOG: String = "HudScoreViewController"

## HUD score data model
var model: HudScoreModel = HudScoreModel.new()

## Label references via Unique Name
@onready var label_player_score: Label = %LabelPlayerScore
@onready var label_ia_score: Label = %LabelIAScore
@onready var label_level: Label = %LabelLevel
@onready var label_message: Label = %LabelMessage


func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG + " _ready()")
	_connect_signals()
	_update_display()


## Connects all SignalBus signals
func _connect_signals() -> void:
	SignalBus.ScoreViewControllerSignal_point_scored.connect(_on_point_scored)
	SignalBus.GameViewControllerSignal_game_over.connect(_on_game_over)
	SignalBus.GameViewControllerSignal_round_reset.connect(_on_round_reset)
	SignalBus.LevelManagerSignal_level_changed.connect(_on_level_changed)


## Updates all Labels from model data
func _update_display() -> void:
	label_player_score.text = str(model.player_score)
	label_ia_score.text = str(model.ia_score)
	label_level.text = str(model.current_level)
	label_message.text = model.message


## Called when a point is scored — updates score labels
## [param player_id] - 1 = player | 2 = IA
## [param score] - current score of that player
func _on_point_scored(player_id: int, score: int) -> void:
	if player_id == PaddleBaseController.PLAYER_ID:
		model.update_player_score(score)
	else:
		model.update_ia_score(score)
	_update_display()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Score updated — id: " + str(player_id) +
		" | score: " + str(score))


## Called when game is over — displays winner message
## [param winner_id] - 1 = player | 2 = IA
func _on_game_over(winner_id: int) -> void:
	if winner_id == PaddleBaseController.PLAYER_ID:
		model.set_message("PLAYER WINS!")
	else:
		model.set_message("IA WINS!")
	_update_display()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Game over displayed — winner: " + str(winner_id))

## Called when round resets — clears message
func _on_round_reset() -> void:
	model.set_message("")
	_update_display()


## Called when level changes — updates level label
## [param new_level] - new level number
func _on_level_changed(new_level: int) -> void:
	model.update_level(new_level)
	_update_display()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Level updated: " + str(new_level))


## Resets HUD to initial display state
func reset_hud() -> void:
	model.reset()
	_update_display()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"HUD reset")
