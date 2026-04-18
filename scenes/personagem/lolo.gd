extends CharacterBody2D

@export var tile_size = 8
@export var walk_speed = 0.2
@export var idle_wait_time = 2.0 # Tempo para ficar idle

@onready var anim = $AnimatedSprite2D
@onready var idle_timer = $IdleTimer # Arraste o nó Timer para cá

var is_moving = false

func _ready():
	# Configura o timer via código caso não tenha feito no editor
	idle_timer.wait_time = idle_wait_time
	idle_timer.one_shot = true
	idle_timer.start() # Começa a contar assim que o jogo inicia

func _physics_process(_delta):
	if is_moving:
		return
	
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"): input_dir = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"): input_dir = Vector2.LEFT
	elif Input.is_action_pressed("ui_down"): input_dir = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"): input_dir = Vector2.UP
	

	if input_dir != Vector2.ZERO:
		# Se o jogador apertar qualquer tecla, para o contador de Idle
		idle_timer.stop() 
		move_in_grid(input_dir)
	else:
		anim.stop();

func move_in_grid(direction):
	is_moving = true
	update_animation(direction)
	
	var target_position = position + (direction * tile_size)
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, walk_speed)
	
	tween.finished.connect(func(): 
		is_moving = false
		# Ao parar de mover, o timer de idle começa a contar novamente
		idle_timer.start()
	)

func update_animation(direction):
	if direction == Vector2.RIGHT: anim.play("walk_right")
	elif direction == Vector2.LEFT: anim.play("walk_left")
	elif direction == Vector2.DOWN: anim.play("walk_down")
	elif direction == Vector2.UP: anim.play("walk_up")
	
# --- CONECTE O SINAL 'timeout()' DO IDLE_TIMER A ESTA FUNÇÃO ---
func _on_idle_timer_timeout():
	# Só toca o idle se ele não estiver no meio de um movimento
	if not is_moving:
		anim.play("idle") # Certifique-se de ter uma animação chamada "idle"
		print("Personagem ficou entediado e entrou em Idle")
