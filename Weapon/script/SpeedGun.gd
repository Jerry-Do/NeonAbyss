
extends Weapon


var _cMaxAmmo = 99
var _cRateOfFire = 0.25
var _cReloadTime = 2

func _init():
	super._init("res://Weapon/bullet/bullet.tscn", _cRateOfFire, _cMaxAmmo, _cReloadTime)
	if pickedUpFlag:
		$CanvasLayer.show()
		$CanvasLayer.get_child(0).initialize()
	
func _process(delta):
	super._process(delta)	

func shoot():
	if(currentAmmo > 0 && shootFlag):
		for n in 3:
			var BULLET = load(self.bulletName)
			var new_bullet = BULLET.instantiate()
			new_bullet.global_position = %Shootingpoint.global_position
			new_bullet.global_rotation = %Shootingpoint.global_rotation
			%Shootingpoint.add_child(new_bullet)
			currentAmmo -=1
			shootFlag = false
			await get_tree().create_timer(0.05).timeout
		$Cooldown.start(self.rateOfFire  if game_manager.timeSlowFlag == false else self.rateOfFire * 0.25)
		
