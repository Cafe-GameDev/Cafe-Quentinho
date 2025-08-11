class_name VisualThemeData
extends Resource

@export var theme_name: String = "Default Theme"

@export_group("Temas de UI")
# Referência ao tema principal da Godot para os controles de UI.
@export var godot_ui_theme: Theme 

@export_group("Cores Globais")
@export_color_no_alpha var primary_color: Color = Color.WHITE
@export_color_no_alpha var secondary_color: Color = Color.LIGHT_GRAY
@export_color_no_alpha var text_color: Color = Color.BLACK

@export_group("Fontes")
@export var title_font: Font
@export var body_font: Font
@export var title_font_size: int = 24
@export var body_font_size: int = 16
