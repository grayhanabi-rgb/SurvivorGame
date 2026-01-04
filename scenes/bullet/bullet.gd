extends Area2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	monitoring = true
	monitorable = false
	# 信号已在场景中连接，无需重复 connect()

func _process(delta):
	if direction == Vector2.ZERO:
		queue_free()
		return
	position += direction * speed * delta

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		var enemy_script = area.get_script()
		if enemy_script and enemy_script.has_method("take_damage"):
			enemy_script.call("take_damage", 10)
		else:
			print("❌ 敌人无 take_damage 方法")
		queue_free()
