extends TileMapLayer
class_name GameMap

# Tamanho do tile
const TILE_SIZE: int = 32

# IDs dos tiles no TileSet (ajuste conforme sua configuração)
enum TerrainTile {
	WATER = 9,      # Água
	SAND = 8,       # Areia
	GRASS = 6,      # Grama
	FOREST = 5,     # Floresta
	MOUNTAIN = 7    # Montanha
}

# Configurações do mapa
@export_group("Map Size")
@export var map_width: int = 50
@export var map_height: int = 50

# Configurações de geração procedural
@export_group("Procedural Generation")
@export var use_seed: bool = false
@export var seed_value: int = 0
@export_range(0.001, 0.1, 0.001) var noise_scale: float = 0.02
@export_range(1, 8) var noise_octaves: int = 4
@export_range(0.0, 1.0) var noise_persistence: float = 0.5

# Thresholds para tipos de terreno
@export_group("Terrain Thresholds")
@export_range(-1.0, 1.0) var water_threshold: float = -0.3
@export_range(-1.0, 1.0) var sand_threshold: float = -0.1
@export_range(-1.0, 1.0) var grass_threshold: float = 0.3
@export_range(-1.0, 1.0) var forest_threshold: float = 0.5
@export_range(-1.0, 1.0) var mountain_threshold: float = 0.7

# Gerador de noise
var noise: FastNoiseLite

func _ready() -> void:
	load_settings_from_game_manager()
	setup_noise()
	generate_procedural_map()

func load_settings_from_game_manager() -> void:
	var settings = GameManager.map_settings
	map_width = settings["map_width"]
	map_height = settings["map_height"]
	use_seed = settings["use_seed"]
	seed_value = settings["seed_value"]
	noise_scale = settings["noise_scale"]
	noise_octaves = settings["noise_octaves"]
	noise_persistence = settings["noise_persistence"]
	water_threshold = settings["water_threshold"]
	sand_threshold = settings["sand_threshold"]
	grass_threshold = settings["grass_threshold"]
	forest_threshold = settings["forest_threshold"]
	mountain_threshold = settings["mountain_threshold"]

# Configura o gerador de noise
func setup_noise() -> void:
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_octaves = noise_octaves
	noise.fractal_gain = noise_persistence
	noise.frequency = noise_scale
	
	if use_seed:
		noise.seed = seed_value
	else:
		noise.seed = randi()

# Gera mapa proceduralmente
func generate_procedural_map() -> void:
	for x in range(map_width):
		for y in range(map_height):
			var height_value = noise.get_noise_2d(x, y)
			var terrain_tile = get_terrain_from_height(height_value)
			set_cell(Vector2i(x, y), terrain_tile, Vector2i(0, 0))

# Determina o tipo de terreno baseado na altura
func get_terrain_from_height(height: float) -> int:
	if height < water_threshold:
		return TerrainTile.WATER
	elif height < sand_threshold:
		return TerrainTile.SAND
	elif height < grass_threshold:
		return TerrainTile.GRASS
	elif height < forest_threshold:
		return TerrainTile.FOREST
	elif height < mountain_threshold:
		return TerrainTile.MOUNTAIN
	else:
		# Picos muito altos voltam a ser montanha
		return TerrainTile.MOUNTAIN

# Regenera o mapa com novos parâmetros
func regenerate_map() -> void:
	clear()
	setup_noise()
	generate_procedural_map()

# Converte posição do mundo para coordenadas do grid
func world_to_grid(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		int(world_pos.x / TILE_SIZE),
		int(world_pos.y / TILE_SIZE)
	)

# Converte coordenadas do grid para posição do mundo (centro do tile)
func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(
		grid_pos.x * TILE_SIZE + TILE_SIZE / 2.0,
		grid_pos.y * TILE_SIZE + TILE_SIZE / 2.0
	)

# Verifica se uma coordenada está dentro dos limites do mapa
func is_valid_grid_position(grid_pos: Vector2i) -> bool:
	return grid_pos.x >= 0 and grid_pos.x < map_width and \
		   grid_pos.y >= 0 and grid_pos.y < map_height
