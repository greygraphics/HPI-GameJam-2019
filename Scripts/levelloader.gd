extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tilemap = get_node("TileMap")
var blueprint: Image
# evtl mit RNG + pro Bild fester Seed ersetzen:
var THRESHOLD_SALT = 0.88 # soll für pseudozufällig deterministische schöne Tiles sorgen 

enum {TILE_FLOOR_L, TILE_FLOOR_C, TILE_FLOOR_R, TILE_FLOOR_S, TILE_SOLID1, TILE_SOLID2, TILE_SOLID3}

# geht über alle Pixel eines Bildes und settet die Tilemap entsprechend
func generateLevelFromBlueprint(picture):
	var img_height = picture.get_height()
	var img_width = picture.get_width()
	var current_pxl: Color
	var tile: int
	for j in img_height:
		for i in img_width:
			current_pxl = picture.get_pixel(i,j)
			tile = matchTile(current_pxl)
			if tile == NAN:
				print("Invalid pixel color at %d, %d - skipped tile!" % i,j)
				continue
			tilemap.set_cell(i,j, tile)
			
# soll automatisch schöne Plattformen ect. machen
func postprocessingLevel(height: int, width: int):
	var tile
	for j in range(height+1,-1,-1):
		for i in range(width):
			match tilemap.get_cell(i,j):
				# passt Wände/Boden an
				TILE_FLOOR_C:
					if tilemap.get_cell(i,j+1) == TILE_FLOOR_C:
						# ein wenig Diversität:
						var someSalt = sin(i+j)
						if someSalt < -THRESHOLD_SALT:
							tilemap.set_cell(i,j,TILE_SOLID2)
						elif someSalt > THRESHOLD_SALT:
							tilemap.set_cell(i,j,TILE_SOLID3)
						else:
							tilemap.set_cell(i,j,TILE_SOLID1)
					elif tilemap.get_cell(i-1,j) == TILE_FLOOR_L or tilemap.get_cell(i-1,j) == TILE_FLOOR_C:
						if tilemap.get_cell(i+1,j) != TILE_FLOOR_C:
							tilemap.set_cell(i,j,TILE_FLOOR_R)
					elif tilemap.get_cell(i+1,j) == TILE_FLOOR_C:
						tilemap.set_cell(i,j,TILE_FLOOR_L)
					else:
						 tilemap.set_cell(i,j, TILE_FLOOR_S)
	
			
# ordnet einem Farbwert ein Tile zu
func matchTile(color: Color):
	match color:
		Color.brown:
			return TILE_FLOOR_C
		_:
			return NAN

		
		
			
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
