class_name MainMenuViewController
extends CanvasLayer

const CLASS_NAME_LOG = "MainMenuViewController"

@onready var button_play: Button = %ButtonPlay

func _ready() -> void:
	button_play.pressed.connect(_on_button_play_pressed)
	
func _on_button_play_pressed() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG, PrintLogManager.LogType.INFO, "START NEW GAME")
	SceneManager.go_to_game()
	
