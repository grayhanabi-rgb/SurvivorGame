extends Sprite2D

@export var speed: float = 500.0
@export var damage: float = 10.0
var direction: Vector2

func _ready():
	# 假设方向由发射时传入（例如从玩家脚本）
	# 如果你使用 look_at 或 rotation 设置方向，请根据实际情况调整
	pass

func _physics_process(delta):
	if direction:
		position += direction * speed * delta
	else:
		# 如果未设置方向，自动朝上（兼容旧逻辑）
		position += Vector2(0, -1) * speed * delta

	# 可选：超出屏幕后自动销毁（防止内存泄漏）
	if not get_viewport_rect().has_point(get_global_mouse_position()):
		queue_free()

func _on_area_entered(area):
	# 获取 Area2D 的父节点（即真正的敌人根节点）
	var enemy = area.get_parent()
	
	# 检查父节点是否存在、属于 "enemy" 分组、且有 take_damage 方法
	if enemy != null and enemy.is_in_group("enemy"):
		if enemy.has_method("take_damage"):
			enemy.take_damage(damage)
		queue_free()  # 销毁子弹
