extends CanvasLayer

@onready var book_ui: CanvasLayer = $"../BookUI"
var is_open: bool = false
@onready var panel: Control = $Panel
@onready var upgrades: Array = [
	$Panel/VBoxContainer/HBoxContainer/upgrade1,
	$Panel/VBoxContainer/HBoxContainer/upgrade2,
	$Panel/VBoxContainer/HBoxContainer/upgrade3,
	$Panel/VBoxContainer/HBoxContainer2/upgrade4,
	$Panel/VBoxContainer/HBoxContainer2/upgrade5
]

const UPGRADE_COSTS := [150, 300, 500, 1000, 1500]

func _ready() -> void:
	panel.hide()
	apply_upgrades_up_to(Constants.upgrade_level)
	_refresh_button_states()
	SaveManager.data_changed.connect(func(): pass)

func _on_load_completed() -> void:
	apply_upgrades_up_to(Constants.upgrade_level)
	_refresh_button_states()

func _refresh_button_states() -> void:
	for i in upgrades.size():
		upgrades[i].disabled = i < Constants.upgrade_level

func _apply_single_upgrade_effect(index: int) -> void:
	match index:
		0:
			Constants.Player = preload("uid://bxiwlh6l3ma52")
			Constants.max_depth = 1000
		1:
			Constants.Player = preload("uid://cgqmbw5xpsjpo")
			Constants.speed2 = 150
		2:
			Constants.Player = preload("uid://bmight8rjj0q7")
			Constants.max_depth = 2500
		3:
			Constants.Player = preload("uid://c1t86p3yuu081")
			Constants.max_depth = 8000
		4:
			Constants.Player = preload("uid://cb5joivb6o104")
			Constants.speed2 = 200

func apply_upgrades_up_to(level: int) -> void:
	for i in level:
		_apply_single_upgrade_effect(i)

func _try_buy_upgrade(index: int) -> void:
	if index != Constants.upgrade_level:
		return # out-of-order or already bought — button state should prevent this anyway
	var cost = UPGRADE_COSTS[index]
	if Constants.money < cost:
		ToastManager.show_toast("Not Enough Money")
		return
	Constants.money -= cost
	_apply_single_upgrade_effect(index)
	Constants.upgrade_level = index + 1
	_refresh_button_states()
	SaveManager.mark_dirty()

func _on_upgrade_1_pressed() -> void: _try_buy_upgrade(0)
func _on_upgrade_2_pressed() -> void: _try_buy_upgrade(1)
func _on_upgrade_3_pressed() -> void: _try_buy_upgrade(2)
func _on_upgrade_4_pressed() -> void: _try_buy_upgrade(3)
func _on_upgrade_5_pressed() -> void: _try_buy_upgrade(4)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("upgrade_panel"):
		if is_open:
			close_menu()
		else:
			open_menu()
	if OS.is_debug_build() and event.is_action_pressed("debug_all_upgrades"):
		_debug_unlock_all_fish()
	if OS.is_debug_build() and event.is_action_pressed("debug_max_speed"):
		_debug_max_speed()

func toggle_panel():
	is_open = !is_open
	panel.visible = is_open

func _debug_unlock_all_fish():
	pass

func _debug_max_speed():
	DebugScript.show_debug("Maxed Out Speed")
	Constants.speed2 = 4000

func open_menu() -> void:
	if MenuManager.is_any_menu_open:
		return
	panel.show()
	is_open = true
	MenuManager.register_menu_open()

func close_menu() -> void:
	panel.hide()
	is_open = false
	MenuManager.register_menu_close()
