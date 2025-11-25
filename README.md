# Super Wars - Jogo de Estratégia 2D Top-Down

## Estrutura do Projeto

### Pastas
- **scenes/** - Todas as cenas do jogo
- **scripts/** - Todos os scripts GDScript
- **assets/** - Recursos visuais e sonoros
  - `tiles/` - Tiles para o mapa
  - `sprites/` - Sprites de unidades, construções, etc.

## Bases Implementadas

### 1. Sistema de Câmera (`camera_controller.gd`)
- **Movimento**: WASD ou setas direcionais
- **Zoom**: Scroll do mouse, ou teclas Q (zoom out) / E (zoom in)
- Velocidade ajustada ao nível de zoom
- Limites configuráveis do mapa
- Zoom suave com interpolação

### 2. Sistema de Mapa (`game_map.gd`)
- Grid de tiles de 32x32 pixels
- Tamanho configurável (padrão 50x50)
- Funções de conversão entre coordenadas do mundo e grid
- Validação de posições
- Sistema simples, pronto para adicionar seus tiles em pixel art

### 3. Pasta para Tiles
- **`assets/tiles/`** - Adicione suas imagens em pixel art aqui (PNG recomendado, 32x32px)

### 4. Cena Principal (`world.tscn`)
Integra câmera e mapa em uma cena base.

## Como Adicionar Seus Tiles em Pixel Art

1. **Coloque suas imagens** na pasta `assets/tiles/`
   - Formato: PNG (32x32 pixels recomendado)
   - Exemplo: `grass.png`, `water.png`, etc.

2. **No Godot Editor**:
   - Abra a cena `scenes/world.tscn`
   - Selecione o nó `GameMap`
   - No Inspector: TileSet → New TileSet
   - Clique no TileSet criado para editá-lo
   - Arraste suas imagens para o TileSet editor
   - Configure o tamanho do tile (32x32)

3. **Defina a cena principal**:
   - Menu Project → Project Settings → Application → Run
   - Main Scene: `res://scenes/world.tscn`

4. **Teste**: Pressione F5

## Próximos Passos (quando quiser continuar)

- Sistema de seleção de tiles
- Editor de mapas
- Unidades e movimento
- Sistema de turno

## Controles
- **WASD/Setas**: Mover câmera
- **Scroll/Q/E**: Zoom in/out
