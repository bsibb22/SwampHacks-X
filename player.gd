extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	print(str(str(name).to_int()))


func _physics_process(delta: float) -> void:
	#print("Player ID: " + str(multiplayer.get_unique_id()) + "\nAuth ID: " + str($MultiplayerSynchronizer.get_multiplayer_authority()))
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		#print("Player ID In LOOP: " + str(multiplayer.get_unique_id()))
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
