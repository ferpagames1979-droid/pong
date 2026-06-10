class_name GameOverViewController
extends CanvasLayer

const CLASS_NAME_LOG = "GameOverViewController"

@onready var button_menu: Button = %ButtonMenu
@onready var button_retry: Button = %ButtonRetry

func _ready() -> void:
	button_menu.pressed.connect(_on_btn_menu_pressed)
	button_retry.pressed.connect(_on_btn_retry_pressed)
	
func _on_btn_menu_pressed() -> void:
	SceneManager.go_to_main_menu()
	
func _on_btn_retry_pressed() -> void:
	SceneManager.go_to_game()
