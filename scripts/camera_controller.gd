extends Camera2D
class_name CameraController

# Configurações de movimento
@export var move_speed: float = 500.0
@export var drag_speed: float = 1.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 500.0

# Limites do mapa (opcional - ajuste conforme necessário)
@export var map_limit_left: int = -2000
@export var map_limit_right: int = 2000
@export var map_limit_top: int = -2000
@export var map_limit_bottom: int = 2000

var target_zoom: Vector2 = Vector2.ONE
var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2.ZERO
var camera_start_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	target_zoom = zoom

func _process(delta: float) -> void:
	handle_keyboard_movement(delta)
	handle_zoom(delta)

func _unhandled_input(event: InputEvent) -> void:
	# Iniciar drag com botão direito
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				is_dragging = true
				drag_start_position = event.position
				camera_start_position = position
			else:
				is_dragging = false
	
	# Atualizar posição durante drag
	if event is InputEventMouseMotion and is_dragging:
		var drag_offset = (drag_start_position - event.position) / zoom.x * drag_speed
		position = camera_start_position + drag_offset

func handle_keyboard_movement(delta: float) -> void:
	# Não mover com teclado durante drag
	if is_dragging:
		return
	
	var direction := Vector2.ZERO
	
	# Movimento com WASD ou setas
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	# Normalizar diagonal para manter velocidade constante
	direction = direction.normalized()
	
	# Mover câmera (ajustar velocidade baseado no zoom)
	position += direction * move_speed * delta / zoom.x

func handle_zoom(delta: float) -> void:
	# Zoom com scroll do mouse ou Q/E
	var zoom_change := 0.0
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom_change = zoom_speed
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_change = -zoom_speed
	
	if zoom_change != 0:
		target_zoom += Vector2.ONE * zoom_change
		target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
		target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)
	
	# Suavizar zoom
	zoom = zoom.lerp(target_zoom, 10.0 * delta)

# Função para centralizar em uma posição específica
func center_on_position(pos: Vector2) -> void:
	position = pos
