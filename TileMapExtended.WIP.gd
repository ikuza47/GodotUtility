extends TileMapLayer
## W.I.P
class_name TileMapExtended

# VARS

## The variable responsible for how many tiles are in the chunk.
## [br][method set_chunk_size] | [method get_chunk_size]
var chunkSize: int
## The variable responsible for how far the chunks are being upload.
## [br][method set_chunkDistance] | [method get_chunkDistance]
var chunkDistance: int
## The variable responsible for the tile size in the tileset.[br]
## [i]It is automatically installed using the [method init] method.[/i]
## [br][method set_tileSize] | [method get_tileSize]
var tileSize: Vector2i
## The variable responsible for the tileset used in the class. 
## [br][i]It is parsed during initialization of [method init] from the parameters, if available.[/i]
## [br][method set_tileSet] | [method get_tileSet] | [method has_tileSet]
var tileSet: TileSet
## The variable responsible for the node with which the functions will interact.
## [br][i]During initialization [method init], a self-node is automatically set.[/i]
## [br][method set_tileNode] | [method get_tileNode] | [method has_tileNode]
var tileNode: TileMapExtended

var positionNode: Node2D

# FUNC
func init(node:= self):
	tileNode = node
	if tileNode.tile_set:
		tileSet = tileNode.tile_set
		tileSize = tileNode.tile_set.tile_size

# ===

func set_chunkDistance(value:int): chunkDistance = value
func set_chunkSize(value:int): chunkSize = value
func set_tileSize(value:Vector2i): tileSize = value
func set_tileSet(tileset:TileSet): tileSet = tileset
func set_tileNode(tilenode:TileMapExtended): tileNode = tilenode

# ===

func get_chunk_distance() -> int: return chunkDistance
func get_chunk_size() -> int: return chunkSize
func get_tileSize() -> Vector2i: return tileSize
func get_tileSet() -> TileSet: return tileSet
func get_tileNode() -> TileMapExtended: return tileNode

# ===

func has_tileNode() -> bool: return 1 if tileNode else 0
func has_tileSet() -> bool: return 1 if tileSet else 0

# ===

func get_chunkRange() -> Array[Vector2i]:
	var cch = tileNode.local_to_map(positionNode.position)
	return [
		Vector2i(cch.x - chunkDistance, cch.y - chunkDistance),
		Vector2i(cch.x + chunkDistance, cch.y + chunkDistance)
	]

func get_tilesetRange() -> Array[Vector2i]:
	var chunkUploads = get_chunkRange()
	var tilesetUploads: Array[Vector2i]
	for pos in chunkUploads:
		tilesetUploads.append(Vector2i(pos.x * chunkSize, pos.y * chunkSize))
	return tilesetUploads

# ===

class Generator:
	var noise: FastNoiseLite = FastNoiseLite.new()
	var seed: int
	var frequency: float
	var empty: bool
	var tiles: Dictionary
	
	func _init(seed: int, empty: bool, tiles: Dictionary) -> void:
		self.seed = seed
		self.empty = empty
		self.tiles = tiles
	
	
	func set_seed(seed: int):
		self.seed = seed
	
	func set_frequency(frequency: float):
		self.frequency = frequency
	
	func set_empty(empty):
		self.empty = empty
	
	func set_tiles(tiles: Dictionary):
		self.tiles = tiles
	
	
	func get_seed()->int: return self.seed
	func get_frequency()->float: return self.frequency
	func get_empty()->bool: return self.empty
	func get_tiles()->Dictionary: return self.tiles
