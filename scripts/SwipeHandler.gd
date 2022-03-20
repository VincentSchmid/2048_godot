extends Node


# Touch Variables
var first_touch = Vector2(0, 0);

const ANGLE_TOLERANCE_PERCENTAGE = 20;
const MIN_DRAG_DISTANCE = 25;

const DIRECTION_LEFT = 90;
const DIRECTION_RIGHT = -90;
const DIRECTION_UP = 0;
const DIRECTION_DOWN = 180;

signal swiped(swipe_direction)

var SwipeDirection = Enums.SwipeDirection

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			first_touch = event.position;
		else:
			var final_touch = event.position;
			var swipe_direction = _get_swipe_direction(first_touch, final_touch)

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
