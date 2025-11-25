extends Control

# Referências
var config_panel: PanelContainer
var main_menu_panel: VBoxContainer
var is_config_open: bool = false

# Configurações do mapa
var map_settings: Dictionary = {
	"map_width": 100,
	"map_height": 100,
	"use_seed": false,
	"seed_value": 0,
	"noise_scale": 0.02,
	"noise_octaves": 4,
	"noise_persistence": 0.5,
	"water_threshold": -0.3,
	"sand_threshold": -0.1,
	"grass_threshold": 0.3,
	"forest_threshold": 0.5,
	"mountain_threshold": 0.7
}

func _ready() -> void:
	create_main_menu()
	create_config_menu()

func create_main_menu() -> void:
	# Container centralizado
	var center_container = CenterContainer.new()
	center_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(center_container)
	
	main_menu_panel = VBoxContainer.new()
	main_menu_panel.add_theme_constant_override("separation", 15)
	center_container.add_child(main_menu_panel)
	
	# Título
	var title = Label.new()
	title.text = "Super Wars"
	title.add_theme_font_size_override("font_size", 48)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_menu_panel.add_child(title)
	
	# Espaçador
	var spacer = Control.new()
	spacer.custom_minimum_size.y = 30
	main_menu_panel.add_child(spacer)
	
	# Botão Novo Jogo
	var new_game_btn = Button.new()
	new_game_btn.text = "Novo Jogo"
	new_game_btn.custom_minimum_size = Vector2(200, 50)
	new_game_btn.pressed.connect(_on_new_game_pressed)
	main_menu_panel.add_child(new_game_btn)
	
	# Botão Configurar Mapa
	var config_btn = Button.new()
	config_btn.text = "Configurar Mapa"
	config_btn.custom_minimum_size = Vector2(200, 50)
	config_btn.pressed.connect(_on_config_pressed)
	main_menu_panel.add_child(config_btn)
	
	# Botão Sair
	var quit_btn = Button.new()
	quit_btn.text = "Sair"
	quit_btn.custom_minimum_size = Vector2(200, 50)
	quit_btn.pressed.connect(_on_quit_pressed)
	main_menu_panel.add_child(quit_btn)

func create_config_menu() -> void:
	config_panel = PanelContainer.new()
	config_panel.position = Vector2(50, 50)
	config_panel.custom_minimum_size = Vector2(400, 0)
	config_panel.visible = false
	add_child(config_panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	config_panel.add_child(vbox)
	
	# Título
	var title = Label.new()
	title.text = "Configurações do Mapa"
	title.add_theme_font_size_override("font_size", 20)
	vbox.add_child(title)
	
	vbox.add_child(HSeparator.new())
	
	# Tamanho do mapa
	create_spinbox(vbox, "Largura do Mapa", map_settings["map_width"], 10, 1000, 
		func(val): map_settings["map_width"] = int(val))
	create_spinbox(vbox, "Altura do Mapa", map_settings["map_height"], 10, 1000, 
		func(val): map_settings["map_height"] = int(val))
	
	vbox.add_child(HSeparator.new())
	
	# Seed
	var seed_hbox = HBoxContainer.new()
	vbox.add_child(seed_hbox)
	
	var use_seed_check = CheckBox.new()
	use_seed_check.text = "Usar Seed"
	use_seed_check.button_pressed = map_settings["use_seed"]
	use_seed_check.toggled.connect(func(val): map_settings["use_seed"] = val)
	seed_hbox.add_child(use_seed_check)
	
	var seed_input = SpinBox.new()
	seed_input.min_value = 0
	seed_input.max_value = 999999
	seed_input.value = map_settings["seed_value"]
	seed_input.value_changed.connect(func(val): map_settings["seed_value"] = int(val))
	seed_hbox.add_child(seed_input)
	
	vbox.add_child(HSeparator.new())
	
	# Noise
	create_slider(vbox, "Escala do Noise", map_settings["noise_scale"] * 1000, 1, 100, 
		func(val): map_settings["noise_scale"] = val / 1000.0)
	create_slider(vbox, "Octavas", map_settings["noise_octaves"], 1, 8, 
		func(val): map_settings["noise_octaves"] = int(val))
	
	vbox.add_child(HSeparator.new())
	
	# Thresholds
	var terrain_label = Label.new()
	terrain_label.text = "Thresholds de Terreno"
	terrain_label.add_theme_font_size_override("font_size", 14)
	vbox.add_child(terrain_label)
	
	create_slider(vbox, "Água", (map_settings["water_threshold"] + 1) * 50, 0, 100, 
		func(val): map_settings["water_threshold"] = (val / 50.0) - 1.0)
	create_slider(vbox, "Areia", (map_settings["sand_threshold"] + 1) * 50, 0, 100, 
		func(val): map_settings["sand_threshold"] = (val / 50.0) - 1.0)
	create_slider(vbox, "Grama", (map_settings["grass_threshold"] + 1) * 50, 0, 100, 
		func(val): map_settings["grass_threshold"] = (val / 50.0) - 1.0)
	create_slider(vbox, "Floresta", (map_settings["forest_threshold"] + 1) * 50, 0, 100, 
		func(val): map_settings["forest_threshold"] = (val / 50.0) - 1.0)
	create_slider(vbox, "Montanha", (map_settings["mountain_threshold"] + 1) * 50, 0, 100, 
		func(val): map_settings["mountain_threshold"] = (val / 50.0) - 1.0)
	
	vbox.add_child(HSeparator.new())
	
	# Botão Voltar
	var back_btn = Button.new()
	back_btn.text = "Voltar"
	back_btn.pressed.connect(_on_config_back_pressed)
	vbox.add_child(back_btn)

func create_spinbox(parent: Control, label_text: String, value: float, min_val: float, max_val: float, callback: Callable) -> void:
	var hbox = HBoxContainer.new()
	parent.add_child(hbox)
	
	var label = Label.new()
	label.text = label_text
	label.custom_minimum_size.x = 150
	hbox.add_child(label)
	
	var spinbox = SpinBox.new()
	spinbox.min_value = min_val
	spinbox.max_value = max_val
	spinbox.value = value
	spinbox.value_changed.connect(callback)
	hbox.add_child(spinbox)

func create_slider(parent: Control, label_text: String, value: float, min_val: float, max_val: float, callback: Callable) -> void:
	var hbox = HBoxContainer.new()
	parent.add_child(hbox)
	
	var label = Label.new()
	label.text = label_text
	label.custom_minimum_size.x = 120
	hbox.add_child(label)
	
	var slider = HSlider.new()
	slider.min_value = min_val
	slider.max_value = max_val
	slider.value = value
	slider.custom_minimum_size.x = 200
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(callback)
	hbox.add_child(slider)
	
	var value_label = Label.new()
	value_label.text = str(snapped(value, 0.01))
	value_label.custom_minimum_size.x = 50
	hbox.add_child(value_label)
	
	slider.value_changed.connect(func(val): value_label.text = str(snapped(val, 0.01)))

func _on_new_game_pressed() -> void:
	# Salvar configurações globalmente
	GameManager.map_settings = map_settings
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_config_pressed() -> void:
	main_menu_panel.visible = false
	config_panel.visible = true

func _on_config_back_pressed() -> void:
	config_panel.visible = false
	main_menu_panel.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()
