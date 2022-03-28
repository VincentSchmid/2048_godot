extends Node


const ANGLE_TOLERANCE_PERCENTAGE = 20;
const MIN_DRAG_DISTANCE = 250;

const DIRECTION_LEFT = 90;
const DIRECTION_RIGHT = -90;
const DIRECTION_UP = 0;
const DIRECTION_DOWN = 180;
const ACTIVE_SCREEN_HEIGHT = 2400

signal swiped(swipe_direction)

var SwipeDirection = Enums.SwipeDirection
var listen_to_swipe = false
var start_touch_pos = Vector2(0, 0);
var current_touch_pos: Vector2
var move_registered = false

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed() and event.position.y < ACTIVE_SCREEN_HEIGHT:
		listen_to_swipe = true
		start_touch_pos = event.position
		current_touch_pos = event.position
		
	elif event is InputEventScreenTouch and not event.is_pressed():
		listen_to_swipe = false

	elif event is InputEventScreenDrag:
		current_touch_pos = event.position
		

func _process(delta):
	if listen_to_swipe and start_touch_pos.distance_to(current_touch_pos) >= MIN_DRAG_DISTANCE:
		var swipe_direction = _get_swipe_direction(start_touch_pos, current_touch_pos)
		listen_to_swipe = false
		
		if swipe_direction != SwipeDirection.NONE:
				emit_signal("swiped", swipe_direction);


func _get_swipe_direction(start_touch, end_touch) -> int:
	var difference = start_touch - end_touch;
	var distance = start_touch.distance_to(end_touch)
	var angle = rad2deg(atan2(difference.x, difference.y));

	if distance >= MIN_DRAG_DISTANCE:
		if _is_in_range(angle, DIRECTION_LEFT, ANGLE_TOLERANCE_PERCENTAGE):
			return SwipeDirection.SWIPE_LEFT;
		
		elif _is_in_range(angle, DIRECTION_RIGHT, ANGLE_TOLERANCE_PERCENTAGE):
			return SwipeDirection.SWIPE_RIGHT;

		elif _is_in_range(angle, DIRECTION_DOWN, ANGLE_TOLERANCE_PERCENTAGE):
			return SwipeDirection.SWIPE_DOWN;
		
		elif _is_in_range(angle, DIRECTION_UP, ANGLE_TOLERANCE_PERCENTAGE):
			return SwipeDirection.SWIPE_UP;
	
	return SwipeDirection.NONE;

func _is_in_range(actual_angle, expected_angle, tolerance) -> bool:
	var top_range = expected_angle + tolerance
	var bottom_range = expected_angle - tolerance

	if expected_angle == 180:
		if actual_angle + tolerance > 180:
			return true
			
		if actual_angle - tolerance < -180:
			return true
	
	return actual_angle < top_range and actual_angle > bottom_range;
