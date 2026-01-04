extends Area2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	monitoring = true
	monitorable = false
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta):
	if direction == Vector2.ZERO:
		queue_free()
		return
	
	position += direction * speed * delta

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.queue_free()  # 消灭敌人
		queue_free()       # 消灭子弹
