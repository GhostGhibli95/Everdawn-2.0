extends CanvasLayer

var current_slot = 0
var slots = []


func _ready() -> void:
    add_to_group("ui")
    slots = $HBoxContainer.get_children()

    
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_WHEEL_UP:
             current_slot = (current_slot + 1) % 10
             update_slot_colors()
        elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            current_slot = (current_slot - 1 + 10) % 10
            update_slot_colors()

func update_slot_colors():
    for i in range(10):
        slots[i].color = Color(1,1,1)
        slots[current_slot].color = Color(0,0,0)
        
func update_inventory_display(player_inventory):
    for i in range(10):
        var icon = slots[i].get_node("Icon")
        if player_inventory[i]["Item"] == null:
            icon.visible = false
        else:
            icon.visible = true
            icon.texture = player_inventory[i]["Icon"]
        
