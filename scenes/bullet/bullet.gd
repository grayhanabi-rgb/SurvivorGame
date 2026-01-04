# res://scripts/bullet.gd
extends Sprite2D

@export var speed: float = 400.0      # 子弹飞行速度
@export var damage: float = 25.0      # 子弹伤害值
@export var lifetime: float = 3.0     # 子弹存在时间（秒）

var direction: Vector2 = Vector2.RIGHT  # 子弹飞行方向

func _ready():
	# 设置子弹朝向
	rotation = direction.angle()
	
	# 自动销毁计时器
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	# 子弹移动
	position += direction * speed * delta

func _on_area_entered(area):
	print("🔥 强制触发！碰到的对象：", area.name)
	print("对象类型：", area.get_class())
	print("是否在 enemy 分组：", area.is_in_group("enemy"))
	
	# 强制销毁子弹，测试是否真的触发了
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
