extends AnimatedSprite2D

var bulletHole = preload("res://assets/weapons/bullet_hole.tscn")

@onready var root = get_node("/root")
@onready var timer = $shotCooldown
@onready var bulletpos = $bulletPos
@onready var rayCast = $shotRay
@onready var clipArea = $clipArea
@export var maxAmmo = 6
@export var cooldown = 0.375
var currentAmmo = maxAmmo
var cooled = false
var gunshot = false
var clipping = false


func _physics_process(_delta):
	bulletpos.global_rotation = 0
	var collided = rayCast.get_collider()
	var collidedPoint = rayCast.get_collision_point()
	if gunshot == true:
		if collided != null:
			if collided.is_in_group("staticObj") or collided.is_in_group("obstacle"):
				var randRot = randi_range(-180,180)
				var randSizeModx = randi_range(-0.9, 0.6)
				var randSizeMody = randi_range(-0.9, 0.6)
				var holeInstance = bulletHole.instantiate()
				holeInstance.global_position = collidedPoint
				holeInstance.global_rotation = deg_to_rad(randRot)
				holeInstance.scale = Vector2(1+randSizeModx, 1+randSizeMody)
				root.call_deferred("add_child", holeInstance)
			if collided.is_in_group("physObj") == true:
				collided._break()
			elif collided.name == "headArea":
				for child in collided.get_parent().get_children():
					var enemyCollider = child.get_child(0)
					enemyCollider.disabled = true
				collided.get_parent().get_parent().animator.play("headshot")
				collided.get_parent().get_parent().killed = true
			elif collided.name == "torsoArea":
				for child in collided.get_parent().get_children():
					var enemyCollider = child.get_child(0)
					enemyCollider.disabled = true
				collided.get_parent().get_parent().animator.play("headshot")
				collided.get_parent().get_parent().killed = true
			elif collided.name == "legArea":
				for child in collided.get_parent().get_children():
					var enemyCollider = child.get_child(0)
					enemyCollider.disabled = true
				collided.get_parent().get_parent().animator.play("headshot")
				collided.get_parent().get_parent().killed = true
		gunshot = false
		

func fire():
	if currentAmmo > 0 and cooled == false and clipping == false:
		timer.start(cooldown)
		cooled = true
		play("fire")
		currentAmmo -= 1
		gunshot = true
	elif currentAmmo <= 0:
		$bulletPos/needReload.visible = true

func reload():
	#play reload anim
	currentAmmo = maxAmmo
	$bulletPos/needReload.visible = false

func _on_shot_cooldown_timeout():
	cooled = false

func _on_clip_area_body_entered(body):
	if body.name != "player":
		clipping = true

func _on_clip_area_body_exited(body):
	clipping = false

func _on_clip_area_area_entered(area):
	if area.name != "player":
		clipping = true

func _on_clip_area_area_exited(area):
	clipping = false
