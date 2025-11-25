extends CanvasLayer
class_name MapGeneratorUI

@onready var game_map: GameMap = get_node("/root/World/GameMap")
@onready var tile_selector: TileSelector = get_node("/root/World/TileSelector")

# Referências dos controles
var seed_input: SpinBox
var use_seed_check: CheckBox
var scale_slider: HSlider
var octaves_slider: HSlider
var water_slider: HSlider
var sand_slider: HSlider
var grass_slider: HSlider
var forest_slider: HSlider
var regenerate_button: Button

func _ready() -> void:
	visible = false  # Não mostrar mais durante o jogo

func create_ui() -> void:
	# Container principal
	var panel = PanelContainer.new()
	panel.position = Vector2(10, 10)
	panel.custom_minimum_size = Vector2(300, 0)
	add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)
	
	# Título
	var title = Label.new()
	title.text = "Geração Procedural"
	title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(title)
	
	# Seed
	var seed_hbox = HBoxContainer.new()
	vbox.add_child(seed_hbox)
	
	use_seed_check = CheckBox.new()
	use_seed_check.text = "Usar Seed"
	use_seed_check.button_pressed = game_map.use_seed
	use_seed_check.toggled.connect(_on_use_seed_toggled)
	seed_hbox.add_child(use_seed_check)
	
	seed_input = SpinBox.new()
	seed_input.min_value = 0
	seed_input.max_value = 999999
	seed_input.value = game_map.seed_value
	seed_input.editable = game_map.use_seed
	seed_input.value_changed.connect(_on_seed_changed)
	seed_hbox.add_child(seed_input)
	
	# Separador
	vbox.add_child(HSeparator.new())
	
	# Noise Scale
	scale_slider = create_slider_with_label(vbox, "Escala do Noise", 
		game_map.noise_scale * 1000, 1, 100, 1)
	scale_slider.value_changed.connect(_on_scale_changed)
	
	# Octaves
	octaves_slider = create_slider_with_label(vbox, "Octavas", 
		game_map.noise_octaves, 1, 8, 1)
	octaves_slider.value_changed.connect(_on_octaves_changed)
	
	# Separador
	vbox.add_child(HSeparator.new())
	
	var terrain_label = Label.new()
	terrain_label.text = "Thresholds de Terreno"
	terrain_label.add_theme_font_size_override("font_size", 14)
	vbox.add_child(terrain_label)
	
	# Thresholds
	water_slider = create_slider_with_label(vbox, "Água", 
		(game_map.water_threshold + 1) * 50, 0, 100, 1)
	water_slider.value_changed.connect(_on_water_changed)
	
	sand_slider = create_slider_with_label(vbox, "Areia", 
		(game_map.sand_threshold + 1) * 50, 0, 100, 1)
	sand_slider.value_changed.connect(_on_sand_changed)
	
	grass_slider = create_slider_with_label(vbox, "Grama", 
		(game_map.grass_threshold + 1) * 50, 0, 100, 1)
	grass_slider.value_changed.connect(_on_grass_changed)
	
	forest_slider = create_slider_with_label(vbox, "Floresta", 
		(game_map.forest_threshold + 1) * 50, 0, 100, 1)
	forest_slider.value_changed.connect(_on_forest_changed)
	
	# Separador
	vbox.add_child(HSeparator.new())
	
	# Seleção de tiles
	var selection_label = Label.new()
	selection_label.text = "Seleção de Tiles"
	selection_label.add_theme_font_size_override("font_size", 14)
	vbox.add_child(selection_label)
	
	var clear_selection_button = Button.new()
	clear_selection_button.text = "Limpar Seleção"
	clear_selection_button.pressed.connect(_on_clear_selection_pressed)
	vbox.add_child(clear_selection_button)
	
	# Separador
	vbox.add_child(HSeparator.new())
	
	# Botão de regenerar
	regenerate_button = Button.new()
	regenerate_button.text = "Regenerar Mapa"
	regenerate_button.pressed.connect(_on_regenerate_pressed)
	vbox.add_child(regenerate_button)
	
	# Botão de fechar
	var toggle_button = Button.new()
	toggle_button.text = "Fechar [F1]"
	toggle_button.pressed.connect(_on_toggle_pressed)
	vbox.add_child(toggle_button)

func create_slider_with_label(parent: Control, label_text: String, 
		value: float, min_val: float, max_val: float, step: float) -> HSlider:
	var hbox = HBoxContainer.new()
	parent.add_child(hbox)
	
	var label = Label.new()
	label.text = label_text
	label.custom_minimum_size.x = 100
	hbox.add_child(label)
	
	var slider = HSlider.new()
	slider.min_value = min_val
	slider.max_value = max_val
	slider.step = step
	slider.value = value
	slider.custom_minimum_size.x = 150
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(slider)
	
	var value_label = Label.new()
	value_label.text = str(snapped(value, 0.01))
	value_label.custom_minimum_size.x = 50
	hbox.add_child(value_label)
	
	slider.value_changed.connect(func(val): value_label.text = str(snapped(val, 0.01)))
	
	return slider

func _input(_event: InputEvent) -> void:
	# F1 desabilitado - configurações só no menu inicial
	pass

# Callbacks
func _on_use_seed_toggled(toggled: bool) -> void:
	game_map.use_seed = toggled
	seed_input.editable = toggled

func _on_seed_changed(value: float) -> void:
	game_map.seed_value = int(value)

func _on_scale_changed(value: float) -> void:
	game_map.noise_scale = value / 1000.0

func _on_octaves_changed(value: float) -> void:
	game_map.noise_octaves = int(value)

func _on_water_changed(value: float) -> void:
	game_map.water_threshold = (value / 50.0) - 1.0

func _on_sand_changed(value: float) -> void:
	game_map.sand_threshold = (value / 50.0) - 1.0

func _on_grass_changed(value: float) -> void:
	game_map.grass_threshold = (value / 50.0) - 1.0

func _on_forest_changed(value: float) -> void:
	game_map.forest_threshold = (value / 50.0) - 1.0

func _on_regenerate_pressed() -> void:
	game_map.regenerate_map()

func _on_toggle_pressed() -> void:
	visible = false

func _on_clear_selection_pressed() -> void:
	if tile_selector:
		tile_selector.clear_selection()
