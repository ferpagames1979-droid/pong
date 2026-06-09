## =================================================
## CLASS: SoundManager
## DESCRIPTION: Manages all audio for the game.
## Handles background music and SFX.
## Listens to SignalBus and plays sounds automatically.
## Autoload — persists across scenes.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
extends Node

const CLASS_NAME_LOG = "SoundManager"

## Audio toggle controls
var music_enabled: bool = true
var sfx_enabled: bool = true

## SFX paths
var sfx = {
	"hit_paddle"  : "res://assets/audio/sfx/paddle_hit.mp3",
	"hit_wall"    : "res://assets/audio/sfx/hit_wall.mp3",
	"point"       : "res://assets/audio/sfx/point.mp3",
	"game_over"   : "res://assets/audio/sfx/gameover.mp3",
	"level_up"    : "res://assets/audio/sfx/level_up.mp3",
}

## Music path
const MUSIC_MAIN = "res://assets/audio/music/main_theme.ogg"


@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)
	_connect_signals()
	play_music()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG + " _ready()")


## Connects all SignalBus signals to play sounds automatically
func _connect_signals() -> void:
	SignalBus.BallViewControllerSignal_hit_paddle.connect(
		func(_id): play_sfx("hit_paddle"))
	SignalBus.BallViewControllerSignal_hit_wall.connect(
		func(): play_sfx("hit_wall"))
	SignalBus.ScoreViewControllerSignal_point_scored.connect(
		func(_id, _score): play_sfx("point"))
	SignalBus.GameViewControllerSignal_game_over.connect(
		func(_id): play_sfx("game_over"))
	SignalBus.LevelManagerSignal_level_changed.connect(
		func(_level): play_sfx("level_up"))


## Plays background music — loops automatically
func play_music() -> void:
	if not music_enabled:
		return
	if music_player.playing:
		return
	music_player.stream = load(MUSIC_MAIN)
	music_player.volume_db = -15.0
	music_player.play()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Music playing")


## Stops background music
func stop_music() -> void:
	music_player.stop()


## Plays a SFX by name — creates a temporary AudioStreamPlayer
## and frees it automatically when finished.
## [param name] - key from sfx dictionary
func play_sfx(name: String) -> void:
	if not sfx_enabled:
		return
	if not sfx.has(name):
		PrintLogManager.printlog(CLASS_NAME_LOG,
			PrintLogManager.LogType.WARNING,
			"SFX not found: " + name)
		return
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(player)
	player.stream = load(sfx[name])
	player.volume_db = -5.0
	player.play()
	player.finished.connect(player.queue_free)


## Enables or disables music
## [param enabled] - true to enable | false to disable
func set_music_enabled(enabled: bool) -> void:
	music_enabled = enabled
	if not music_enabled:
		stop_music()
	else:
		play_music()


## Enables or disables SFX
## [param enabled] - true to enable | false to disable
func set_sfx_enabled(enabled: bool) -> void:
	sfx_enabled = enabled
