class_name TileTypes
extends RefCounted

enum Type {
	UNKNOWN  = -1,
	FLOOR    = 0,
	WALL     = 1,
	BUSH     = 2,
	WATER    = 3,
	BLOCK    = 4,
	ITEM     = 5,
	DOOR     = 6,
	STAIRS   = 7,
	CONVEYOR = 8,
}

const SOLID: Dictionary = {
	Type.FLOOR:    false,
	Type.WALL:     true,
	Type.BUSH:     true,
	Type.WATER:    true,
	Type.BLOCK:    true,
	Type.ITEM:     false,
	Type.DOOR:     true,
	Type.STAIRS:   false,
	Type.CONVEYOR: false,
	Type.UNKNOWN:  false,
}

# Fallback usado enquanto os tiles não tiverem custom data configurado
const ATLAS_TO_TYPE: Dictionary = {
	Vector2i(0, 0): Type.WALL,
	Vector2i(0, 1): Type.BUSH,
	Vector2i(0, 4): Type.FLOOR,
}


static func get_type(tilemap: TileMapLayer, tile_pos: Vector2i) -> Type:
	var data := tilemap.get_cell_tile_data(tile_pos)
	if data == null:
		return Type.UNKNOWN

	if tilemap.tile_set != null \
			and tilemap.tile_set.get_custom_data_layer_by_name("type") >= 0:
		var raw: Variant = data.get_custom_data("type")
		if raw is int:
			return raw as Type

	var atlas_coord := tilemap.get_cell_atlas_coords(tile_pos)
	return ATLAS_TO_TYPE.get(atlas_coord, Type.UNKNOWN)


static func is_solid(tilemap: TileMapLayer, tile_pos: Vector2i) -> bool:
	return SOLID.get(get_type(tilemap, tile_pos), false)


static func is_type(tilemap: TileMapLayer, tile_pos: Vector2i, t: Type) -> bool:
	return get_type(tilemap, tile_pos) == t
