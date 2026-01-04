# res://scripts/player.gd
extends CharacterBody2D

@export var speed: float = 300.0           # 玩家移动速度
@export var bullet_scene: PackedScene       # 子弹场景引用
@export var fire_rate: float = 0.5          # 自动射击间隔（秒）
@export var max_health: float = 100.0       # 最大生命值

var current_health: float = 100.0
var nearest_enemy = null

func _ready():
	current_health = max_health
	add_to_group("player")  # 确保在 player 分组中
	
	# 启动自动射击
	start_auto_shooting()

func _physics_process(delta):
	# 玩家移动控制
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed
	move_and_slide()
	
	# 更新最近的敌人
	update_nearest_enemy()

func start_auto_shooting():
	# 启动自动射击协程
	auto_shoot()

func auto_shoot():
	while true:
		# 如果有子弹场景和目标敌人，就射击
		if bullet_scene != null and nearest_enemy != null:
			shoot_at_target(nearest_enemy.global_position)
		
		# 等待射速间隔
		await get_tree().create_timer(fire_rate).timeout

func update_nearest_enemy():
	nearest_enemy = null
	var min_distance = INF
	
	# 遍历所有敌人，找到最近的
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy == null or not enemy.is_inside_tree():
			continue
			
		var distance = global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			nearest_enemy = enemy

func shoot_at_target(target_position: Vector2):
	# 计算射击方向
	var direction = (target_position - global_position).normalized()
	
	# 创建子弹实例
	var bullet = bullet_scene.instantiate()
	if bullet == null:
		return
		
	# 设置子弹位置和方向
	bullet.global_position = global_position
	bullet.direction = direction
	
	# 添加到游戏世界
	get_tree().get_root().add_child(bullet)

# 受伤处理
func take_damage(amount: float):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	print("💀 玩家死亡！")
	queue_free()
