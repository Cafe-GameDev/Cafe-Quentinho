extends VBoxContainer

@onready var reset_button: Button = $ResetButton
@onready var input_actions_container: VBoxContainer = $ScrollContainer/InputActionsContainer

func _ready() -> void:
	reset_button.pressed.connect(_on_reset_button_pressed)
	GlobalEvents.loading_input_map_changed.connect(_on_loading_input_map_changed)
	GlobalEvents.request_loading_input_map_changed.emit() # Request initial input map settings

func _on_reset_button_pressed() -> void:
	GlobalEvents.request_reset_input_map_changed.emit()

func _on_loading_input_map_changed(input_map_data: Dictionary) -> void:
	# TODO: Implement logic to populate the UI with input_map_data
	print("InputMapSettings: Received input map data: ", input_map_data)