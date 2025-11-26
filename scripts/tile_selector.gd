extends Node2D
class_name TileSelector

# Referências
@onready var game_map: GameMap = get_node("/root/World/GameMap")

# Configurações visuais
@export var selection_color: Color = Color.WHITE
@export var selection_thickness: float = 2.0

# Estado da seleção
var selected_tiles: Array[Vector2i] = []
var is_dragging: bool = false
var drag_start_tile: Vector2i
var drag_current_tile: Vector2i

# Visual da seleção (borda única)
var selection_border: Line2D

func _ready() -> void:
	z_index = 100  # Acima de tudo

func _unhandled_input(event: InputEvent) -> void:
	# ESC para deselecionar
	if event.is_action_pressed("esc"):
		clear_selection()
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				handle_click_start(event.position)
			else:
				handle_click_end(event.position)
	
	elif event is InputEventMouseMotion and is_dragging:
		handle_drag(event.position)

func handle_click_start(_mouse_pos: Vector2) -> void:
	var world_pos = get_global_mouse_position()
	var tile_pos = game_map.world_to_grid(world_pos)
	
	if not game_map.is_valid_grid_position(tile_pos):
		return
	
	# Se clicar em tile já selecionado, desselecionar tudo
	if tile_pos in selected_tiles:
		clear_selection()
		return
	
	# Iniciar seleção em área
	is_dragging = true
	drag_start_tile = tile_pos
	drag_current_tile = tile_pos
	clear_selection()
	# Mostrar seleção imediatamente no tile inicial
	update_area_selection()

func handle_drag(_mouse_pos: Vector2) -> void:
	var world_pos = get_global_mouse_position()
	var tile_pos = game_map.world_to_grid(world_pos)
	
	if not game_map.is_valid_grid_position(tile_pos):
		return
	
	if tile_pos != drag_current_tile:
		drag_current_tile = tile_pos
		update_area_selection()

func handle_click_end(_mouse_pos: Vector2) -> void:
	if is_dragging:
		is_dragging = false
		# Finalizar seleção em área
		update_area_selection()

func clear_selection() -> void:
	selected_tiles.clear()
	remove_selection_border()

func update_area_selection() -> void:
	selected_tiles.clear()
	
	# Calcular área retangular
	var min_x = min(drag_start_tile.x, drag_current_tile.x)
	var max_x = max(drag_start_tile.x, drag_current_tile.x)
	var min_y = min(drag_start_tile.y, drag_current_tile.y)
	var max_y = max(drag_start_tile.y, drag_current_tile.y)
	
	# Selecionar todos os tiles na área
	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			var tile_pos = Vector2i(x, y)
			if game_map.is_valid_grid_position(tile_pos):
				selected_tiles.append(tile_pos)
	
	# Criar borda única ao redor da área
	create_area_border(min_x, max_x, min_y, max_y)

func create_area_border(min_x: int, max_x: int, min_y: int, max_y: int) -> void:
	remove_selection_border()
	
	if selected_tiles.is_empty():
		return
	
	selection_border = Line2D.new()
	selection_border.width = selection_thickness
	selection_border.default_color = selection_color
	selection_border.closed = true
	selection_border.z_index = 100
	
	# Calcular cantos da área total
	var top_left = game_map.grid_to_world(Vector2i(min_x, min_y))
	var top_right = game_map.grid_to_world(Vector2i(max_x, min_y))
	var bottom_right = game_map.grid_to_world(Vector2i(max_x, max_y))
	var bottom_left = game_map.grid_to_world(Vector2i(min_x, max_y))
	
	var half_size = game_map.TILE_SIZE / 2.0
	
	var points = PackedVector2Array([
		top_left + Vector2(-half_size, -half_size),
		top_right + Vector2(half_size, -half_size),
		bottom_right + Vector2(half_size, half_size),
		bottom_left + Vector2(-half_size, half_size)
	])
	
	selection_border.points = points
	add_child(selection_border)

func remove_selection_border() -> void:
	if selection_border:
		selection_border.queue_free()
		selection_border = null

func get_selected_tiles() -> Array[Vector2i]:
	return selected_tiles
