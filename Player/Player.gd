class_name Player
extends CharacterBody2D
@onready var level = get_node("/root/Game/Level")
@onready var weaponNode: Node2D = get_node("Weapon")
@onready var itemNode: Node2D = get_node("Item")
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var healthBar = get_node("../../UI/Control/Healthbar")
@export var max_speed: int = 1000
var currentWeapon: Node2D
var direction : Vector2
var canDash = true
var dashing = false
var stats = PlayerStats
var currentItem: Node2D

@onready 
var state_machine = $StateControl


	
func _ready():
	self.stats.connect("no_health", queue_free)
	healthBar.init_health(stats.ReturnHealth())
	state_machine.init(self)
func _physics_process(delta):
	
	
	state_machine.process_physics(delta)
	if currentWeapon:
		currentWeapon.look_at(get_global_mouse_position())
		level.UpdateAmmo(currentWeapon.currentAmmo)

func _process(delta):
	state_machine.process_frame(delta)
	
func _unhandled_input(event):
	state_machine.process_input(event)

func _input(event):
	if currentWeapon:
		if event.is_action_pressed("left_click"):			
			currentWeapon.shoot()	
			level.UpdateAmmo(currentWeapon.currentAmmo)
	if currentItem: 
		if event.is_action_pressed("ui_use_relic"):
			currentItem.Use()
			itemNode.remove_child(currentItem)
			currentItem.queue_free()
			currentItem = null
			level.UpdateItemSprite(null)
			
func PickUpWeapon(weapon: Node2D):
	weapon.get_parent().call_deferred("remove_child", weapon)
	weaponNode.call_deferred("remove_child", currentWeapon)
	weaponNode.call_deferred("add_child", weapon)
	currentWeapon = weapon

func PickUpItem(item : Node2D):
	item.get_parent().call_deferred("remove_child", item)
	itemNode.call_deferred("remove_child", currentItem)
	itemNode.call_deferred("add_child", item)
	currentItem = item
	level.UpdateItemSprite(currentItem.GetSpritePath())

func MinusHealth(amount : int):
	stats.SetHealth(amount)
	healthBar._set_health(stats.ReturnHealth())
	




func Dash():
	if Input.is_action_just_pressed("dash") && canDash:
		velocity *= 50
		canDash = false
		await get_tree().create_timer(3.0).timeout
		canDash = true
	
func PickUpBomerang():
	currentWeapon.currentAmmo += 1
	currentWeapon.sprite.set_visible(true)
