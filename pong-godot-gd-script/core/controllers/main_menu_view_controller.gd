class_name MainMenuViewController
extends CanvasLayer

const CLASS_NAME_LOG = "MainMenuViewController"

@onready var button_play: Button = %ButtonPlay
@onready var button_continue: Button = %ButtonContinue


func _ready() -> void:
	button_play.pressed.connect(_on_button_play_pressed)
	button_continue.pressed.connect(_on_button_continue_pressed)
	button_continue.visible = SaveManager.has_save()
	
func _on_button_play_pressed() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG, PrintLogManager.LogType.INFO, "START NEW GAME")
	LevelManager.reset()
	SceneManager.go_to_game()
	
func _on_button_continue_pressed() -> void:
	var saved_level: int = SaveManager.load_level()
	LevelManager.current_config.level_number = saved_level
	SceneManager.go_to_game()
	
