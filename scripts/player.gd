extends CharacterBody2D

@export var speed: float = 200.0
@export var default_weapon: PackedScene

var velocity_dir := Vector2.ZERO

func _ready():
	if not has_node("WeaponSlot"):
		push_error("Player: Missing 'WeaponSlot' node! Add an empty Node2D named 'WeaponSlot'.")
		return
	
	if default_weapon:
		equip_weapon(default_weapon)

func _physics_process(_delta):
	handle_movement()
	move_and_slide()
	
	if $WeaponSlot.get_child_count() > 0:
		var weapon = $WeaponSlot.get_child(0)
		if weapon.has_method("try_shoot"):
			weapon.try_shoot()

func handle_movement():
	velocity_dir = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		velocity_dir.x += 1
	if Input.is_action_pressed("left"):
		velocity_dir.x -= 1
	if Input.is_action_pressed("down"):
		velocity_dir.y += 1
	if Input.is_action_pressed("up"):
		velocity_dir.y -= 1
	
	if velocity_dir.length() > 0:
		velocity_dir = velocity_dir.normalized()
	
	velocity = velocity_dir * speed

func equip_weapon(weapon_scene: PackedScene):
	if not weapon_scene:
		return
	
	unequip_current_weapon()
	
	var new_weapon = weapon_scene.instantiate()
	if new_weapon.has_method("set_player"):  # 改为 set_player
		new_weapon.set_player(self)
	
	$WeaponSlot.add_child(new_weapon)

func unequip_current_weapon():
	for child in $WeaponSlot.get_children():
		child.queue_free()
