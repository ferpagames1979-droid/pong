## =================================================
## CLASS: SaveManager
## DESCRIPTION: Manages local save data with AES encryption.
## Saves last completed level for Continue feature.
## Autoload — persists across scenes.
## AUTHOR: Ferpa Games
## VERSION: 1.0.0
## =================================================
extends Node

const CLASS_NAME_LOG = "SaveManager"
const SAVE_PATH: String = "user://pong_data.dat"
const MASTER_KEY: String = "FERPAGAMES_PONG_#Secure"
const SECTION_PONG: String = "pong"
const KEY_LEVEL: String = "last_level"

var _data_cache: Dictionary = {}

func _ready() -> void:
	_data_cache = _load_from_disk()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		CLASS_NAME_LOG + " _ready() — cache loaded")


## Saves the last completed level.
## Always saves current - 1 (the level the player completed).
## Minimum saved value is 1.
## [param current_level] - level the player just advanced FROM
func save_level(current_level: int) -> void:
	var completed: int = max(current_level, 1)
	_save_data(SECTION_PONG, KEY_LEVEL, completed)
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Level saved: " + str(completed))


## Returns last saved level.
## Returns 1 if no save exists.
func load_level() -> int:
	var level: int = _load_data(SECTION_PONG, KEY_LEVEL, 1)
	return max(level, 1)


## Returns true if a save file exists with a valid level.
## Used by MainMenu to show/hide Continue button.
func has_save() -> bool:
	var level: int = _load_data(SECTION_PONG, KEY_LEVEL, 0)
	return level > 1


## Clears all saved data — resets to level 1.
func clear_save() -> void:
	_data_cache = {}
	_save_to_disk()
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.INFO,
		"Save cleared")

func _save_data(section: String, key: String, value: Variant) -> void:
	if not _data_cache.has(section):
		_data_cache[section] = {}
	_data_cache[section][key] = value
	_save_to_disk()

func _load_data(section: String, key: String, default: Variant = null) -> Variant:
	if _data_cache.has(section) and _data_cache[section].has(key):
		return _data_cache[section][key]
	return default

func _save_to_disk() -> void:
	var file = FileAccess.open_encrypted_with_pass(
		SAVE_PATH, FileAccess.WRITE, MASTER_KEY)
	if file:
		file.store_var(_data_cache)
		file.close()
	else:
		PrintLogManager.printlog(CLASS_NAME_LOG,
			PrintLogManager.LogType.WARNING,
			"Failed to write save file")

func _load_from_disk() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file = FileAccess.open_encrypted_with_pass(
		SAVE_PATH, FileAccess.READ, MASTER_KEY)
	if file:
		var data = file.get_var()
		file.close()
		return data if data is Dictionary else {}
	PrintLogManager.printlog(CLASS_NAME_LOG,
		PrintLogManager.LogType.WARNING,
		"Failed to read save file")
	return {}
