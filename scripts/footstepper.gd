extends AudioStreamPlayer3D

@onready var  character: CharacterBody3D = get_parent()

func play_footstep() -> void:
	if not character.is_on_floor():
		return
	
	for i in character.get_slide_collision_count():
		var collision := character.get_slide_collision(i)
		if collision.get_normal() == character.get_floor_normal():
			var collider := collision.get_collider()
			if collider is WorldSounds:
				var info := collider as WorldSounds
				stream = info.foorstep_sounds
				break
	
	play()
				
