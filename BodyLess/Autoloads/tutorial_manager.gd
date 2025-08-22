extends Node

@onready var coach_mark_scene: PackedScene = preload("res://Scenes/UI/Components/CoachMark.tscn")
var _current_coach_mark: Control = null
var _tutorial_steps: Array = []
var _current_step_index: int = -1

func _ready() -> void:
	GlobalEvents.start_tutorial_requested.connect(_on_start_tutorial_requested)
	GlobalEvents.coach_mark_next_requested.connect(_on_coach_mark_next_requested)
	GlobalEvents.coach_mark_skip_requested.connect(_on_coach_mark_skip_requested)

func _on_start_tutorial_requested(tutorial_data: Dictionary) -> void:
	var tutorial_name: String = tutorial_data.get("name", "")
	var start_step: int = tutorial_data.get("step", -1)
	# Carrega os passos do tutorial (ex: de um Resource ou JSON)
	# Por simplicidade, um exemplo hardcoded:
	_tutorial_steps = [
		{"text": "Bem-vindo ao jogo! Use WASD para se mover.", "show_skip": true},
		{"text": "Pressione P para pausar o jogo.", "show_skip": true},
		{"text": "Acesse as opções para personalizar sua experiência.", "show_skip": false}
	]
	_current_step_index = -1
	_show_next_coach_mark()

func _show_next_coach_mark() -> void:
	_current_step_index += 1
	if _current_step_index < _tutorial_steps.size():
		var step_data = _tutorial_steps[_current_step_index]
		if not _current_coach_mark:
			_current_coach_mark = coach_mark_scene.instantiate()
			get_tree().root.add_child(_current_coach_mark)
		
		_current_coach_mark.setup_coach_mark(step_data["text"], step_data["show_skip"])
	else:
		_end_tutorial()

func _on_coach_mark_next_requested() -> void:
	_show_next_coach_mark()

func _on_coach_mark_skip_requested() -> void:
	_end_tutorial()

func _end_tutorial() -> void:
	if _current_coach_mark:
		_current_coach_mark.hide_coach_mark()
		_current_coach_mark.queue_free()
		_current_coach_mark = null
	_tutorial_steps.clear()
	_current_step_index = -1
	GlobalEvents.emit_signal("tutorial_finished") # Sinal para notificar que o tutorial terminou
