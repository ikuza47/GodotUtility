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
var tileSet
## The variable responsible for the node with which the functions will interact.
## [br][i]During initialization [method init], a self-node is automatically set.[/i]
## [br][method set_tileNode] | [method get_tileNode] | [method has_tileNode]
var tileNode: TileMapExtended = self

enum VECTORS2D {TYPE_VECTOR2, TYPE_VECTOR2I}

var generator: Generator = Generator.new()
var pallete: Pallete = Pallete.new()


var positionNode: Node2D = self

# UTILS FUNC
static func _vectorize2i(value):
	print(value)
	if _is_vector(value):
		return Vector2i(value)

static func _round_decimal(value: float, decimal: int) -> float:
	return float(round(int(value*pow(10, decimal)))/pow(10, decimal))

static func _is_vector(value) -> bool:
	return 1 if typeof(value) is VECTORS2D else 0

static func _sum_array(array: Array) -> float:
	var return_var: float = 0
	for i in array:
		return_var+=i
	return return_var
# INIT
func _notification(what: int) -> void:
	if what == 13:
		print("sent init")
		self.init()
# FUNC
func init(node: TileMapExtended = self):
	tileNode = node
	if self.tile_set != null:
		self.tileSet = tileNode.tile_set
		self.tileSize = tileNode.tile_set.tile_size
		if pallete.id == -1:
			pallete.fromTileSet(tileNode.tile_set, 0)
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

func place_tiles(pallete: Pallete):
	pass

# ===

func update_tiles(Position:= positionNode, ChunkSize:= chunkSize):
	var a = get_tilesetRange()

# ===

func test() -> void:
	pass

# ===
class Pallete:
	var id: int = 0: 
		set(value): id = value 
	var tiles: Array :
		set(value):
			print(value)
			tiles.clear()
			for i in value:
				tiles.append(TileMapExtended._vectorize2i(i))
			tiles = tiles.filter(func(value): return value is Vector2i)
	var chance: Array : 
		set(value):
			chance.clear()
			for i in value: chance.append(clampf(i, 0.0, 1.0))
			var temp = TileMapExtended._sum_array(chance)
			for i in chance:
				chance.set(chance.find(i),TileMapExtended._round_decimal(remap(i, 0, temp, 0, 1), 2))
	
	func _init(id: int = -1, tiles: Array = self.tiles) -> void:
		self.id = id
		self.tiles = tiles
	
	func add_tiles(tiles):
		if tiles is Array:
			for i in tiles:
				tiles.append(TileMapExtended._vectorize2i(i))
			tiles = self.tiles.filter(func(value): return value is Vector2i)
		if typeof(tiles) is VECTORS2D: self.tiles.append(TileMapExtended._vectorize2i(tiles))
	
	func toString() -> String:
		return "id: {id}, tiles: {tiles}, chances: {chance}".format({"id": self.id, "tiles": self.tiles, "chance": self.chance})
	
	func toDictionary() -> Dictionary:
		return {"id": self.id, "tiles": self.tiles, "chance": self.chance}
	
	func fromDictionary(dictionary: Dictionary):
		self.id = dictionary.get("id", 0)
		self.tiles = dictionary.get("tiles", [Vector2i(0,0)])
		self.chance = dictionary.get("chance", [1])
	
	func get_chance_to_tiles() -> Dictionary:
		var temp: Dictionary = {}
		for i in tiles:
			if chance.size()-1 >= tiles.find(i): 
				temp.set(i, chance[tiles.find(i)])
			else: temp.set(i, 0)
		return temp
	
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
	
	
	func setup(seed: int, frequency: float):
		self.seed = seed
		self.frequency = frequency
	
	func set_seed(value: int):
		seed = value
		noise.seed = seed
	func set_frequency(value: float):
		frequency = value
		noise.frequency = frequency
	
	func set_noise_type(NoiseType: FastNoiseLite.NoiseType):
		noise_type = NoiseType
		noise.noise_type = noise_type
		print(noise)
	
	func _remap(value: float) -> float:
		return remap(value, -1, 1, 0, 1)
	
	func get_noise(position:Vector2i) -> float:
		return _remap(noise.get_noise_2d(position.x, position.y))
	
	
