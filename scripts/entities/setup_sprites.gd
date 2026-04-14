@tool
extends EditorScript

const TEXTURE_PATH    := "res://assets/sprites/characters.png"
const W               := 16
const H               := 16
const OUT             := "res://resources/sprite_frames/"
const LOLO_COL_OFFSET := 0
const LALA_COL_OFFSET := 7
const FRAMES_PER_ROW  := 7

# [nome, row, fps, loop]
const ANIMATIONS := [
	["walk_down",  0, 8.0, true ],
	["walk_up",    1, 8.0, true ],
	["walk_left",  2, 8.0, true ],
	["walk_right", 3, 8.0, true ],
	["die",        4, 6.0, false],
	["idle",       5, 4.0, true ],
]


func _run() -> void:
	var texture := load(TEXTURE_PATH) as Texture2D
	if not texture:
		push_error("Textura não encontrada: " + TEXTURE_PATH)
		return

	DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path(OUT)
	)

	_build_and_save("lolo", LOLO_COL_OFFSET, texture)
	_build_and_save("lala", LALA_COL_OFFSET, texture)
	print("[setup_sprites] Concluído — arquivos em ", OUT)


func _build_and_save(character: String, col_offset: int, texture: Texture2D) -> void:
	var frames := SpriteFrames.new()
	frames.remove_animation("default")

	for entry in ANIMATIONS:
		var anim_name: String = entry[0]
		var row: int          = entry[1]
		var fps: float        = entry[2]
		var loop: bool        = entry[3]

		frames.add_animation(anim_name)
		frames.set_animation_speed(anim_name, fps)
		frames.set_animation_loop(anim_name, loop)

		for i in FRAMES_PER_ROW:
			var atlas := AtlasTexture.new()
			atlas.atlas  = texture
			atlas.region = Rect2((col_offset + i) * W, row * H, W, H)
			atlas.filter_clip = true
			frames.add_frame(anim_name, atlas)

	var path := OUT + character + "_frames.tres"
	var err  := ResourceSaver.save(frames, path)
	if err == OK:
		print("  Salvo: ", path)
	else:
		push_error("  Falha ao salvar " + path + " — código: " + str(err))
