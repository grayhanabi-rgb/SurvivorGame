extends Node2D

@export var bullet_scene: PackedScene
@export var shoot_range: float = 300.0
@export var fire_rate: float = 0.3

var player: CharacterBody2D
var last_shot_time: float = 0.0

func _ready():
	if bullet_scene == null:
		push_error("Weapon: bullet_scene not assigned!")
		return

func set_player(owner: CharacterBody2D):  # 改名为 owner，避免冲突
	self.player = owner

func try_shoot():
	if player == null or bullet_scene == null:
		return
	
	var current_time = Time.get_ticks_msec() / 1000.0
	if (current_time - last_shot_time) < fire_rate:
		return
	
	var closest_enemy = null
	var closest_distance = shoot_range
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy is Node2D and enemy.is_inside_tree():
			var dist = global_position.distance_to(enemy.global_position)
			if dist < closest_distance:
				closest_distance = dist
				closest_enemy = enemy
	
	if closest_enemy != null:
		last_shot_time = current_time
		
		var bullet = bullet_scene.instantiate()
		bullet.position = $Muzzle.global_position
		
		var direction = (closest_enemy.global_position - bullet.position).normalized()
		bullet.direction = direction
		
		get_tree().root.add_child(bullet)
