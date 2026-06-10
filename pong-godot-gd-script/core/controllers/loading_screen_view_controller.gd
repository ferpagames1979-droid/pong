class_name LoadingScreenViewController
extends CanvasLayer

const CLASS_NAME_LOG = "LoadingScreenViewController"

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var label_status: Label = %LabelStatus

var _target_path: String = ""

var _progress: Array = []

func _ready() -> void:
	PrintLogManager.printlog(CLASS_NAME_LOG,
							PrintLogManager.LogType.INFO,
							" _ready()")
	set_process(false)
	
func start_loading(path:String) -> void:
	if path.is_empty():
		PrintLogManager.printlog(CLASS_NAME_LOG,
							PrintLogManager.LogType.INFO,
							"start_loading is empty")
		return
	
	_target_path = path
	label_status.text = "Loading"
	progress_bar.value = 5
	ResourceLoader.load_threaded_request(_target_path)
	set_process(true)
	PrintLogManager.printlog(CLASS_NAME_LOG,
							PrintLogManager.LogType.INFO,
							"Loading started > " + _target_path)
							
func _process(delta: float) -> void:
	if _target_path.is_empty():
		return
	var status = ResourceLoader.load_threaded_get_status(_target_path, _progress)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			label_status.text = "Loading..."
		ResourceLoader.THREAD_LOAD_LOADED:
			progress_bar.value = 100
			label_status.text = "Done!"
			set_process(false)
			_finalize_transition()
		ResourceLoader.THREAD_LOAD_FAILED:
			progress_bar.value = 0
			label_status.text = "Loading Failed!"
			set_process(false)
			PrintLogManager.printlog(CLASS_NAME_LOG,
							PrintLogManager.LogType.INFO,
							"Loading Failed > " + _target_path)
							
func _finalize_transition() -> void:
	var new_scene = ResourceLoader.load_threaded_get(_target_path)
	if new_scene == null:
		PrintLogManager.printlog(CLASS_NAME_LOG,
							PrintLogManager.LogType.INFO,
							"New Scene Is Null> " + str(new_scene))
		return
	
	get_tree().change_scene_to_packed(new_scene)
	
	await get_tree().process_frame
	queue_free()
	PrintLogManager.printlog(CLASS_NAME_LOG,
							PrintLogManager.LogType.INFO,
							"Transition Complete")
							

							
	
	
