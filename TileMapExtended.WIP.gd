extends TileMapLayer
## W.I.P
class_name TileMapExtended
# VARS
## The variable responsible for how many tiles are in the chunk.
## [br][method set_chunk_size] | [method get_chunk_size]
var chunkSize: int = 16
## The variable responsible for how far the chunks are being upload.
## [br][method set_chunkDistance] | [method get_chunkDistance]
var chunkDistance: int = 16
## The variable responsible for the tile size in the tileset.[br]
## [i]It is automatically installed using the [method init] method.[/i]
## [br][method set_tileSize] | [method get_tileSize]
var tileSize: Vector2i = Vector2i(1,1)
## The variable responsible for the tileset used in the class. 
## [br][i]It is parsed during initialization of [method init] from the parameters, if available.[/i]
## [br][method set_tileSet] | [method get_tileSet] | [method has_tileSet]
var tileSet: TileSet
## The variable responsible for the node with which the functions will interact.
## [br][i]During initialization [method init], a self-node is automatically set.[/i]
## [br][method set_tileNode] | [method get_tileNode] | [method has_tileNode]
var tileNode: TileMapExtended = self

enum Vectors2D {TYPE_VECTOR2, TYPE_VECTOR2I}

var generator: Generator = Generator.new()

var positionNode: Node2D = self

# UTILS FUNC
static func _vectorize2i(value):
	if _is_vector(value):
		return Vector2i(value)

static func _round_decimal(value: float, decimal: int) -> float:
	return float(round(int(value*pow(10, decimal)))/pow(10, decimal))

static func _is_vector(value) -> bool:
	return 1 if typeof(value) is Vectors2D else 0

# INIT
func _notification(what: int) -> void:
	if what == 13:
		print("sent init")
		init()
# FUNC
func init(node: TileMapExtended = self, type: FastNoiseLite.NoiseType = 0, seed: int = 0, frequency: float = 0.01):
	tileNode = node
	if tileNode.tile_set:
		tileSet = tileNode.tile_set
		tileSize = tileNode.tile_set.tile_size
	print("inited!")
	test()
# ===

func set_chunkDistance(value:int): chunkDistance = value
func set_chunkSize(value:int): chunkSize = value
func set_tileSize(value:Vector2i): tileSize = value
func set_tileSet(tileset:TileSet): tileSet = tileset
func set_tileNode(tilenode:TileMapExtended): tileNode = tilenode

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

func get_tilesets() -> Array[Vector2i]:
	var tileset_range = get_tilesetRange()
	var tilesets: Array[Vector2i]
	for x in range(tileset_range[0].x, tileset_range[1].x, tileSize.x):
		for y in range(tileset_range[0].y, tileset_range[1].y, tileSize.y):
			tilesets.append(Vector2i(x , y))
	return tilesets
# ===

func get_noises() -> Dictionary:
	var dictionary = {}
	var tileset = get_tilesets()
	for i in tileset:
		dictionary.set(i, _round_decimal(generator.get_noise(i), 2))
	return dictionary

# ===

func update_tiles(Position:= positionNode, ChunkSize:= chunkSize):
	var a = get_tilesetRange()

# ===

func test() -> void:
	var a = Generator.new({Vector2i(0,0): 0.3})
	var x = Vector2i(0,0)
	a.set_noise_type(2)

# ===
class Pallete:
	var id: int = 0: 
		get: return id
		set(value): id = value 
	var tiles: Array :
		get: return tiles
		set(value):
			tiles.clear()
			for i in value:
				tiles.append(TileMapExtended._vectorize2i(i))
			tiles = tiles.filter(func(value): return value is Vector2i)
	
	func _init(id: int = 0, tiles: Array = self.tiles) -> void:
		self.id = id
		self.tiles = tiles
	
	func add_tiles(tiles):
		if tiles is Array:
			for i in tiles:
				tiles.append(TileMapExtended._vectorize2i(i))
			tiles = self.tiles.filter(func(value): return value is Vector2i)
		if tiles is Vector2 or tiles is Vector2i: self.tiles.append(TileMapExtended._vectorize2i(tiles))
	
	func toString() -> String:
		return "id: {id}, tiles: {tiles}".format({"id": self.id, "tiles": self.tiles})
	
	func toDictionary() -> Dictionary:
		return {"id": self.id, "tiles": self.tiles}
	
	func fromDictionary(dictionary: Dictionary):
		self.id = dictionary.get("id")
		self.tiles = dictionary.get("tiles")
	
	func fromTileSet(tileset: TileSet, AtlasID: int = 0):
		self.id = AtlasID
		var pattern = tileset.get_source(AtlasID)
		tiles.clear()
		for i in pattern.get_tiles_count():
			add_tiles(pattern.get_tile_id(i))
# ===
class Generator:
	var noise: FastNoiseLite = FastNoiseLite.new()
	var seed: int : set = set_seed
	var noise_type: FastNoiseLite.NoiseType: set = set_noise_type
	var frequency: float : set = set_frequency
	var empty: bool : set = set_empty
	var tiles: Dictionary : set = set_tiles
	
	func _init(tiles: Dictionary = {}) -> void:
		self.tiles = tiles
	
	func setup(tiles: Dictionary, seed: int, frequency: float, empty: bool):
		self.tiles = tiles
		self.seed = seed
		self.frequency = frequency
		self.empty = empty
	
	func set_seed(value: int):
		seed = value
		noise.seed = seed
	func set_frequency(value: float):
		frequency = value
		noise.frequency = frequency
	func set_empty(value):
		empty = value
	func set_tiles(value: Dictionary):
		tiles = value
	
	func set_noise_type(NoiseType: FastNoiseLite.NoiseType):
		noise_type = NoiseType
		noise.noise_type = noise_type
		print(noise)
	
	func _remap(value: float) -> float:
		return remap(value, -1, 1, 0, 1)
	
	func get_noise(position:Vector2i) -> float:
		return _remap(noise.get_noise_2d(position.x, position.y))
	
	
