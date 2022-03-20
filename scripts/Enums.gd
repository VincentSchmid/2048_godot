class_name Enums

enum SwipeDirection {
	SWIPE_UP,
	SWIPE_DOWN,
	SWIPE_LEFT,
	SWIPE_RIGHT,
	NONE
}

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	NONE
}

static func swipe_to_dir(swipeDirection):
	return Direction.get(int(swipeDirection))
