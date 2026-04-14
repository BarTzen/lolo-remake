extends CharacterBody2D

const TILE_SIZE  := 16
const MOVE_SPEED := 128.0

const ANIM_FOR_DIR := {
	Vector2i.UP:    "walk_up",
	Vector2i.DOWN:  "walk_down",
	Vector2i.LEFT:  "walk_left",
	Vector2i.RIGHT: "walk_right",
}

var _moving     := false
var _target_pos := Vector2.ZERO

@onready var _sprite  := $AnimatedSprite2D as AnimatedSprite2D
@onready var _tilemap := _find_tilemap()


func _ready() -> void:
	_target_pos = position
	_sprite.play("idle")


func _process(delta: float) -> void:
	if _moving:
		_step(delta)
	else:
		_read_input()


# ── Movimento público — pode ser chamado de qualquer lugar ────────────────────

func move_up() -> void:
	_try_move(Vector2i.UP)

func move_down() -> void:
	_try_move(Vector2i.DOWN)

func move_left() -> void:
	_try_move(Vector2i.LEFT)

func move_right() -> void:
	_try_move(Vector2i.RIGHT)


# ── Internos ──────────────────────────────────────────────────────────────────

func _read_input() -> void:
	if   Input.is_action_pressed("ui_up"):    move_up()
	elif Input.is_action_pressed("ui_down"):  move_down()
	elif Input.is_action_pressed("ui_left"):  move_left()
	elif Input.is_action_pressed("ui_right"): move_right()


func _try_move(dir: Vector2i) -> void:
	var next_tile := Vector2i(position / TILE_SIZE) + dir
	_sprite.play(ANIM_FOR_DIR[dir])
	if _tilemap and TileTypes.is_solid(_tilemap, next_tile):
		return
	_moving     = true
	_target_pos = position + Vector2(dir) * TILE_SIZE


func _step(delta: float) -> void:
	position = position.move_toward(_target_pos, MOVE_SPEED * delta)
	if position.is_equal_approx(_target_pos):
		position = _target_pos
		_moving  = false
		_sprite.play("idle")


func _find_tilemap() -> TileMapLayer:
	var p := get_parent()
	if p and p.get_parent():
		return p.get_parent().get_node_or_null("TileMapLayer") as TileMapLayer
	return null
