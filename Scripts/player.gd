extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var speed = 130
var last_direction = Vector2.DOWN
var is_tilling = false

var inventory = [
	{"Item": null, "Icon": null,  "Quantity": 0},
	{"Item": null, "Icon": null,  "Quantity": 0},
	{"Item": null, "Icon": null,  "Quantity": 0},
	{"Item": null, "Icon": null,  "Quantity": 0},
	{"Item": null, "Icon": null,  "Quantity": 0},
	{"Item": null, "Icon": null,  "Quantity": 0},
	{"Item": null, "Icon": null,  "Quantity": 0},
	{"Item": null, "Icon": null,  "Quantity": 0},
	{"Item": null, "Icon": null,  "Quantity": 0},
	{"Item": null, "Icon": null,  "Quantity": 0},
]
var nearby_items = []


func _ready() -> void:
	anim.play('idle')
	add_to_group("player")
	
	$PickupRange.area_entered.connect(_on_pickup_area_entered)
	$PickupRange.area_exited.connect(_on_pickup_area_exited)
	
	
	
	 
func get_input():
	var input_direction = Input.get_vector("left","right","up","down")
	velocity = input_direction * speed
	if input_direction != Vector2.ZERO:
		last_direction = input_direction
	
func _physics_process(_delta: float) -> void:
	if is_tilling:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	get_input()
	move_and_slide()
	update_animation()
	pick_up_item()
	
	
func update_animation():
	if velocity != Vector2.ZERO:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				anim.play('walk_right')
			else:
				anim.play("walk_left")
		else:
			if velocity.y > 0:
				anim.play("walk_down")
			else:
				anim.play("walk_up")
	else:
		if abs(last_direction.x) > abs(last_direction.y):
			if last_direction.x > 0:
				anim.play('right_idle')
			else:
				anim.play('left_idle')
		else:
			if last_direction.y > 0:
				anim.play('idle')
			else:
				anim.play('up_idle')
				
func play_till_animation(direction: String):
	is_tilling = true
	
	match direction:
		"up":
			anim.play("till_up")
		"down":
			anim.play("till_down")
		"left":
			anim.play("till_left")
		"right":
			anim.play("till_right")
			
	await anim.animation_finished
	is_tilling = false
	
func pick_up_item():
	if Input.is_action_just_pressed("Action"):
		print("action button pressed")
		if nearby_items.size() > 0:
			var item = nearby_items[0]
			for i in range(10):
				if inventory[i]["Item"] == null:
					inventory[i]["Item"] = item.item_name
					inventory[i]["Icon"] = item.item_icon
					inventory[i]["Quantity"] = 1
					print(inventory)
					break
				elif inventory[i]["Item"] == item.item_name:
					inventory[i]["Quantity"] += 1
					print(inventory)
					break
			item.queue_free()
			get_tree().call_group("ui", "update_inventory_display", inventory)
			print("Item Nearby")
			
			
	

func _on_pickup_area_entered(area):
	nearby_items.append(area)
	print("Item nearby: ", area.name)

func _on_pickup_area_exited(area):
	nearby_items.erase(area)
	print("Item left range: ", area.name)
	
  
