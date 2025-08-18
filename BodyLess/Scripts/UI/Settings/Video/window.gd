extends HBoxContainer

@onready var option_button: OptionButton = $WindowModeOptionButton

func _ready() -> void:
	GlobalEvents.video_window_mode_changed.connect(_on_video_window_mode_changed)
	# Popula com os modos de janela
	option_button.add_item("Janela", DisplayServer.WINDOW_MODE_WINDOWED)
	option_button.add_item("Tela Cheia", DisplayServer.WINDOW_MODE_FULLSCREEN)
	option_button.add_item("Janela sem Bordas", DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_window_mode_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("video_window_mode_changed", option_button.get_item_id(index))

func _on_video_window_mode_changed(mode: int) -> void:
	for i in range(option_button.item_count):
		if option_button.get_item_id(i) == mode:
			if option_button.selected != i:
				option_button.select(i)
			return
