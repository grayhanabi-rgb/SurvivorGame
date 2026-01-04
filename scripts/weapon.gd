extends Node2D

@export var bullet_scene: PackedScene
@export var shoot_range: float = 300.0
@export var fire_rate: float = 0.3

var player = null
var last_shot_time: float = 0.0

func _ready():
	if bullet_scene == null:
		push_error("Weapon: 'Bullet Scene' is not assigned in the inspector!")

func set_player(p):
	player = p

func try_shoot():
	if player == null or bullet_scene == null:
		return
	
	var current_time = Time.get_ticks_msec() / 1000.0
	if (current_time - last_shot_time) < fire_rate:
		return
	
	var closest_enemy = null
	var closest_distance = shoot_range
	
	# 查找最近的敌人
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy is Node2D and enemy.is_inside_tree():
			var dist = global_position.distance_to(enemy.global_position)  # ✅ 正确声明
			if dist < closest_distance:
				closest_distance = dist
				closest_enemy = enemy
	
	# 如果有敌人在射程内，发射子弹
	if closest_enemy != null:
		last_shot_time = current_time
		
		var bullet = bullet_scene.instantiate()
		
		# 设置发射位置
		if has_node("Muzzle"):
			bullet.position = $Muzzle.global_position
		else:
			bullet.position = global_position  # 回退方案
		
		# 设置方向
		var direction = (closest_enemy.global_position - bullet.position).normalized()
		bullet.direction = direction
		
		# 添加到根节点，避免被玩家销毁影响
		get_tree().root.add_child(bullet)
