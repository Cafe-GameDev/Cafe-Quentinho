extends VBoxContainer

# Este script gerencia a seção de opções de idioma.
# Ele conecta os sinais dos botões de idioma e atualiza o estado visual
# para indicar qual idioma está selecionado.

const LOCALE_NAMES: Dictionary = {
	"en_US": "English (US)",
	"en_GB": "English (UK)",
	"en_IN": "English (India)",
	"pt_BR": "Português (Brasil)",
	"pt_PT": "Português (Portugal)",
	"es_ES": "Español (España)",
	"es_LA": "Español (Latinoamérica)",
	"fr": "Français",
	"de": "Deutsch",
	"it": "Italiano",
	"nl": "Nederlands",
	"ja": "日本語",
	"ko": "한국어",
	"ru": "Русский",
	"zh_Hans": "简体中文",
	"zh_Hant": "繁體中文",
	"sw": "Kiswahili",
	"af": "Afrikaans",
	"pl": "Polski",
	"tr": "Türkçe",
	"ar": "العربية",
	"fa": "فارسی",
	"he": "עברית",
	"hi": "हिन्दी",
	"ur": "اردو",
	"bn": "বাংলা",
	"id": "Bahasa Indonesia",
	"vi": "Tiếng Việt",
	"fil": "Filipino",
	"th": "ไทย",
	"ms": "Bahasa Melayu"
}

func _ready() -> void:
	_populate_language_options()
	GlobalEvents.loading_language_changed.connect(_on_language_data_received)
	GlobalEvents.language_changed.connect(_on_language_data_received)


func _populate_language_options() -> void:
	# Limpa os botões existentes, se houver.
	for child in get_children():
		child.queue_free()

	# Cria os botões dinamicamente para cada idioma.
	var sorted_locale_codes = LOCALE_NAMES.keys()
	sorted_locale_codes.sort()
	for locale_code in sorted_locale_codes:
		var button = Button.new()
		button.text = tr("UI_LANGUAGE_" + locale_code.to_upper()) # Usa chave de tradução
		button.set_meta("locale", locale_code)
		button.pressed.connect(_on_language_button_pressed.bind(locale_code))
		add_child(button)


func _on_language_button_pressed(locale_code: String) -> void:
	var change_data = {"language": {"locale": locale_code}}
	GlobalEvents.language_changed.emit(change_data)


func _on_language_data_received(language_data: Dictionary) -> void:
	if not language_data.has("language") or not language_data.language.has("locale"):
		return

	var new_locale = language_data.language.locale
	
	# Atualiza o estado visual dos botões para refletir a seleção atual.
	for button in get_children():
		if button is Button:
			var button_locale = button.get_meta("locale", "")
			if not button_locale.is_empty():
				button.disabled = (button_locale == new_locale)
				# Atualiza o texto do botão para o idioma selecionado (se aplicável)
				button.text = tr("UI_LANGUAGE_" + button_locale.to_upper())
