extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var max_enemies: int = 5
@export var spawn_radius: float = 200.0

var enemy_count: int = 0
var is_spawning: bool = false

func _ready():
	if enemy_scene == null:
		print("❌ 错误：敌人生成器未设置 enemy_scene！")
		return
	
	print("✅ 敌人生成器初始化成功")
	start_spawning()

func start_spawning():
	if is_spawning:
		return
	is_spawning = true
	spawn_enemy()

func spawn_enemy():
	if not is_spawning or enemy_count >= max_enemies:
		await get_tree().create_timer(0.5).timeout
		spawn_enemy()
		return
	
	var new_enemy = enemy_scene.instantiate()
	if new_enemy == null:
		return
	
	new_enemy.global_position = get_random_spawn_position()
	add_child(new_enemy)
	enemy_count += 1
	
	if new_enemy.has_signal("enemy_died"):
		new_enemy.enemy_died.connect(_on_enemy_died)
	
	await get_tree().create_timer(spawn_interval).timeout
	spawn_enemy()

func get_random_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player")
	
	if player != null:
		var angle = randf_range(0, 2 * PI)
		var offset = Vector2(cos(angle), sin(angle)) * spawn_radius
		return player.global_position + offset
	
	var viewport_size = get_viewport_rect().size
	return Vector2(viewport_size.x * 0.5, viewport_size.y * 0.5)

func _on_enemy_died():
	enemy_count -= 1
	if enemy_count < 0:
		enemy_count = 0
