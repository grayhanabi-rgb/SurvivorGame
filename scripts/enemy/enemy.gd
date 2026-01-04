extends CharacterBody2D

signal enemy_died

@export var speed: float = 100.0
@export var max_health: float = 50.0
@export var damage: float = 10.0

var current_health: float = 50.0
var player_ref = null

func _ready():
	current_health = max_health
	player_ref = get_tree().get_first_node_in_group("player")
	if player_ref == null:
		print("⚠️ 警告：未找到玩家节点")
	
	add_to_group("enemy")

func _physics_process(delta):
	if player_ref != null:
		var direction = (player_ref.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func take_damage(damage_amount: float):
	if current_health <= 0:
		return
		
	current_health -= damage_amount
	print("敌人受到伤害，剩余生命值：", current_health)
	
	# 视觉反馈
	if has_node("ColorRect"):
		$ColorRect.modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid($ColorRect):
			$ColorRect.modulate = Color(1, 0, 0)
	
	# 检查是否死亡
	if current_health <= 0:
		emit_signal("enemy_died")
		queue_free()  # ✅ 必须调用！
		
