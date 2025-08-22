extends Node

# InventoryManager: Gerencia o inventário do jogador.
# Ele armazena itens, lida com a adição, remoção e uso de itens,
# e notifica outros sistemas sobre mudanças no inventário via GlobalEvents.

const MAX_INVENTORY_SLOTS = 16 # Exemplo: 16 slots de inventário

var inventory_slots: Array[Dictionary] = [] # Cada slot é um dicionário: {"item_id": "", "quantity": 0, "item_data": null}
var _is_inventory_ui_visible: bool = false

func _ready() -> void:
	_initialize_inventory()
	_connect_signals()

func _initialize_inventory() -> void:
	for i in range(MAX_INVENTORY_SLOTS):
		inventory_slots.append({"item_id": "", "quantity": 0, "item_data": null})

func _connect_signals() -> void:
	# Ouve requisições de dados para o SaveSystem
	GlobalEvents.request_inventory_data_for_save.connect(_on_request_inventory_data_for_save)

	# Ouve requisições de input para abrir/fechar inventário (se o InventoryManager gerenciar a UI do inventário)
	# GlobalEvents.input_inventory_pressed.connect(_on_input_inventory_pressed)

	# Ouve requisições de uso de item da UI ou de outros sistemas
	# GlobalEvents.request_use_item.connect(_on_request_use_item)

# ==============================================================================
# Funções Públicas de Gerenciamento de Inventário
# ==============================================================================

func add_item(item_resource_path: String, quantity: int = 1) -> bool:
	var item_data_resource = load(item_resource_path)
	if not item_data_resource or not item_data_resource is Resource:
		printerr("[InventoryManager] Falha ao carregar recurso de item: %s" % item_resource_path)
		return false

	# Tenta empilhar o item se ele já existir e for empilhável (lógica a ser expandida)
	for slot in inventory_slots:
		if slot.item_id == item_data_resource.id and item_data_resource.stackable:
			slot.quantity += quantity
			GlobalEvents.item_added.emit({"item_id": item_data_resource.id, "quantity": quantity})
			GlobalEvents.show_toast_requested.emit("TOAST_ITEM_COLLECTED_MESSAGE", "info", {"item_name": tr(item_data_resource.name_key)})
			return true

	# Tenta encontrar um slot vazio
	for i in range(MAX_INVENTORY_SLOTS):
		if inventory_slots[i].item_id.is_empty():
			inventory_slots[i].item_id = item_data_resource.id
			inventory_slots[i].quantity = quantity
			inventory_slots[i].item_data = item_data_resource # Armazena a referência ao recurso
			GlobalEvents.item_added.emit({"item_id": item_data_resource.id, "quantity": quantity, "slot_index": i})
			GlobalEvents.show_toast_requested.emit("TOAST_ITEM_COLLECTED_MESSAGE", "info", {"item_name": tr(item_data_resource.name_key)})
			return true

	print("[InventoryManager] Inventário cheio. Não foi possível adicionar %s" % item_data_resource.id)
	return false

func remove_item(item_id: String, quantity: int = 1) -> bool:
	for slot in inventory_slots:
		if slot.item_id == item_id:
			if slot.quantity >= quantity:
				slot.quantity -= quantity
				if slot.quantity == 0:
					slot.item_id = ""
					slot.item_data = null
				var current_slot_index = inventory_slots.find(slot)
				GlobalEvents.item_removed.emit({"item_id": item_id, "quantity": quantity, "slot_index": current_slot_index})
				return true
			else:
				printerr("[InventoryManager] Não há quantidade suficiente de %s para remover." % item_id)
				return false
	return false

func use_item_by_slot(slot_index: int) -> bool:
	if slot_index < 0 or slot_index >= MAX_INVENTORY_SLOTS:
		printerr("[InventoryManager] Slot de inventário inválido: %d" % slot_index)
		return false

	var slot = inventory_slots[slot_index]
	if slot.item_id.is_empty() or slot.item_data == null:
		print("[InventoryManager] Slot vazio. Nada para usar.")
		return false

	var item_data = slot.item_data

	# Lógica de uso baseada no tipo de item
	match item_data.item_type:
		"consumable":
			if item_data is HealingPotionData:
				# Exemplo: Emitir sinal para o PlayerState para curar
				# GlobalEvents.player_healed.emit(item_data.heal_amount)
				print("[InventoryManager] Usando Poção de Cura: %s" % tr(item_data.name_key))
				remove_item(item_data.id, 1)
				GlobalEvents.item_used.emit({"item_id": item_data.id, "slot_index": slot_index})
				GlobalEvents.show_toast_requested.emit("TOAST_ITEM_USED_MESSAGE", "info", {"item_name": tr(item_data.name_key)})
				return true
			elif item_data is DamageBoostPotionData:
				# Exemplo: Emitir sinal para o PlayerState ou CombatHandler para aplicar buff
				# GlobalEvents.player_damage_boost_applied.emit(item_data.boost_value, item_data.duration)
				print("[InventoryManager] Usando Poção de Aumento de Dano: %s" % tr(item_data.name_key))
				remove_item(item_data.id, 1)
				GlobalEvents.item_used.emit({"item_id": item_data.id, "slot_index": slot_index})
				GlobalEvents.show_toast_requested.emit("TOAST_ITEM_USED_MESSAGE", "info", {"item_name": tr(item_data.name_key)})
				return true
		"weapon":
			# Exemplo: Emitir sinal para o PlayerState para equipar arma
			# GlobalEvents.player_equip_weapon.emit(item_data.id)
			print("[InventoryManager] Equipando arma: %s" % tr(item_data.name_key))
			GlobalEvents.item_used.emit({"item_id": item_data.id, "slot_index": slot_index})
			GlobalEvents.show_toast_requested.emit("TOAST_ITEM_EQUIPPED_MESSAGE", "info", {"item_name": tr(item_data.name_key)})
			return true
		_:
			printerr("[InventoryManager] Tipo de item desconhecido ou sem lógica de uso: %s" % item_data.item_type)
			return false
	return false

func get_item_in_slot(slot_index: int) -> Dictionary:
	if slot_index < 0 or slot_index >= MAX_INVENTORY_SLOTS:
		printerr("[InventoryManager] Slot de inventário inválido: %d" % slot_index)
		return {}
	return inventory_slots[slot_index]

func get_all_items() -> Array[Dictionary]:
	return inventory_slots

# ==============================================================================
# Handlers de Sinais
# ==============================================================================

func _on_request_inventory_data_for_save() -> void:
	# Prepara os dados do inventário para o SaveSystem.
	# Apenas salva o ID do item e a quantidade, não a referência ao recurso completo.
	var save_data_array: Array = []
	for slot in inventory_slots:
		if not slot.item_id.is_empty():
			save_data_array.append({"item_id": slot.item_id, "quantity": slot.quantity})
	GlobalEvents.inventory_data_for_save_received.emit({"inventory_slots": save_data_array})


# Exemplo de como o InventoryManager reagiria a um item sendo coletado no mundo
# func _on_item_collected_in_world(item_resource_path: String, quantity: int) -> void:
# 	add_item(item_resource_path, quantity)



# Exemplo de como o InventoryManager reagiria a uma requisição de uso de item da UI
# func _on_request_use_item(slot_index: int) -> void:
# 	use_item_by_slot(slot_index)

func _on_input_action_triggered(action_data: Dictionary) -> void:
	if action_data.get("action") == "inventory" and action_data.get("state") == "pressed":
		_is_inventory_ui_visible = not _is_inventory_ui_visible
		if _is_inventory_ui_visible:
			GlobalEvents.show_ui_requested.emit({"ui_key": "inventory_menu", "context": "game_playing"})
		else:
			GlobalEvents.hide_ui_requested.emit({"ui_key": "inventory_menu"})
