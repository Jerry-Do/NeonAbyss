extends BaseBullet

var c_damage = 8
var c_speed = 30
var current_velocity
var lock_on_target

func _init():
	super._init(c_damage, c_speed)
func _ready():
	current_velocity = speed * Vector2.RIGHT.rotated(rotation)
func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation).normalized()
	if lock_on_target != null:
		direction = global_position.direction_to(lock_on_target.global_position)
	var desired_velocity = direction * speed
	var previous_velocity = current_velocity
	var change = (desired_velocity - current_velocity)
	current_velocity += change
	position += current_velocity * speed * delta
	look_at(global_position + current_velocity)
	travelled_dist += speed * delta
	if travelled_dist > RANGE:
		queue_free()


func _on_detection_range_body_entered(body):
	if lock_on_target != null:
		return
	if body.has_method("MinusHealth"):
		print("lock on")
		if body.is_target:
			lock_on_target = body



func _on_area_entered(area):
	var random
	if get_node("../../../../../../Player").can_crit:
		random = RandomNumberGenerator.new().randi_range(1, 5)
	if area.has_method("TakingDamageForEnemy"):
		area.TakingDamageForEnemy(damage if random != 1 else damage * 2, true if area.get_name() == "Back" else false)
		if random == 10:
			print("crit")
			var crit_label = preload("res://UI/Critlabel.tscn")
			var new_label = crit_label.instantiate()
			get_node("../../../../../../../Level").add_child(new_label)
			new_label.position = position	
		queue_free()
		
