@tool
extends EditorScript

const TEXTURE_PATH := "res://assets/sprites/tileset.png"
const TILE_SIZE    := Vector2i(16, 16)
const SHEET_COLS   := 36
const SHEET_ROWS   := 15
const OUT_PATH     := "res://resources/tilemaps/tileset.tres"


func _run() -> void:
	var texture := load(TEXTURE_PATH) as Texture2D
	if not texture:
		push_error("Textura não encontrada: " + TEXTURE_PATH)
		return

	var tileset := TileSet.new()
	tileset.tile_size = TILE_SIZE

	var source := TileSetAtlasSource.new()
	source.texture = texture
	source.texture_region_size = TILE_SIZE

	for row in SHEET_ROWS:
		for col in SHEET_COLS:
			source.create_tile(Vector2i(col, row))

	tileset.add_source(source, 0)

	var layer_idx := tileset.get_custom_data_layer_by_name("type")
	if layer_idx < 0:
		tileset.add_custom_data_layer()
		layer_idx = tileset.get_custom_data_layers_count() - 1
		tileset.set_custom_data_layer_name(layer_idx, "type")
		tileset.set_custom_data_layer_type(layer_idx, TYPE_INT)

	DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path("res://resources/tilemaps/")
	)

	var err := ResourceSaver.save(tileset, OUT_PATH)
	if err == OK:
		print("[setup_tileset] Salvo em: ", OUT_PATH)
	else:
		push_error("[setup_tileset] Falha ao salvar — código: " + str(err))
