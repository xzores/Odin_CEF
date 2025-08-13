package cef_internal

import "core:c"

///
/// Structure representing a point.
///
point :: struct {
	x: c.int,
	y: c.int,
}

///
/// Structure representing a rectangle.
///
rect :: struct {
	x: c.int,
	y: c.int,
	width: c.int,
	height: c.int,
}

///
/// Structure representing a size.
///
size :: struct {
	width: c.int,
	height: c.int,
}

///
/// Structure representing insets.
///
insets :: struct {
	top: c.int,
	left: c.int,
	bottom: c.int,
	right: c.int,
}
