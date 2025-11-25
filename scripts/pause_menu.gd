extends CanvasLayer

var is_paused: bool = false

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # Funciona mesmo quando pausado

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	visible = is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		create_pause_menu()

func create_pause_menu() -> void:
	# Limpar menu anterior se existir
	for child in get_children():
		child.queue_free()
	
	# Container centralizado
	var center_container = CenterContainer.new()
	center_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(center_container)
	
	# Fundo semi-transparente
	var color_rect = ColorRect.new()
	color_rect.color = Color(0, 0, 0, 0.7)
	color_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	color_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(color_rect)
	color_rect.move_to_front()
	center_container.move_to_front()
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	center_container.add_child(vbox)
	
	# Título
	var title = Label.new()
	title.text = "Pause"
	title.add_theme_font_size_override("font_size", 36)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	# Espaçador
	var spacer = Control.new()
	spacer.custom_minimum_size.y = 20
	vbox.add_child(spacer)
	
	# Botão Continuar
	var continue_btn = Button.new()
	continue_btn.text = "Continuar"
	continue_btn.custom_minimum_size = Vector2(200, 50)
	continue_btn.pressed.connect(_on_continue_pressed)
	vbox.add_child(continue_btn)
	
	# Botão Menu Principal
	var menu_btn = Button.new()
	menu_btn.text = "Menu Principal"
	menu_btn.custom_minimum_size = Vector2(200, 50)
	menu_btn.pressed.connect(_on_main_menu_pressed)
	vbox.add_child(menu_btn)
	
	# Botão Sair
	var quit_btn = Button.new()
	quit_btn.text = "Sair do Jogo"
	quit_btn.custom_minimum_size = Vector2(200, 50)
	quit_btn.pressed.connect(_on_quit_pressed)
	vbox.add_child(quit_btn)

func _on_continue_pressed() -> void:
	toggle_pause()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
