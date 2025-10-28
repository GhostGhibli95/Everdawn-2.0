extends TileMapLayer

const GRASS_ATLAS = 0
const SOIL_ATLAS = 1
const GRASS_COORDS = Vector2i(1,1)
const SOIL_COORDS = Vector2i(1,1)

var player
var tile_indicator

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	tile_indicator = ColorRect.new()
	tile_indicator.color = Color(1, 0, 0, 0.5)
	tile_indicator.size = Vector2(16, 16)
	tile_indicator.visible = false
	add_child(tile_indicator)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			till_tile_at_mouse()
	
	if event is InputEventMouseMotion:
		update_tile_indicator()

func get_target_tile_and_direction():
	if not player:
		return null
	
	var mouse_pos = get_global_mouse_position()
	var player_pos = player.global_position
	var direction_vector = mouse_pos - player_pos
	
	var direction = ""
	var tile_pos
	var player_tile = local_to_map(to_local(player_pos))
	
	if abs(direction_vector.x) > abs(direction_vector.y):
		if direction_vector.x > 0:
			direction = "right"
			tile_pos = player_tile + Vector2i(1, 0)
		else:
			direction = "left"
			tile_pos = player_tile + Vector2i(-1, 0)
	else:
		if direction_vector.y > 0:
			direction = "down"
			tile_pos = player_tile + Vector2i(0, 1)
		else:
			direction = "up"
			tile_pos = player_tile + Vector2i(0, -1)
	
	return {"tile_pos": tile_pos, "direction": direction}
			
func till_tile_at_mouse():
	var result = get_target_tile_and_direction()
	if not result:
		return
	
	var tile_pos = result["tile_pos"]
	var direction = result["direction"]
	
	var current_tile = get_cell_source_id(tile_pos)
	var current_coords = get_cell_atlas_coords(tile_pos)
	
	if current_tile == -1:
		print("No tile at that position!")
		return
	
	if current_tile == GRASS_ATLAS and current_coords == GRASS_COORDS:
		player.play_till_animation(direction)
		set_cell(tile_pos, SOIL_ATLAS, SOIL_COORDS)
		print("Tilled soil to the ", direction)
	else:
		print("Can't till this tile")

func update_tile_indicator():
	var result = get_target_tile_and_direction()
	if not result:
		return
	
	var tile_pos = result["tile_pos"]
	var world_pos = map_to_local(tile_pos)
	
	# Position centered on tile
	tile_indicator.position = world_pos - Vector2(8, 8)
	tile_indicator.visible = true
