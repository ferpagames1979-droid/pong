## =================================================
## CLASS: SceneManager
## DESCRIPTION: Manages all scene transitions.
## Uses LoadingScreen for smooth async loading.
## Centralizes navigation — no direct scene paths
## scattered across the codebase.
## Autoload — persists across scenes.
## AUTHOR: Ferpa Games
## VERSION: 1.1.0
## =================================================
extends Node

const CLASS_NAME_LOG = "SceneManager"

const LOADING_SCREEN = preload("res://views/loading_screen_view/loading_screen_view.tscn")

## Scene paths — all scenes already created
const SCENE_MAIN_MENU = "res://views/main_menu_view/main_menu_view.tscn"
const SCENE_GAME      = "res://views/game_view/game_view.tscn"
const SCENE_GAME_OVER = "res://views/game_over_view/game_over_view.tscn"

## Stores winner ID between game and game over scenes
var last_winner_id: int = 0


func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG + " _ready()")


## Loads the main menu scene.
## Resets LevelManager before loading.
func go_to_main_menu() -> void:
	LevelManager.reset()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Going to MainMenu")
	_change_scene(SCENE_MAIN_MENU)


## Loads the game scene — starts a new game.
func go_to_game() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Going to Game")
	_change_scene(SCENE_GAME)


## Stores winner_id and loads game over scene.
## GameOverViewController reads last_winner_id on _ready().
## [param winner_id] - 1 = player | 2 = IA
func go_to_game_over(winner_id: int) -> void:
	last_winner_id = winner_id
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Going to GameOver — winner: " + str(winner_id))
	_change_scene(SCENE_GAME_OVER)


## Internal — validates path and starts loading screen.
## Uses call_deferred to avoid mid-frame scene changes.
## [param path] - full res:// path to target scene
func _change_scene(path: String) -> void:
	if not ResourceLoader.exists(path):
		PrintLogManager.printlog(CLASS_NAME_LOG,
			PrintLogManager.LogType.WARNING,
			"Scene not found: " + path)
		return
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Loading: " + path)
	call_deferred("_deferred_change_scene", path)



## Deferred — instantiates LoadingScreen and starts async load.
## [param path] - full res:// path to target scene
func _deferred_change_scene(path: String) -> void:
	var loader = LOADING_SCREEN.instantiate()
	get_tree().root.add_child(loader)
	if loader.has_method("start_loading"):
		loader.start_loading(path)
		
func change_packed_scene(scene:PackedScene) -> void:	
	if scene:
		call_deferred("_deferred_packed_scene", scene)
		
func _deferred_packed_scene(scene:PackedScene) -> void:
	if scene:
		get_tree().change_scene_to_packed(scene)
