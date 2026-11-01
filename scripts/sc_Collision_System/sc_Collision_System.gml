#region Init
enum SlopeCheckFlag {
	NONE = 0,
	GROUND_UP = 1,
	GROUND_DOWN = 2,
	AIR_UP = 4,
	AIR_DOWN = 8,
	SIDEWAYS = 16,
	ALL = 31
}

enum Exclude {
	NONE = 0, 
	SLOPES = 1,
	SOLIDS = 2,
	MOVING = 4,
	PLATFORMS = 8,
	ALL = 15 
}

function scr_collision_init()
{
	usesCollision = true
	ground = false
	groundedSlope = false	
	terminalVelocity = 10
	onMovingPlatform = noone

	grav = 0.3		
	hsp = 0
	vsp = 0
	prevHsp = 0
	prevVsp = 0

	fracHsp = 0
	fracVsp = 0
	
	hspCarry = 0
	vspCarry = 0

	slopeMovementFlags = SlopeCheckFlag.GROUND_DOWN | SlopeCheckFlag.GROUND_UP
	slopeMaxDistance = 4
}

function sc_Entity_Physics()
{
	if (vsp < terminalVelocity) {
		vsp += grav
	}
}

function math_absfloor(val)
{
	return (val > 0 ? floor(val) : ceil(val))
}
#endregion



#region Move And Collide script
function sc_Entity_Collision()
{
	var _old_grounded = ground
	ground = false
	onMovingPlatform = noone

	with (obj_movingPlatform)
	{
		if (!hasMove) {
			self.moveCode()
		}
		
		var _hspeed = (x - xprevious)
		var _vspeed = (y - yprevious)
		with (other.id) {
			x += _hspeed
			y += _vspeed
			if (place_meeting_collision(x, y + 1, ~Exclude.MOVING) && place_meeting(x, y + 1, other)) {
				onMovingPlatform = other.id
			}
			x -= _hspeed
			y -= _vspeed			
		}
	}

	if (instance_exists(onMovingPlatform))
	{
		with (onMovingPlatform) {
			var _hsp = round(x - xprevious)
			var _vsp = round(y - yprevious)		
			with (other.id) {
				repeat (abs(_hsp)) {	
					if (!place_meeting_collision(x + sign(_hsp), y)) {
						x += sign(_hsp) 
					} else {
						_hsp = 0
						break
					}
				}
				repeat (abs(_vsp)) {	
					if (!place_meeting_collision(x, y + sign(_vsp))) {
						y += sign(_vsp) 
					} else {
						_vsp = 0
						break
					}
				}
			}
		}
	}

	var _true_hsp = hsp
	var _true_vsp = vsp
	
	var _final_hsp = (hsp + hspCarry)
	var _final_vsp = (vsp + vspCarry)
	
	hsp = math_absfloor(_final_hsp)
	vsp = math_absfloor(_final_vsp)
	var _whole_integer = 0
	
	fracHsp += (_final_hsp - hsp) 
	if (abs(fracHsp) >= 1) {
		_whole_integer = math_absfloor(fracHsp)
		hsp += _whole_integer
		fracHsp -= _whole_integer
	}	
	
	fracVsp += (_final_vsp - vsp)
	if (abs(fracVsp) >= 1) {
		_whole_integer = math_absfloor(fracVsp)
		vsp += _whole_integer
		fracVsp -= _whole_integer
	}	

	var _current_bbox_height = (bbox_bottom - bbox_top)
	var _remaining_vsp = vsp
	var _move_steps_v = ceil((abs(vsp) / _current_bbox_height))
	var _move_vsp
	
	repeat (_move_steps_v)
	{
		_move_vsp = clamp(abs(_remaining_vsp), 0, _current_bbox_height) * sign(_remaining_vsp)

		if (place_meeting_collision(x, y + _move_vsp)) { 
			repeat (abs(_move_vsp)) {	
			
				if (isCollisionFlagSet(slopeMovementFlags, SlopeCheckFlag.SIDEWAYS) && vsp < 0) {
					x -= slope_check_left(x, y + sign(_move_vsp), slopeMaxDistance)
					x += slope_check_right(x, y + sign(_move_vsp), slopeMaxDistance)
				}	
			
				if (!place_meeting_collision(x, y + sign(_move_vsp))) {
					y += sign(_move_vsp) 
				} else {
					_move_vsp = 0					
					_true_vsp = 0
					_remaining_vsp = 0
					fracVsp = 0
					vsp = 0
					break
				}
			}
		}
		
		y += _move_vsp	
		_remaining_vsp -= _move_vsp		
	}

	var _current_bbox_width = (bbox_right - bbox_left)
	var _remaining_hsp = hsp
	var _move_steps_h = ceil((abs(hsp) / _current_bbox_width))
	var _move_hsp
	
	repeat (_move_steps_h)
	{
		_move_hsp = clamp(abs(_remaining_hsp), 0, _current_bbox_width) * sign(_remaining_hsp)
		var _on_ground = place_meeting_collision(x, y + 1)
		
		if (place_meeting_collision(x + _move_hsp, y)) {
			repeat (abs(_move_hsp)) {
				
				if (isCollisionFlagSet(slopeMovementFlags, SlopeCheckFlag.GROUND_UP)) {
					y -= slope_check_up(x + sign(_move_hsp), y, slopeMaxDistance)			
				}
				
				if (isCollisionFlagSet(slopeMovementFlags, SlopeCheckFlag.AIR_DOWN) && !_on_ground) {
					y += reverseSlope_check_down(x + sign(_move_hsp), y, slopeMaxDistance)
				}
		
				if (isCollisionFlagSet(slopeMovementFlags, SlopeCheckFlag.AIR_UP) && vsp <= 0 && place_meeting_collision(x, y - 1)) {
					y -= reverseSlope_check_up(x + sign(_move_hsp), y, slopeMaxDistance)
				}
				
				if (!place_meeting_collision(x + sign(_move_hsp), y)) {
					x += sign(_move_hsp) 
				} else {
					_move_hsp = 0					
					_true_hsp = 0
					_remaining_hsp = 0
					fracHsp = 0
					hsp = 0
					break
				}
			}
			break
		}
		
		x += _move_hsp	
		
		if (isCollisionFlagSet(slopeMovementFlags, SlopeCheckFlag.GROUND_DOWN) && _on_ground && vsp >= 0 && !place_meeting_collision(x, y + 1) && place_meeting_collision(x, y + abs(_move_hsp) + 1)) {
			while (!place_meeting_collision(x, y + 1)) {
				y++
			}
		}		
			
		_remaining_hsp -= _move_hsp	
	}	

	hsp = _true_hsp
	vsp = _true_vsp	
	hspCarry = 0
	vspCarry = 0	

	ground = place_meeting_collision(x, y + 1)
	groundedSlope = place_meeting_slope(x, y + 1)
	
	if (!ground && _old_grounded && instance_exists(onMovingPlatform)) {
		hspCarry = (onMovingPlatform.x - onMovingPlatform.xprevious) / 2
		vspCarry = (onMovingPlatform.y - onMovingPlatform.yprevious) / 2
	}
	
	prevHsp = hsp
	prevVsp = vsp	
}


#endregion

#region Checking
function instance_place_list_collision(xx, yy, exclude = Exclude.NONE, list = undefined)
{
	var collided = 0
	var check_slopes = !isCollisionFlagSet(exclude, Exclude.SLOPES)
	var check_solids = !isCollisionFlagSet(exclude, Exclude.SOLIDS)
	var check_platforms = !isCollisionFlagSet(exclude, Exclude.PLATFORMS)
	var check_moving = !isCollisionFlagSet(exclude, Exclude.MOVING)

	if (check_solids) {
		collided += instance_place_list_solid(xx, yy, , list)
		collided += instance_place_list_slopeSolid(xx, yy, , list)
	}
	
	if (check_slopes) {
		if (check_solids) {
			collided += instance_place_list_slope(xx, yy, , list)
		}
		if (check_platforms) {
			collided += instance_place_list_slopePlatform(xx, yy, , list)		
		}
	}
	if (check_platforms) {
		collided += instance_place_list_platform(xx, yy, , list)
		collided += instance_place_list_sidePlatform(xx, yy, , list)
	}
	if (check_moving) {
		collided += instance_place_list_platform(xx, yy, obj_movingPlatform, list)
	}
	return collided
}

function place_meeting_collision(xx, yy, exclude = Exclude.NONE)
{
	var check_slopes = Exclude.SLOPES&exclude != Exclude.SLOPES
	var check_solids = Exclude.SOLIDS&exclude != Exclude.SOLIDS
	var check_platforms = Exclude.PLATFORMS&exclude != Exclude.PLATFORMS
	var check_moving = Exclude.MOVING&exclude != Exclude.MOVING

	if (check_solids) {
		if (place_meeting_solid(xx, yy)) {
			return true
		}		
		if (place_meeting_slopeSolid(xx, yy)) {
			return true
		}		
	}
	
	if (check_slopes) {
		if (check_solids) {
			if (place_meeting_slope(xx, yy, false)) {
				return true
			}
		}
		if (check_platforms) {
			if (place_meeting_slopePlatform(xx, yy)) {
				return true
			}			
		}
	}
	if (check_platforms) {
		if (place_meeting_platform(xx, yy)) {
			return true
		}
		if (place_meeting_sidePlatform(xx, yy)) {
			return true
		}
	}
	if (check_moving) {
		if (place_meeting_platform(xx, yy, obj_movingPlatform)) {
			return true
		}
	}
	return false
}	

function position_meeting_collision(xx, yy, exclude = Exclude.NONE)
{
	var old_mask = mask_index
	mask_index = spr_pixel
	var check_collision = (place_meeting_collision(xx, yy, exclude))	
	mask_index = old_mask
	return check_collision	
}	

#endregion

#region Static objects and Platforms
function instance_place_list_solid(xx, yy, obj = obj_solid, list = undefined)
{
	var collided = 0
	var col_number = instance_place_list(xx, yy, obj, global.MyCollisionList, false)
	if (col_number > 0) {
		for (var i = 0; i < col_number; ++i;) {
			var col_object = (global.MyCollisionList[| i])
			var special_colcheck = true
			if (variable_instance_exists(col_object, "canCollide")) {
				special_colcheck = col_object.canCollide(object_index)
			}			
			if (special_colcheck) {			
				collided++
				if (!is_undefined(list)) {
					ds_list_add(list, col_object.id)
				} else {
					break
				}
			}
		}
		ds_list_clear(global.MyCollisionList)
	}
	return (collided)	
}

function place_meeting_solid(xx, yy, obj = obj_solid)
{
	return (instance_place_list_solid(xx, yy, obj) > 0)
}

function position_meeting_solid(xx, yy, obj = obj_solid)
{
	var old_mask = mask_index
	mask_index = spr_pixel
	var check_collision = (instance_place_list_solid(xx, yy, obj) > 0)
	mask_index = old_mask
	return check_collision
}

function instance_place_list_platform(xx, yy, obj = obj_oneWay_vertical, list = undefined)
{
	var collided = 0
	var col_number = instance_place_list(xx, yy, obj, global.MyCollisionList, false)
	if (col_number > 0) {
		for (var i = 0; i < col_number; ++i;) {
			var col_object = (global.MyCollisionList[| i])
			var special_colcheck = true
			if (variable_instance_exists(col_object, "canCollide")) {
				special_colcheck = col_object.canCollide(object_index)
			}			
			var platform_check = (sign(col_object.image_yscale) < 0 ? yy <= y : yy >= y)			
			if (special_colcheck && platform_check && !place_meeting(xx, y, col_object)) {			
				collided++
				if (!is_undefined(list)) {
					ds_list_add(list, col_object.id)
				} else {
					break
				}
			}
		}
		ds_list_clear(global.MyCollisionList)
	}
	return (collided)
}

function instance_place_list_sidePlatform(xx, yy, obj = obj_oneWay_horizontal, list = undefined)
{
	var collided = 0
	var col_number = instance_place_list(xx, yy, obj, global.MyCollisionList, false)
	if (col_number > 0) {
		for (var i = 0; i < col_number; ++i;) {
			var col_object = (global.MyCollisionList[| i])
			var special_colcheck = true
			if (variable_instance_exists(col_object, "canCollide")) {
				special_colcheck = col_object.canCollide(object_index)
			}			
			var s_platform_check = (sign(col_object.image_xscale) < 0 ? xx >= x : xx <= x)			
			if (special_colcheck && s_platform_check && !place_meeting(x, yy, col_object)) {			
				collided++
				if (!is_undefined(list)) {
					ds_list_add(list, col_object.id)
				} else {
					break
				}
			}	
		}
		ds_list_clear(global.MyCollisionList)
	}
	return (collided)
}

function place_meeting_platform(xx, yy, obj = obj_oneWay_vertical)
{
	return (instance_place_list_platform(xx, yy, obj) > 0)
}

function position_meeting_platform(xx, yy, obj = obj_oneWay_vertical)
{
	var old_mask = mask_index
	mask_index = spr_pixel
	var check_collision = (instance_place_list_platform(xx, yy, obj) > 0)
	mask_index = old_mask
	return check_collision
}

function place_meeting_sidePlatform(xx, yy, obj = obj_oneWay_horizontal)
{
	return (instance_place_list_sidePlatform(xx, yy, obj) > 0)
}

function position_meeting_sidePlatform(xx, yy, obj = obj_oneWay_horizontal)
{
	var old_mask = mask_index
	mask_index = spr_pixel
	var check_collision = (instance_place_list_sidePlatform(xx, yy, obj) > 0)
	mask_index = old_mask
	return check_collision
}


#endregion

#region Slopes
function instance_place_list_slopePlatform(xx, yy, obj = obj_slopePlatform, list = undefined)
{
	var old_x = x
	var old_y = y
	var old_bbox_top = bbox_top
	var old_bbox_bottom = bbox_bottom	
	x = xx
	y = yy

	var collided = 0
	var slopeplatform_number = instance_place_list(x, y, obj, global.MyCollisionList, false)
	if (slopeplatform_number > 0) {
		for (var i = 0; i < slopeplatform_number; ++i;) {
			var col_object = (global.MyCollisionList[| i])
			var _can_collide = true
			if (variable_instance_exists(col_object, "canCollide")) {
				_can_collide = col_object.canCollide(object_index)
			}
			if (_can_collide) {			
				var object_side =  col_object.image_xscale > 0 ? bbox_right : bbox_left
				object_side = (object_side - x) + old_x
				var player_pos = point_direction(col_object.x + col_object.sprite_width, col_object.y + col_object.sprite_height, x, y)
				var _xx = col_object.x + sign(col_object.image_xscale), _yy = col_object.y, w = col_object.sprite_width, h = col_object.sprite_height
				var _check1
				if (col_object.image_yscale > 0) {
					_check1 = col_object.image_xscale > 0 ? (player_pos <= 180 && player_pos >= 90) : (player_pos <= 90 && player_pos >= 0)
				} else {
					_check1 = col_object.image_xscale > 0 ? (player_pos <= 270 && player_pos >= 180) : ((player_pos <= 360 || player_pos <= 0) && player_pos >= 270)
				}
				var _check2 = !triangle_meeting(old_x, old_y, _xx, _yy + h, _xx + w, _yy, _xx + w, _yy + h)
				var _check3 = (col_object.image_xscale > 0 ? object_side <= col_object.bbox_left : object_side >= col_object.bbox_right)
				if (_check1 && (_check2 || _check3) && (col_object.image_yscale > 0 ? old_bbox_bottom <= col_object.bbox_bottom : old_bbox_top >= col_object.bbox_top) && triangle_meeting(x, y, _xx, _yy + h, _xx + w, _yy, _xx + w, _yy + h)) {
					collided++
					if (!is_undefined(list)) {
						ds_list_add(list, col_object.id)
					} else {
						break
					}
				}						
			}	
		}
		ds_list_clear(global.MyCollisionList)
	}
	x = old_x
	y = old_y	
	return collided
}

function place_meeting_slopePlatform(xx, yy, obj = obj_slopePlatform)
{
	return (instance_place_list_slopePlatform(xx, yy, obj) > 0)
}

function position_meeting_slopePlatform(xx, yy, obj = obj_slopePlatform)
{
	var old_mask = mask_index
	mask_index = spr_pixel
	var check_collision = (instance_place_list_slopePlatform(xx, yy, obj) > 0)
	mask_index = old_mask
	return check_collision
}

function instance_place_list_slope(xx, yy, obj = obj_slope, list = undefined)
{
	var collided = 0
	var col_number = instance_place_list(xx, yy, obj, global.MyCollisionList, false)
	if (col_number > 0) {
		for (var i = 0; i < col_number; ++i;) {
			var col_object = (global.MyCollisionList[| i])
			var special_colcheck = true
			if (variable_instance_exists(col_object, "canCollide")) {
				special_colcheck = col_object.canCollide(object_index)
			}			
			var _xx = col_object.x + sign(col_object.image_xscale), _yy = col_object.y, w = col_object.sprite_width, h = col_object.sprite_height
			if (special_colcheck && triangle_meeting(xx, yy, _xx, _yy + h, _xx + w, _yy, _xx + w, _yy + h)) {			
				collided++
				if (!is_undefined(list)) {
					ds_list_add(list, col_object.id)
				} else {
					break
				}
			}
		}
		ds_list_clear(global.MyCollisionList)
	}
	return (collided)		
}

function place_meeting_slope(xx, yy, check_slopePlatform = true, obj = obj_slope)
{
	var _check2 = (check_slopePlatform ? place_meeting_slopePlatform(xx, yy) : false)
	return (instance_place_list_slope(xx, yy, obj) > 0 || _check2)
}

function position_meeting_slope(xx, yy, obj = obj_slope)
{
	var old_mask = mask_index
	mask_index = spr_pixel
	var check_collision = (instance_place_list_slope(xx, yy, obj) > 0)
	mask_index = old_mask
	return check_collision
}

function instance_place_list_slopeSolid(xx, yy, obj = obj_slope, list = undefined)
{
	var collided = 0
	var col_number = instance_place_list(xx, yy, obj, global.MyCollisionList, false)
	if (col_number > 0) {
		for (var i = 0; i < col_number; ++i;) {
			var col_object = (global.MyCollisionList[| i])
			var special_colcheck = true
			if (variable_instance_exists(col_object, "canCollide")) {
				special_colcheck = col_object.canCollide(object_index)
			}			
			var check_dir = (xx - x)
			var check_1 = (sign(col_object.image_xscale) == -check_dir)
			var check_2 = (col_object.image_yscale < 0 ? bbox_bottom <= col_object.bbox_top : bbox_top >= col_object.bbox_bottom)
			var _xx = col_object.x + sign(col_object.image_xscale), _yy = col_object.y, w = col_object.sprite_width, h = col_object.sprite_height
			if (special_colcheck && (check_1 || check_2) && triangle_meeting(xx, yy, _xx, _yy + h, _xx + w, _yy, _xx + w, _yy + h)) {			
				collided++
				if (!is_undefined(list)) {
					ds_list_add(list, col_object.id)
				} else {
					break
				}
			}
		}
		ds_list_clear(global.MyCollisionList)
	}
	return (collided)	
}

function place_meeting_slopeSolid(xx, yy, obj = obj_slope)
{
	return (instance_place_list_slopeSolid(xx, yy, obj) > 0)
}

function position_meeting_slopeSolid(xx, yy, obj = obj_slope)
{
	var old_mask = mask_index
	mask_index = spr_pixel
	var check_collision = (instance_place_list_slopeSolid(xx, yy, obj) > 0)
	mask_index = old_mask
	return check_collision
}

function slope_check_up(x_pos, y_pos, max_units = 3)
{
	for (var i = max_units; i > 0; --i) {
		var _check = true
		var _z = (i - 1)
		repeat (i - 1) {
			if (!place_meeting_collision(x_pos, y_pos - _z)) {
				_check = false
			}
			_z--
		}
		if (place_meeting_collision(x_pos, y_pos) && _check && !place_meeting_collision(x_pos, y_pos - i)) {
			return i
		}
	}
	return 0	
}

function slope_check_down(x_pos, y_pos, max_units = 3)
{
	for (var i = 1; i < max_units + 1; ++i) {
		var _check = true
		var _z = 1
		repeat (i) {
			if (place_meeting_collision(x_pos, y_pos + _z)) {
				_check = false
			}
			_z++
		}			
		if (!place_meeting_collision(x_pos, y_pos) && _check && place_meeting_collision(x_pos, y_pos + (i + 1))) {
			return i
		}
	}	
	return 0	
}

function slope_check_left(x_pos, y_pos, max_units = 3)
{
	for (var i = 0; i < max_units; ++i) {
		if (place_meeting_collision(x_pos, y_pos) && !place_meeting_collision(x_pos - i, y_pos)) {
			return i
		}
	}
	return 0	
}

function slope_check_right(x_pos, y_pos, max_units = 3)
{
	for (var i = 0; i < max_units; ++i) {
		if (place_meeting_collision(x_pos, y_pos) && !place_meeting_collision(x_pos + i, y_pos)) {
			return i
		}
	}
	return 0		
}	

function reverseSlope_check_down(x_pos, y_pos, max_units = 3)
{
	for (var i = 0; i < max_units; ++i) {
		if (place_meeting_collision(x_pos, y_pos) && !place_meeting_collision(x_pos, y_pos + i)) {
			return i
		}
	}
	return 0	
}

function reverseSlope_check_up(x_pos, y_pos, max_units = 3)
{
	for (var i = 0; i < max_units; ++i) {
		if (!place_meeting_collision(x_pos, y_pos) && !place_meeting_collision(x_pos, y_pos - i) && place_meeting_collision(x_pos, y_pos - (i + 1))) {
			return i
		}		
	}
	return 0		
}


#endregion

#region Utilites
function bbox_in_rectangle(obj, dx1, dy1, dx2, dy2)
{	
	if (!instance_exists(obj)) {
		return false
	}
	return rectangle_in_rectangle(obj.bbox_left, obj.bbox_top, obj.bbox_right, obj.bbox_bottom, dx1, dy1, dx2, dy2)
}

function place_meeting_adjacent(obj)
{
	return ( (place_meeting(x, y, obj))
	|| (place_meeting(x - 1, y, obj))
	|| (place_meeting(x + 1, y, obj))
	|| (place_meeting(x, y - 1, obj))
	|| (place_meeting(x, y + 1, obj))
	|| (place_meeting(x - 1, y - 1, obj))
	|| (place_meeting(x + 1, y - 1, obj))
	|| (place_meeting(x - 1, y + 1, obj))
	|| (place_meeting(x + 1, y + 1, obj)))
}

function place_meeting_collision_adjacent(exclude)
{
	return ( (place_meeting_collision(x, y, exclude))
	|| (place_meeting_collision(x - 1, y, exclude))
	|| (place_meeting_collision(x + 1, y, exclude))
	|| (place_meeting_collision(x, y - 1, exclude))
	|| (place_meeting_collision(x, y + 1, exclude))
	|| (place_meeting_collision(x - 1, y - 1, exclude))
	|| (place_meeting_collision(x + 1, y - 1, exclude))
	|| (place_meeting_collision(x - 1, y + 1, exclude))
	|| (place_meeting_collision(x + 1, y + 1, exclude)))
}

function triangle_meeting(sx, sy, x1, y1, x2, y2, x3, y3)
{
	var old_x = x
	var old_y = y
	x = sx
	y = sy
	var result = (rectangle_in_triangle(bbox_left, bbox_top, bbox_right, bbox_bottom, x1, y1, x2, y2, x3, y3) > 0)
	x = old_x
	y = old_y	
	return result
}

function isCollisionFlagSet(flags, flagToCheck)
{
	return (flags & flagToCheck) == flagToCheck
}

#endregion